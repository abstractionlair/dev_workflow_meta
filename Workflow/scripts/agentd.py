#!/usr/bin/env python3
"""
agentd.py - Autonomous agent daemon for workflow roles

This daemon spawns AI model CLIs to process workflow emails autonomously.
Key design: Fresh context model - each spawn starts with clean slate.

Queue draining behavior:
1. Spawn CLI with fresh context
2. Process all messages in email queue
3. After each message, check for new arrivals
4. Continue until queue empty
5. Exit (don't wait/poll)
6. Next spawn is fresh context again

This approach ensures:
- No context accumulation (prevents token bloat)
- Each session gets recent state from artifacts + emails
- Natural error recovery (failed session doesn't poison future work)

Usage:
  agentd.py <role-name> [options]
  agentd.py --daemon <role-name> [options]

Examples:
  # Run once (drain queue then exit)
  agentd.py spec-reviewer

  # Run as daemon (continuous monitoring)
  agentd.py --daemon spec-reviewer

  # Custom configuration
  agentd.py spec-reviewer --config /path/to/config.json

  # Override maildir
  agentd.py spec-reviewer --maildir ~/Maildir/my-project
"""

import argparse
import json
import logging
import os
import select
import signal
import subprocess
import sys
import tempfile
import time
import tty
import termios
from pathlib import Path
from typing import Dict, List, Optional, Set


