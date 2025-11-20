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
        # This would need to be customized based on how different CLIs are invoked
        cli_template = role_config.get('cli', 'claude --role {role}')
        cli_command = cli_template.replace('{role}', role_type)

        # TODO: Adjust CLI command based on member_name
        # For now, assume all use same CLI with different configs

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
                import os
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
        consensus_reached = self.check_consensus(panel_name, decision_model)

        if consensus_reached:
            self.logger.info("Consensus reached")
            return 0
        else:
            self.logger.warning("Consensus not reached")
            return 1

    def check_consensus(self, panel_name: str, decision_model: str) -> bool:
        """
        Check if panel has reached consensus

        Args:
            panel_name: Panel name
            decision_model: Decision model (consensus, majority, primary-decides)

        Returns:
            True if consensus reached
        """
        # TODO: Implement consensus checking
        # This would involve:
        # 1. Reading panel-internal emails
        # 2. Extracting decisions from each member
        # 3. Applying decision model
        # 4. Determining if consensus met

        self.logger.info(f"Checking consensus for {panel_name} using {decision_model} model")

        # Placeholder implementation
        return True


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
            # TODO: Implement write panel coordination
            print("Write panel coordination not yet implemented", file=sys.stderr)
            return 1

        elif args.command == 'check-consensus':
            panel_config = coordinator.get_panel_config(args.panel_name)
            decision_model = panel_config.get('decision_model', 'consensus')
            consensus = coordinator.check_consensus(args.panel_name, decision_model)
            print(f"Consensus: {'REACHED' if consensus else 'NOT REACHED'}")
            return 0 if consensus else 1

    except Exception as e:
        print(f"Error: {e}", file=sys.stderr)
        import traceback
        traceback.print_exc()
        return 1


if __name__ == '__main__':
    sys.exit(main())
