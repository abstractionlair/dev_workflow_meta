#!/usr/bin/env python3
"""
panel-coordinator.py - Multi-model panel coordination

Coordinates panels of AI models for collaborative review or writing.
Implements email visibility boundaries, independence enforcement,
and consensus mechanisms.

Key concepts:
- Panel-internal email: Only visible to panel members
- Cross-panel email: Visible to multiple panels or roles
- Independence: Fresh context + different prompts + email isolation
- Consensus models: All agree, majority, or primary decides

Usage:
  panel-coordinator.py review <panel-name> <artifact-path>
  panel-coordinator.py write <panel-name> <artifact-type>
  panel-coordinator.py check-consensus <panel-name>

Examples:
  # Coordinate review panel
  panel-coordinator.py review spec-reviewer-panel project-meta/specs/proposed/auth.md

  # Coordinate writing panel
  panel-coordinator.py write vision-writer-panel vision

  # Check if panel reached consensus
  panel-coordinator.py check-consensus spec-reviewer-panel
"""

import argparse
import json
import logging
import os
import subprocess
import sys
import tempfile
from pathlib import Path
from typing import Dict, List, Optional


class PanelCoordinator:
    """Coordinates multi-model panels for review or writing"""

    def __init__(self, config_path: Optional[str] = None, log_level: str = 'INFO'):
        """
        Initialize panel coordinator

        Args:
            config_path: Path to supervisor config JSON
            log_level: Logging level
        """
        # Setup logging
        logging.basicConfig(
            level=getattr(logging, log_level.upper()),
            format='%(asctime)s [%(levelname)s] %(name)s: %(message)s',
        )
        self.logger = logging.getLogger('panel-coordinator')

        # Load configuration
        self.config = self.load_config(config_path)

    def load_config(self, config_path: Optional[str]) -> Dict:
        """Load supervisor configuration"""
        if config_path:
            path = Path(config_path)
        else:
            # Try default location
            script_dir = Path(__file__).parent
            workflow_dir = script_dir.parent
            path = workflow_dir / 'config' / 'supervisor-config.json'

        if not path.exists():
            raise FileNotFoundError(f"Config not found: {path}")

        with open(path) as f:
            return json.load(f)

    def get_panel_config(self, panel_name: str) -> Dict:
        """Get configuration for specific panel"""
        panels = self.config.get('panels', {})
        if panel_name not in panels:
            raise ValueError(f"Panel '{panel_name}' not found in configuration")
        return panels[panel_name]

    def _get_member_cli_command(self, member_name: str, role_type: str, role_config: Optional[Dict] = None) -> str:
        """
        Get CLI command for specific panel member

        Priority order:
        1. Member-specific override in config (member_cli)
        2. Role-specific CLI command (roles[role].cli) if it matches the member
        3. Default member CLI mapping
        4. Fallback generic command

        Args:
            member_name: Model name (claude, gpt-5, gemini, etc.)
            role_type: Role to execute
            role_config: Role configuration dict (optional)

        Returns:
            CLI command string
        """
        # 1. Check if member has custom CLI in config (highest priority)
        # This allows per-project customization
        member_cli_config = self.config.get('member_cli', {})
        if member_name in member_cli_config:
            return member_cli_config[member_name].replace('{role}', role_type)

        # 2. Check if role has a custom CLI command
        # If it matches the current member, use it
        if role_config and 'cli' in role_config:
            role_cli = role_config['cli']
            # Check if this CLI is for the current member
            # E.g., "claude --role vision-reviewer" is for claude member
            if role_cli.startswith(f'{member_name} '):
                return role_cli

        # 3. Use default mapping
        cli_mapping = {
            'claude': f'claude --role {role_type}',
            'gpt-5': f'gpt --model gpt-5 --role {role_type}',
            'gemini': f'gemini --role {role_type}',
            'codex': f'codex --role {role_type}',
            'opencode': f'opencode --role {role_type}',
        }

        if member_name in cli_mapping:
            return cli_mapping[member_name]

        # 4. Fallback: assume it's a CLI command name
        self.logger.warning(f"Unknown member '{member_name}', using default CLI")
        return f'{member_name} --role {role_type}'

    def spawn_panel_member(
        self,
        member_name: str,
        role_type: str,
        artifact_path: str,
        panel_internal_maildir: str,
    ) -> int:
        """
        Spawn a single panel member to process task

        Args:
            member_name: Model name (claude, gpt-5, gemini, etc.)
            role_type: Role to execute (e.g., spec-reviewer)
            artifact_path: Path to artifact to review/write
            panel_internal_maildir: Maildir for panel-internal communication

        Returns:
            Exit code from member session
        """
        self.logger.info(f"Spawning panel member: {member_name} as {role_type}")

        # Get role config
        roles = self.config.get('roles', {})
        if role_type not in roles:
            raise ValueError(f"Role '{role_type}' not found in configuration")

        role_config = roles[role_type]

        # Build CLI command for this member
        # Customize based on member_name (claude, gpt-5, gemini, etc.)
        cli_command = self._get_member_cli_command(member_name, role_type, role_config)

        # Create context prompt
        prompt = self.create_member_prompt(
            member_name=member_name,
            role_type=role_type,
            artifact_path=artifact_path,
            panel_internal_maildir=panel_internal_maildir,
        )

        # Write prompt to temp file
        with tempfile.NamedTemporaryFile(mode='w', suffix='.md', delete=False) as f:
            prompt_file = f.name
            f.write(prompt)

        try:
            # Run CLI
            full_command = f"{cli_command} < {prompt_file}"

            result = subprocess.run(
                full_command,
                shell=True,
                timeout=600,  # 10 minutes
                cwd=Path.cwd(),
            )

            self.logger.info(f"Member {member_name} completed with exit code {result.returncode}")

            return result.returncode

        finally:
            try:
                os.unlink(prompt_file)
            except:
                pass

    def create_member_prompt(
        self,
        member_name: str,
        role_type: str,
        artifact_path: str,
        panel_internal_maildir: str,
    ) -> str:
        """
        Create context prompt for panel member

        Args:
            member_name: Model name
            role_type: Role type
            artifact_path: Artifact to review/write
            panel_internal_maildir: Panel-internal maildir

        Returns:
            Prompt text
        """
        prompt = f"""# Panel Member Session - {member_name}

You are participating as a member of a multi-model panel.

**Your role**: {role_type}
**Panel member ID**: {member_name}
**Artifact**: {artifact_path}

## Panel Operation Principles

1. **Independence**: You have fresh context. You do not remember any prior sessions or discussions.

2. **Email Visibility**:
   - Panel-internal email: {panel_internal_maildir}
     - Use this for discussions with other panel members
     - Other panels and roles CANNOT see these messages
   - Cross-panel email: ~/Maildir/workflow
     - Use this for communication with other roles (writer, coordinator, etc.)

3. **Your Task**:
   - Read the artifact: {artifact_path}
   - Perform your role's function (review, contribute ideas, etc.)
   - Discuss with panel members via panel-internal email if needed
   - Submit your individual assessment/contribution

4. **Fresh Context**:
   - You don't have memory of being on this panel before
   - Get context from: artifact + recent panel-internal emails
   - Each spawn is independent

## Next Steps

1. Read the artifact
2. Check panel-internal email for any discussion
3. Perform your role's work
4. Send your assessment via panel-internal email
5. Participate in consensus building if needed

Begin by reading: {artifact_path}
"""
        return prompt

    def coordinate_review_panel(self, panel_name: str, artifact_path: str) -> int:
        """
        Coordinate review panel to review artifact

        Args:
            panel_name: Name of panel (e.g., spec-reviewer-panel)
            artifact_path: Path to artifact to review

        Returns:
            Exit code (0 if consensus reached)
        """
        self.logger.info(f"Coordinating review panel: {panel_name}")
        self.logger.info(f"Artifact: {artifact_path}")

        panel_config = self.get_panel_config(panel_name)
        members = panel_config.get('members', [])
        role_type = panel_config.get('role_type')
        decision_model = panel_config.get('decision_model', 'consensus')

        self.logger.info(f"Panel members: {', '.join(members)}")
        self.logger.info(f"Decision model: {decision_model}")

        # Create panel-internal maildir
        panel_internal_maildir = f"~/Maildir/panels/{panel_name}"

        # Phase 1: Individual reviews
        self.logger.info("Phase 1: Individual reviews")
        for member in members:
            self.logger.info(f"Spawning {member} for independent review...")
            self.spawn_panel_member(
                member_name=member,
                role_type=role_type,
                artifact_path=artifact_path,
                panel_internal_maildir=panel_internal_maildir,
            )

        # Phase 2: Discussion (via panel-internal email)
        self.logger.info("Phase 2: Panel discussion")
        # Members communicate via panel-internal email
        # This would involve additional spawns to process discussion

        # Phase 3: Consensus
        self.logger.info("Phase 3: Reaching consensus")
        decision = self.check_consensus(panel_name, decision_model)

        if decision:
            self.logger.info(f"Consensus reached: {decision}")
            # Return 0 for approve, 1 for reject/request-revision
            return 0 if decision == 'approve' else 1
        else:
            self.logger.warning("Consensus not reached")
            return 1

    def coordinate_write_panel(self, panel_name: str, artifact_type: str, artifact_path: Optional[str] = None) -> int:
        """
        Coordinate writing panel to collaboratively create artifact

        This implements the Primary + Helpers pattern:
        1. Primary announces section
        2. All members contribute ideas (collaborative exploration)
        3. Panel discusses tradeoffs and challenges assumptions
        4. Primary makes decision and integrates discussion
        5. Repeat for each section
        6. Primary sends completed artifact for review

        Args:
            panel_name: Name of panel (e.g., vision-writer-panel)
            artifact_type: Type of artifact (vision, scope, roadmap, spec)
            artifact_path: Explicit path to artifact (optional, overrides type-based lookup)

        Returns:
            Exit code (0 if artifact completed)
        """
        self.logger.info(f"Coordinating writing panel: {panel_name}")
        self.logger.info(f"Artifact type: {artifact_type}")

        panel_config = self.get_panel_config(panel_name)
        members = panel_config.get('members', [])
        role_type = panel_config.get('role_type')

        if not members:
            self.logger.error("Panel has no members")
            return 1

        # Primary is the first member
        primary = members[0]
        helpers = members[1:]

        self.logger.info(f"Primary: {primary}")
        self.logger.info(f"Helpers: {', '.join(helpers)}")

        # Create panel-internal maildir
        panel_internal_maildir = f"~/Maildir/panels/{panel_name}"

        # Determine artifact path
        if artifact_path:
            # Use explicitly provided path
            self.logger.info(f"Using explicit artifact path: {artifact_path}")
        else:
            # Determine path based on type
            artifact_paths = {
                'vision': 'project-meta/planning/VISION.md',
                'scope': 'project-meta/planning/SCOPE.md',
                'roadmap': 'project-meta/planning/ROADMAP.md',
                'spec': 'project-meta/specs/proposed/SPEC.md',  # Default, should use explicit path
            }
            artifact_path = artifact_paths.get(artifact_type, f'project-meta/{artifact_type}.md')
            self.logger.info(f"Determined artifact path from type: {artifact_path}")

        # Phase 1: Initial exploration
        # All members (primary + helpers) review requirements and discuss approach
        self.logger.info("Phase 1: Initial exploration")
        for member in members:
            self.logger.info(f"Spawning {member} for initial exploration...")
            self.spawn_panel_member(
                member_name=member,
                role_type=role_type,
                artifact_path=artifact_path,
                panel_internal_maildir=panel_internal_maildir,
            )

        # Phase 2: Collaborative writing
        # This would involve multiple rounds of:
        # - Primary announces section
        # - Helpers contribute ideas
        # - Discussion via panel-internal email
        # - Primary decides and writes
        #
        # For now, we implement a simplified version where primary
        # coordinates the process and helpers provide input

        self.logger.info("Phase 2: Collaborative writing")
        self.logger.info(f"Primary {primary} coordinating writing process...")

        # Spawn primary for writing coordination
        # Primary will check panel-internal email for helper contributions
        self.spawn_panel_member(
            member_name=primary,
            role_type=role_type,
            artifact_path=artifact_path,
            panel_internal_maildir=panel_internal_maildir,
        )

        # Phase 3: Final review and completion
        self.logger.info("Phase 3: Final artifact completion")

        # Check if artifact was created
        if Path(artifact_path).exists():
            self.logger.info(f"Artifact created: {artifact_path}")
            return 0
        else:
            self.logger.warning(f"Artifact not found: {artifact_path}")
            return 1

    def check_consensus(self, panel_name: str, decision_model: str) -> Optional[str]:
        """
        Check if panel has reached consensus

        Args:
            panel_name: Panel name
            decision_model: Decision model (consensus, majority, primary-decides)

        Returns:
            Decision string ('approve', 'reject', 'request-revision') if consensus reached,
            None if no consensus
        """
        self.logger.info(f"Checking consensus for {panel_name} using {decision_model} model")

        # Import email tools
        script_dir = Path(__file__).parent
        sys.path.insert(0, str(script_dir))
        from email_tools import EmailTools

        # Get panel-internal maildir
        panel_internal_maildir = os.path.expanduser(f"~/Maildir/panels/{panel_name}")

        # Read panel-internal emails
        tools = EmailTools(panel_internal_maildir)

        # Get recent decision messages from panel members
        # Look for messages with X-Event-Type: panel-decision
        decisions = tools.search(
            event_type='panel-decision',
            since='7d',
        )

        if not decisions:
            self.logger.warning("No panel decisions found")
            return None

        # Extract decision from each message (approve/reject/request-revision)
        member_decisions = {}
        for decision in decisions:
            from_role = decision.get('from', '')
            # Extract member name from email address (e.g., "claude@panel.local" -> "claude")
            member_name = from_role.split('@')[0] if '@' in from_role else from_role

            # Extract decision from subject or would need to read body
            # For now, we'll look for keywords in subject
            subject = decision.get('subject', '').lower()
            if 'approve' in subject:
                member_decisions[member_name] = 'approve'
            elif 'reject' in subject:
                member_decisions[member_name] = 'reject'
            elif 'revision' in subject or 'clarification' in subject:
                member_decisions[member_name] = 'request-revision'

        if not member_decisions:
            self.logger.warning("Could not extract decisions from panel emails")
            return None

        self.logger.info(f"Panel decisions: {member_decisions}")

        # Apply decision model
        if decision_model == 'consensus':
            # All members must agree
            unique_decisions = set(member_decisions.values())
            if len(unique_decisions) == 1:
                decision = list(unique_decisions)[0]
                self.logger.info(f"Consensus reached: {decision}")
                return decision
            else:
                self.logger.info(f"No consensus: {unique_decisions}")
                return None

        elif decision_model == 'majority':
            # More than 50% must agree
            from collections import Counter
            decision_counts = Counter(member_decisions.values())
            total = len(member_decisions)
            most_common = decision_counts.most_common(1)[0]

            if most_common[1] > total / 2:
                decision = most_common[0]
                self.logger.info(f"Majority consensus: {decision} ({most_common[1]}/{total})")
                return decision
            else:
                self.logger.info(f"No majority: {decision_counts}")
                return None

        elif decision_model == 'primary-decides':
            # Primary member's decision is authoritative
            # Primary is typically the first member
            panel_config = self.get_panel_config(panel_name)
            members = panel_config.get('members', [])
            if members and members[0] in member_decisions:
                decision = member_decisions[members[0]]
                self.logger.info(f"Primary decision: {decision}")
                return decision
            else:
                self.logger.warning("Primary member decision not found")
                return None

        else:
            raise ValueError(f"Unknown decision model: {decision_model}")