class AgentDaemon:
    """Autonomous agent daemon for processing workflow emails"""

    def __init__(
        self,
        role_name: str,
        config_path: Optional[str] = None,
        maildir: Optional[str] = None,
        log_level: str = 'INFO',
    ):
        """
        Initialize agent daemon

        Args:
            role_name: Workflow role to run (e.g., "spec-reviewer")
            config_path: Path to supervisor config JSON
            maildir: Override maildir path
            log_level: Logging level
        """
        self.role_name = role_name
        self.running = True
        self.session_count = 0

        # Setup logging
        self.setup_logging(log_level)

        # Load configuration
        self.config = self.load_config(config_path)

        # Get role configuration
        if role_name not in self.config.get('roles', {}):
            raise ValueError(f"Role '{role_name}' not found in configuration")

        self.role_config = self.config['roles'][role_name]

        # Maildir path
        self.maildir = Path(maildir) if maildir else Path(
            os.environ.get('WORKFLOW_MAILDIR', '~/Maildir/workflow')
        ).expanduser()

        # Setup signal handlers
        signal.signal(signal.SIGTERM, self.signal_handler)
        signal.signal(signal.SIGINT, self.signal_handler)

        self.logger.info(f"Initialized agentd for role: {role_name}")
        self.logger.info(f"Maildir: {self.maildir}")
        self.logger.info(f"CLI: {self.role_config.get('cli')}")

    def setup_logging(self, log_level: str):
        """Setup logging configuration"""
        logging.basicConfig(
            level=getattr(logging, log_level.upper()),
            format='%(asctime)s [%(levelname)s] %(name)s: %(message)s',
            datefmt='%Y-%m-%d %H:%M:%S',
        )
        self.logger = logging.getLogger(f'agentd.{self.role_name}')

    def load_config(self, config_path: Optional[str]) -> Dict:
        """Load supervisor configuration"""
        if config_path:
            path = Path(config_path)
        else:
            # Try default locations
            script_dir = Path(__file__).parent
            workflow_dir = script_dir.parent
            path = workflow_dir / 'config' / 'supervisor-config.json'

        if not path.exists():
            # Return default configuration
            self.logger.warning(f"Config not found at {path}, using defaults")
            return self.get_default_config()

        with open(path) as f:
            return json.load(f)

    def get_default_config(self) -> Dict:
        """Get default configuration"""
        return {
            "roles": {
                "spec-reviewer": {
                    "cli": "claude --role spec-reviewer",
                    "catchup_artifacts": ["project-meta/specs/proposed/*.md", "project-meta/specs/doing/*.md"],
                    "catchup_days": 7,
                    "event_types": ["review-request"],
                },
                "spec-writer": {
                    "cli": "claude --role spec-writer",
                    "catchup_artifacts": ["project-meta/planning/ROADMAP.md", "project-meta/specs/proposed/*.md"],
                    "catchup_days": 7,
                    "event_types": ["approval", "rejection", "clarification-request"],
                },
                "skeleton-reviewer": {
                    "cli": "claude --role skeleton-reviewer",
                    "catchup_artifacts": ["project-meta/specs/todo/*.md", "project-content/src/**/*skeleton*"],
                    "catchup_days": 7,
                    "event_types": ["review-request"],
                },
                "implementer": {
                    "cli": "claude --role implementer",
                    "catchup_artifacts": ["project-meta/specs/todo/*.md", "project-content/tests/**/*.py"],
                    "catchup_days": 7,
                    "event_types": ["approval", "clarification-request", "question"],
                },
            },
            "defaults": {
                "timeout": 600,  # 10 minutes
                "retry_delay": 60,  # 1 minute
                "max_retries": 3,
            }
        }

    def signal_handler(self, signum, frame):
        """Handle shutdown signals"""
        sig_name = signal.Signals(signum).name
        self.logger.info(f"Received {sig_name}, shutting down gracefully...")
        self.running = False

    def find_pending_messages(self) -> List[Dict]:
        """
        Find pending messages for this role using efficient email search

        Returns:
            List of message metadata
        """
        # Import from same directory
        script_dir = Path(__file__).parent
        sys.path.insert(0, str(script_dir))
        from email_tools import EmailTools

        tools = EmailTools(str(self.maildir))

        # Get event types this role handles
        event_types = self.role_config.get('event_types', [])

        # Search for messages
        all_messages = []
        for event_type in event_types:
            messages = tools.search(
                event_type=event_type,
                to_role=self.role_name,
                since=f"{self.role_config.get('catchup_days', 7)}d",
            )
            all_messages.extend(messages)

        # Sort by timestamp (oldest first for processing order)
        all_messages.sort(key=lambda x: x['timestamp'])

        return all_messages

    def create_catchup_prompt(self) -> str:
        """
        Create catch-up prompt for fresh context spawn

        This tells the model:
        1. What artifacts to read for current state
        2. What recent emails to review for context
        3. How to process pending messages

        Returns:
            Catch-up prompt text
        """
        catchup_artifacts = self.role_config.get('catchup_artifacts', [])
        catchup_days = self.role_config.get('catchup_days', 7)

        prompt = f"""# {self.role_name} - Session Catch-Up

You are starting a fresh session as {self.role_name}. Follow this catch-up protocol:

## 1. Read Current State from Artifacts

The following artifacts contain your current work state:

"""

        for artifact_pattern in catchup_artifacts:
            prompt += f"- {artifact_pattern}\n"

        prompt += f"""
Read these files to understand what you're working on.

## 2. Review Recent Email Context

Check emails from the last {catchup_days} days using email-helper.sh:

```bash
# Check for new work
./Workflow/scripts/email-helper.sh recent {catchup_days}

# Find messages relevant to your role
"""

        event_types = self.role_config.get('event_types', [])
        for event_type in event_types:
            if event_type == 'review-request':
                prompt += f"./Workflow/scripts/email-helper.sh find-reviews\n"
            elif event_type == 'approval':
                prompt += f"./Workflow/scripts/email-helper.sh find-approvals\n"
            elif event_type == 'clarification-request':
                prompt += f"./Workflow/scripts/email-helper.sh find-clarifications\n"

        prompt += """```

## 3. Process Pending Messages

For each pending message:

1. Read the full message to understand the request
2. Read the artifacts referenced in X-Artifacts header
3. Perform your role's work (review, write, implement, etc.)
4. Send response email using workflow-notify.sh

## 4. Check for New Arrivals

After processing each message, check for new arrivals:

```bash
./Workflow/scripts/email-helper.sh check-new
```

Continue processing until queue is empty.

## 5. Exit When Done

When no more messages to process, exit cleanly. This session's context will be discarded and the next spawn will start fresh.

---

Begin by reading the artifacts listed above, then check for pending messages.
"""

        return prompt

    def spawn_session(self) -> int:
        """
        Spawn a fresh CLI session to process email queue

        Returns:
            Exit code from CLI process
        """
        self.session_count += 1
        self.logger.info(f"Spawning session #{self.session_count}")

        # Create catch-up prompt
        catchup_prompt = self.create_catchup_prompt()

        # Write prompt to temp file
        with tempfile.NamedTemporaryFile(mode='w', suffix='.md', delete=False) as f:
            prompt_file = f.name
            f.write(catchup_prompt)

        try:
            # Build CLI command
            cli_command = self.role_config.get('cli', 'claude')

            # Add prompt file as initial context
            # This assumes CLI supports reading from file
            # Adjust based on actual CLI interface
            full_command = f"{cli_command} < {prompt_file}"

            self.logger.debug(f"Executing: {full_command}")

            # Run CLI process
            result = subprocess.run(
                full_command,
                shell=True,
                timeout=self.config.get('defaults', {}).get('timeout', 600),
                cwd=Path.cwd(),
            )

            self.logger.info(f"Session #{self.session_count} completed with exit code {result.returncode}")

            return result.returncode

        except subprocess.TimeoutExpired:
            self.logger.error(f"Session #{self.session_count} timed out")
            return 124  # Timeout exit code

        except Exception as e:
            self.logger.error(f"Session #{self.session_count} failed: {e}")
            return 1

        finally:
            # Clean up prompt file
            try:
                os.unlink(prompt_file)
            except:
                pass

    def check_for_keystroke(self, timeout: float = 0.0) -> Optional[str]:
        """
        Check for keystroke with timeout (non-blocking)

        Args:
            timeout: Timeout in seconds (0 = non-blocking)

        Returns:
            Character if key pressed, None otherwise
        """
        if not sys.stdin.isatty():
            return None

        # Save terminal settings
        old_settings = termios.tcgetattr(sys.stdin)

        try:
            # Set terminal to raw mode for immediate character reading
            tty.setcbreak(sys.stdin.fileno())

            # Check if input is available
            readable, _, _ = select.select([sys.stdin], [], [], timeout)

            if readable:
                char = sys.stdin.read(1)
                return char
            else:
                return None

        finally:
            # Restore terminal settings
            termios.tcsetattr(sys.stdin, termios.TCSADRAIN, old_settings)

    def launch_interactive_session(self) -> int:
        """
        Launch interactive CLI session for manual intervention

        Returns:
            Exit code from interactive session
        """
        self.logger.info("Launching interactive session...")
        print("\n" + "="*60)
        print(f"INTERACTIVE MODE - {self.role_name}")
        print("="*60)
        print(f"You are now in an interactive session as {self.role_name}.")
        print("Type your commands below. Exit to return to automatic mode.")
        print("="*60 + "\n")

        # Get CLI command from config
        cli_command = self.role_config.get('cli', 'claude')

        try:
            # Launch interactive CLI
            result = subprocess.run(
                cli_command,
                shell=True,
                cwd=Path.cwd(),
            )

            self.logger.info(f"Interactive session ended with exit code {result.returncode}")

            print("\n" + "="*60)
            print("Returning to automatic mode...")
            print("="*60 + "\n")

            return result.returncode

        except Exception as e:
            self.logger.error(f"Interactive session failed: {e}")
            return 1

    def run_once(self) -> int:
        """
        Run once: drain queue then exit

        Returns:
            Exit code
        """
        self.logger.info("Running in one-shot mode (drain queue then exit)")

        # Check for pending messages
        messages = self.find_pending_messages()

        if not messages:
            self.logger.info("No pending messages found")
            return 0

        self.logger.info(f"Found {len(messages)} pending message(s)")

        # Spawn session to process messages
        exit_code = self.spawn_session()

        # Check if more messages arrived during processing
        messages_after = self.find_pending_messages()

        if len(messages_after) > len(messages):
            self.logger.info(f"New messages arrived during processing ({len(messages_after) - len(messages)} new)")
            self.logger.info("Rerun agentd to process new messages")

        return exit_code

    def run_daemon(self, interval: int = 60, interactive: bool = True):
        """
        Run as daemon: continuous monitoring with optional interactive intervention

        Args:
            interval: Polling interval in seconds
            interactive: Enable interactive intervention on keystroke (default: True)
        """
        if interactive:
            self.logger.info(f"Running in daemon mode (poll every {interval}s) - Press 'i' for interactive mode")
            print(f"\n{self.role_name} daemon running...")
            print(f"Monitoring: {self.maildir}")
            print(f"Press 'i' to enter interactive mode, Ctrl+C to stop\n")
        else:
            self.logger.info(f"Running in daemon mode (poll every {interval}s)")

        while self.running:
            try:
                # Check for interactive intervention request (if enabled and stdin is a tty)
                if interactive and sys.stdin.isatty():
                    key = self.check_for_keystroke(timeout=0.1)
                    if key and key.lower() == 'i':
                        # Launch interactive session
                        self.launch_interactive_session()
                        # Continue monitoring after interactive session ends
                        continue

                # Check for pending messages
                messages = self.find_pending_messages()

                if messages:
                    self.logger.info(f"Found {len(messages)} pending message(s)")
                    print(f"[{time.strftime('%H:%M:%S')}] Processing {len(messages)} message(s)...")

                    # Spawn session
                    self.spawn_session()

                else:
                    self.logger.debug("No pending messages")

                # Sleep until next check (with periodic keystroke checking if interactive)
                if self.running:
                    if interactive and sys.stdin.isatty():
                        # Sleep in small increments to check for keystrokes
                        remaining = interval
                        while remaining > 0 and self.running:
                            sleep_time = min(0.5, remaining)
                            time.sleep(sleep_time)
                            remaining -= sleep_time

                            # Check for intervention
                            key = self.check_for_keystroke(timeout=0.0)
                            if key and key.lower() == 'i':
                                self.launch_interactive_session()
                                break
                    else:
                        time.sleep(interval)

            except KeyboardInterrupt:
                self.logger.info("Interrupted by user")
                break

            except Exception as e:
                self.logger.error(f"Error in daemon loop: {e}", exc_info=True)
                time.sleep(interval)

        self.logger.info("Daemon shutting down")


