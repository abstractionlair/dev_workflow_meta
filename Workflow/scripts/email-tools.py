#!/usr/bin/env python3
"""
email-tools.py - Comprehensive email tooling for workflow roles

This tool provides reliable email operations optimized for AI model usage:
- Send emails via maildir (avoiding escape sequence issues)
- Search emails efficiently (avoiding reading entire maildir)
- Read emails with proper formatting
- Query email metadata without reading full content

Usage:
  email-tools.py send <message-file> <maildir-path>
  email-tools.py search <maildir-path> [options]
  email-tools.py read <message-file>
  email-tools.py list <maildir-path> [options]

Examples:
  # Send email from file
  email-tools.py send /tmp/message.eml ~/Maildir/workflow/

  # Search for review requests about specific artifact
  email-tools.py search ~/Maildir/workflow/ --event-type review-request --artifact "auth.md"

  # Search recent messages in last 7 days
  email-tools.py search ~/Maildir/workflow/ --since 7d

  # List messages with metadata only (no body)
  email-tools.py list ~/Maildir/workflow/ --event-type approval --limit 10

  # Read specific message
  email-tools.py read ~/Maildir/workflow/cur/1234567890.12345_1.host
"""

import argparse
import email
import email.utils
import json
import mailbox
import os
import re
import sys
import time
from datetime import datetime, timedelta
from email.message import EmailMessage
from pathlib import Path
from typing import Dict, List, Optional, Set