def main():
    parser = argparse.ArgumentParser(
        description='Multi-model panel coordinator',
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog=__doc__
    )

    subparsers = parser.add_subparsers(dest='command', help='Command to execute')

    # Review command
    review_parser = subparsers.add_parser('review', help='Coordinate review panel')
    review_parser.add_argument('panel_name', help='Panel name (e.g., spec-reviewer-panel)')
    review_parser.add_argument('artifact_path', help='Path to artifact to review')

    # Write command
    write_parser = subparsers.add_parser('write', help='Coordinate writing panel')
    write_parser.add_argument('panel_name', help='Panel name (e.g., vision-writer-panel)')
    write_parser.add_argument('artifact_type', help='Type of artifact (vision, scope, roadmap, spec)')
    write_parser.add_argument('--artifact-path', help='Explicit path to artifact (optional, overrides type-based lookup)')

    # Consensus command
    consensus_parser = subparsers.add_parser('check-consensus', help='Check panel consensus')
    consensus_parser.add_argument('panel_name', help='Panel name')

    # Common arguments
    parser.add_argument('--config', help='Path to supervisor config JSON')
    parser.add_argument('--log-level', default='INFO',
                        choices=['DEBUG', 'INFO', 'WARNING', 'ERROR'],
                        help='Logging level')

    args = parser.parse_args()

    if not args.command:
        parser.print_help()
        return 1

    try:
        coordinator = PanelCoordinator(
            config_path=args.config,
            log_level=args.log_level,
        )

        if args.command == 'review':
            exit_code = coordinator.coordinate_review_panel(
                panel_name=args.panel_name,
                artifact_path=args.artifact_path,
            )
            return exit_code

        elif args.command == 'write':
            exit_code = coordinator.coordinate_write_panel(
                panel_name=args.panel_name,
                artifact_type=args.artifact_type,
                artifact_path=getattr(args, 'artifact_path', None),
            )
            return exit_code

        elif args.command == 'check-consensus':
            panel_config = coordinator.get_panel_config(args.panel_name)
            decision_model = panel_config.get('decision_model', 'consensus')
            decision = coordinator.check_consensus(args.panel_name, decision_model)
            if decision:
                print(f"Consensus: REACHED - {decision}")
                # Exit 0 for approve, 1 for reject/request-revision
                return 0 if decision == 'approve' else 1
            else:
                print("Consensus: NOT REACHED")
                return 1

    except Exception as e:
        print(f"Error: {e}", file=sys.stderr)
        import traceback
        traceback.print_exc()
        return 1


if __name__ == '__main__':
    sys.exit(main())