def main():
    parser = argparse.ArgumentParser(
        description='Autonomous agent daemon for workflow roles',
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog=__doc__
    )

    parser.add_argument('role', help='Workflow role name')
    parser.add_argument('--daemon', action='store_true', help='Run as continuous daemon')
    parser.add_argument('--interval', type=int, default=60, help='Polling interval for daemon mode (seconds)')
    parser.add_argument('--no-interactive', action='store_true',
                        help='Disable interactive intervention (no keystroke monitoring)')
    parser.add_argument('--config', help='Path to supervisor config JSON')
    parser.add_argument('--maildir', help='Override maildir path')
    parser.add_argument('--log-level', default='INFO', choices=['DEBUG', 'INFO', 'WARNING', 'ERROR'],
                        help='Logging level')

    args = parser.parse_args()

    try:
        # Create daemon
        daemon = AgentDaemon(
            role_name=args.role,
            config_path=args.config,
            maildir=args.maildir,
            log_level=args.log_level,
        )

        # Run
        if args.daemon:
            exit_code = daemon.run_daemon(
                interval=args.interval,
                interactive=not args.no_interactive
            )
        else:
            exit_code = daemon.run_once()

        return exit_code if exit_code is not None else 0

    except KeyboardInterrupt:
        print("\nInterrupted by user", file=sys.stderr)
        return 130

    except Exception as e:
        print(f"Error: {e}", file=sys.stderr)
        import traceback
        traceback.print_exc()
        return 1


if __name__ == '__main__':
    sys.exit(main())