class EmailTools:
    """Email operations for workflow"""

    def __init__(self, maildir_path: Optional[str] = None):
        """Initialize email tools with optional maildir path"""
        self.maildir_path = Path(maildir_path) if maildir_path else None
        if self.maildir_path and not self.maildir_path.exists():
            self.maildir_path.mkdir(parents=True, exist_ok=True)

    def send(self, message_file: str, maildir_path: Optional[str] = None) -> str:
        """
        Send email by adding to maildir.

        Args:
            message_file: Path to file containing email message (RFC 5322 format)
            maildir_path: Path to maildir (overrides instance path)

        Returns:
            Message key in maildir
        """
        maildir = Path(maildir_path) if maildir_path else self.maildir_path
        if not maildir:
            raise ValueError("No maildir path specified")

        # Ensure parent directories exist
        maildir.parent.mkdir(parents=True, exist_ok=True)

        # Read message from file (avoids escape sequence issues)
        with open(message_file, 'r') as f:
            message_content = f.read()

        # Parse message
        msg = email.message_from_string(message_content)

        # Add to maildir (create=True will create the maildir structure)
        mbox = mailbox.Maildir(str(maildir), create=True)
        key = mbox.add(msg)
        mbox.close()

        return str(key)

    def search(
        self,
        event_type: Optional[str] = None,
        artifact: Optional[str] = None,
        since: Optional[str] = None,
        state: Optional[str] = None,
        from_role: Optional[str] = None,
        to_role: Optional[str] = None,
        limit: Optional[int] = None,
    ) -> List[Dict]:
        """
        Search emails efficiently without reading entire maildir.

        Args:
            event_type: Filter by X-Event-Type header
            artifact: Filter by artifact path (supports partial match)
            since: Time window (e.g., "7d", "24h", "2025-11-01")
            state: Filter by X-Workflow-State header
            from_role: Filter by From header
            to_role: Filter by To header
            limit: Maximum results to return

        Returns:
            List of matching message metadata (not full content)
        """
        if not self.maildir_path:
            raise ValueError("No maildir path specified")

        mbox = mailbox.Maildir(str(self.maildir_path), create=False)
        results = []

        # Parse since parameter
        since_timestamp = self._parse_since(since) if since else None

        for key in mbox.keys():
            try:
                msg = mbox[key]

                # Extract metadata
                metadata = self._extract_metadata(msg, key)

                # Apply filters
                if since_timestamp and metadata['timestamp'] < since_timestamp:
                    continue

                if event_type and metadata.get('event_type') != event_type:
                    continue

                if artifact and not self._artifact_matches(metadata.get('artifacts', []), artifact):
                    continue

                if state and metadata.get('workflow_state') != state:
                    continue

                if from_role and not metadata.get('from', '').startswith(from_role):
                    continue

                if to_role and not metadata.get('to', '').startswith(to_role):
                    continue

                results.append(metadata)

                if limit and len(results) >= limit:
                    break

            except Exception as e:
                print(f"Warning: Failed to process message {key}: {e}", file=sys.stderr)
                continue

        mbox.close()

        # Sort by timestamp descending (most recent first)
        results.sort(key=lambda x: x['timestamp'], reverse=True)

        return results

    def list_messages(
        self,
        event_type: Optional[str] = None,
        limit: Optional[int] = None,
    ) -> List[Dict]:
        """
        List messages with metadata only (efficient for browsing).

        Args:
            event_type: Filter by event type
            limit: Maximum results

        Returns:
            List of message metadata
        """
        return self.search(event_type=event_type, limit=limit)

    def read(self, message_path: str) -> Dict:
        """
        Read full message content.

        Args:
            message_path: Path to message file

        Returns:
            Dictionary with headers, body, and metadata
        """
        with open(message_path, 'r') as f:
            msg = email.message_from_file(f)

        # Extract all information
        result = {
            'headers': dict(msg.items()),
            'body': self._get_body(msg),
            'metadata': self._extract_metadata(msg, message_path),
        }

        return result

    def get_thread(self, message_id: str) -> List[Dict]:
        """
        Get all messages in a thread.

        Args:
            message_id: Message-ID to find thread for

        Returns:
            List of messages in thread, ordered chronologically
        """
        if not self.maildir_path:
            raise ValueError("No maildir path specified")

        mbox = mailbox.Maildir(str(self.maildir_path), create=False)
        thread_messages = []
        message_ids_in_thread = {message_id}

        # Find all messages with matching Message-ID, In-Reply-To, or References
        for key in mbox.keys():
            try:
                msg = mbox[key]
                msg_id = msg.get('Message-ID', '').strip()
                in_reply_to = msg.get('In-Reply-To', '').strip()
                references = msg.get('References', '').strip().split()

                if (msg_id in message_ids_in_thread or
                    in_reply_to in message_ids_in_thread or
                    any(ref in message_ids_in_thread for ref in references)):

                    metadata = self._extract_metadata(msg, key)
                    thread_messages.append(metadata)

                    # Add to thread IDs
                    if msg_id:
                        message_ids_in_thread.add(msg_id)
                    if in_reply_to:
                        message_ids_in_thread.add(in_reply_to)
                    message_ids_in_thread.update(references)

            except Exception as e:
                print(f"Warning: Failed to process message {key}: {e}", file=sys.stderr)
                continue

        mbox.close()

        # Sort chronologically
        thread_messages.sort(key=lambda x: x['timestamp'])

        return thread_messages

    def _extract_metadata(self, msg: email.message.Message, key: str) -> Dict:
        """Extract metadata from message without reading full body"""
        # Get timestamp
        date_tuple = email.utils.parsedate_tz(msg.get('Date', ''))
        if date_tuple:
            timestamp = email.utils.mktime_tz(date_tuple)
        else:
            timestamp = 0

        return {
            'key': str(key),
            'message_id': msg.get('Message-ID', '').strip(),
            'from': msg.get('From', '').strip(),
            'to': msg.get('To', '').strip(),
            'subject': msg.get('Subject', '').strip(),
            'date': msg.get('Date', '').strip(),
            'timestamp': timestamp,
            'event_type': msg.get('X-Event-Type', '').strip(),
            'artifacts': [a.strip() for a in msg.get('X-Artifacts', '').split(',') if a.strip()],
            'workflow_state': msg.get('X-Workflow-State', '').strip(),
            'session_id': msg.get('X-Session-Id', '').strip(),
            'in_reply_to': msg.get('In-Reply-To', '').strip(),
            'references': msg.get('References', '').strip().split(),
        }

    def _get_body(self, msg: email.message.Message) -> str:
        """Extract body from message"""
        if msg.is_multipart():
            for part in msg.walk():
                if part.get_content_type() == 'text/plain':
                    return part.get_payload(decode=True).decode('utf-8', errors='replace')
        else:
            return msg.get_payload(decode=True).decode('utf-8', errors='replace')
        return ""

    def _parse_since(self, since: str) -> float:
        """Parse since parameter to timestamp"""
        # Try relative time first (e.g., "7d", "24h")
        match = re.match(r'^(\d+)([dhm])$', since)
        if match:
            value = int(match.group(1))
            unit = match.group(2)

            if unit == 'd':
                delta = timedelta(days=value)
            elif unit == 'h':
                delta = timedelta(hours=value)
            elif unit == 'm':
                delta = timedelta(minutes=value)
            else:
                raise ValueError(f"Invalid time unit: {unit}")

            return (datetime.now() - delta).timestamp()

        # Try absolute date (ISO format)
        try:
            dt = datetime.fromisoformat(since)
            return dt.timestamp()
        except ValueError:
            raise ValueError(f"Invalid since parameter: {since}. Use format like '7d', '24h', or '2025-11-01'")

    def _artifact_matches(self, artifacts: List[str], pattern: str) -> bool:
        """Check if any artifact matches pattern (supports partial matching)"""
        for artifact in artifacts:
            if pattern in artifact or artifact in pattern:
                return True
        return False


def main():
    parser = argparse.ArgumentParser(
        description='Email tools for workflow communication',
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog=__doc__
    )

    subparsers = parser.add_subparsers(dest='command', help='Command to execute')

    # Send command
    send_parser = subparsers.add_parser('send', help='Send email to maildir')
    send_parser.add_argument('message_file', help='Path to message file')
    send_parser.add_argument('maildir_path', help='Path to maildir')

    # Search command
    search_parser = subparsers.add_parser('search', help='Search emails')
    search_parser.add_argument('maildir_path', help='Path to maildir')
    search_parser.add_argument('--event-type', help='Filter by event type')
    search_parser.add_argument('--artifact', help='Filter by artifact (partial match)')
    search_parser.add_argument('--since', help='Time window (e.g., 7d, 24h, 2025-11-01)')
    search_parser.add_argument('--state', help='Filter by workflow state')
    search_parser.add_argument('--from', dest='from_role', help='Filter by sender')
    search_parser.add_argument('--to', dest='to_role', help='Filter by recipient')
    search_parser.add_argument('--limit', type=int, help='Maximum results')
    search_parser.add_argument('--format', choices=['json', 'text'], default='text', help='Output format')

    # List command
    list_parser = subparsers.add_parser('list', help='List messages with metadata')
    list_parser.add_argument('maildir_path', help='Path to maildir')
    list_parser.add_argument('--event-type', help='Filter by event type')
    list_parser.add_argument('--limit', type=int, default=20, help='Maximum results')
    list_parser.add_argument('--format', choices=['json', 'text'], default='text', help='Output format')

    # Read command
    read_parser = subparsers.add_parser('read', help='Read full message')
    read_parser.add_argument('message_path', help='Path to message file')
    read_parser.add_argument('--format', choices=['json', 'text'], default='text', help='Output format')

    # Thread command
    thread_parser = subparsers.add_parser('thread', help='Get message thread')
    thread_parser.add_argument('maildir_path', help='Path to maildir')
    thread_parser.add_argument('message_id', help='Message-ID to find thread for')
    thread_parser.add_argument('--format', choices=['json', 'text'], default='text', help='Output format')

    args = parser.parse_args()

    if not args.command:
        parser.print_help()
        return 1

    try:
        if args.command == 'send':
            tools = EmailTools()
            key = tools.send(args.message_file, args.maildir_path)
            print(f"Message sent: {key}")
            return 0

        elif args.command == 'search':
            tools = EmailTools(args.maildir_path)
            results = tools.search(
                event_type=args.event_type,
                artifact=args.artifact,
                since=args.since,
                state=args.state,
                from_role=args.from_role,
                to_role=args.to_role,
                limit=args.limit,
            )

            if args.format == 'json':
                print(json.dumps(results, indent=2))
            else:
                print(f"Found {len(results)} message(s):\n")
                for msg in results:
                    print(f"  [{msg['event_type']}] {msg['subject']}")
                    print(f"    From: {msg['from']}")
                    print(f"    Date: {msg['date']}")
                    print(f"    Artifacts: {', '.join(msg['artifacts'])}")
                    print(f"    Key: {msg['key']}")
                    print()
            return 0

        elif args.command == 'list':
            tools = EmailTools(args.maildir_path)
            results = tools.list_messages(
                event_type=args.event_type,
                limit=args.limit,
            )

            if args.format == 'json':
                print(json.dumps(results, indent=2))
            else:
                print(f"Listing {len(results)} message(s):\n")
                for msg in results:
                    print(f"  [{msg['event_type']}] {msg['subject']}")
                    print(f"    From: {msg['from']} → To: {msg['to']}")
                    print(f"    Date: {msg['date']}")
                    print(f"    Key: {msg['key']}")
                    print()
            return 0

        elif args.command == 'read':
            tools = EmailTools()
            result = tools.read(args.message_path)

            if args.format == 'json':
                print(json.dumps(result, indent=2))
            else:
                print("Headers:")
                for key, value in result['headers'].items():
                    print(f"  {key}: {value}")
                print(f"\nBody:\n{result['body']}")
            return 0

        elif args.command == 'thread':
            tools = EmailTools(args.maildir_path)
            thread = tools.get_thread(args.message_id)

            if args.format == 'json':
                print(json.dumps(thread, indent=2))
            else:
                print(f"Thread with {len(thread)} message(s):\n")
                for i, msg in enumerate(thread, 1):
                    print(f"{i}. [{msg['event_type']}] {msg['subject']}")
                    print(f"   From: {msg['from']}")
                    print(f"   Date: {msg['date']}")
                    print(f"   Key: {msg['key']}")
                    print()
            return 0

    except Exception as e:
        print(f"Error: {e}", file=sys.stderr)
        import traceback
        traceback.print_exc()
        return 1


if __name__ == '__main__':
    sys.exit(main())
