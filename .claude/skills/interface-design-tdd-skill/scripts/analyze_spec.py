#!/usr/bin/env python3
"""
Specification Testability Analyzer

Analyzes specifications to determine if they're testable and provides feedback.

Usage:
    python analyze_spec.py <spec_file>
    
Example:
    python analyze_spec.py specs/user_registration.md
"""

import argparse
import re
from pathlib import Path
from typing import List, Tuple

# ANSI colors
RED = '\033[91m'
YELLOW = '\033[93m'
GREEN = '\033[92m'
BLUE = '\033[94m'
RESET = '\033[0m'
BOLD = '\033[1m'

class SpecAnalyzer:
    def __init__(self, content: str):
        self.content = content.lower()
        self.issues = []
        self.warnings = []
        self.good_points = []
        
    def analyze(self):
        """Run all analysis checks."""
        self._check_vague_terms()
        self._check_implementation_details()
        self._check_acceptance_criteria()
        self._check_error_conditions()
        self._check_examples()
        self._check_boundaries()
        self._check_performance_metrics()
        
    def _check_vague_terms(self):
        """Check for vague, unmeasurable terms."""
        vague_terms = [
            ('user-friendly', 'Specify concrete usability criteria'),
            ('fast', 'Specify response time (e.g., < 500ms)'),
            ('efficient', 'Specify performance metrics'),
            ('scalable', 'Specify capacity (e.g., 10,000 concurrent users)'),
            ('robust', 'Specify error handling and recovery'),
            ('intuitive', 'Specify user interface requirements'),
            ('reliable', 'Specify uptime requirements (e.g., 99.9%)'),
            ('performant', 'Specify performance benchmarks'),
        ]
        
        for term, suggestion in vague_terms:
            if term in self.content:
                self.issues.append(
                    f"Vague term '{term}' found. {suggestion}"
                )
    
    def _check_implementation_details(self):
        """Check if spec prescribes implementation."""
        implementation_terms = [
            ('use hashmap', 'Specify behavior, not data structure'),
            ('use post method', 'Specify API behavior, not HTTP method'),
            ('use sql', 'Specify data requirements, not technology'),
            ('use redis', 'Specify caching behavior, not technology'),
            ('use bcrypt', 'Specify security requirements, not algorithm'),
            ('insert into', 'Avoid SQL in specs'),
            ('select from', 'Avoid SQL in specs'),
        ]
        
        for term, suggestion in implementation_terms:
            if term in self.content:
                self.warnings.append(
                    f"Implementation detail '{term}' found. {suggestion}"
                )
    
    def _check_acceptance_criteria(self):
        """Check for acceptance criteria."""
        criteria_keywords = ['acceptance criteria', 'acceptance criterion', 
                           'success criteria', 'requirements']
        
        if any(keyword in self.content for keyword in criteria_keywords):
            self.good_points.append("Contains acceptance criteria section")
        else:
            self.issues.append(
                "No acceptance criteria found. Add numbered, testable criteria."
            )
    
    def _check_error_conditions(self):
        """Check for error condition specifications."""
        error_keywords = ['error', 'exception', 'failure', 'invalid', 
                         'raises', 'throw']
        
        error_count = sum(self.content.count(keyword) for keyword in error_keywords)
        
        if error_count >= 3:
            self.good_points.append(
                f"Specifies error conditions ({error_count} mentions)"
            )
        elif error_count > 0:
            self.warnings.append(
                "Some error conditions mentioned, but may not be comprehensive"
            )
        else:
            self.issues.append(
                "No error conditions specified. Add error cases for negative scenarios."
            )
    
    def _check_examples(self):
        """Check for concrete examples."""
        example_keywords = ['example', 'e.g.', 'for instance', 'such as',
                          'input:', 'output:', '→', '->']
        
        if any(keyword in self.content for keyword in example_keywords):
            self.good_points.append("Contains concrete examples")
        else:
            self.warnings.append(
                "No examples found. Add concrete input/output examples."
            )
    
    def _check_boundaries(self):
        """Check for boundary specifications."""
        boundary_keywords = ['minimum', 'maximum', 'range', 'limit', 
                           'boundary', 'at least', 'at most', 'between']
        
        if any(keyword in self.content for keyword in boundary_keywords):
            self.good_points.append("Specifies boundaries or limits")
        else:
            self.warnings.append(
                "No boundaries specified. Define valid input ranges."
            )
    
    def _check_performance_metrics(self):
        """Check for quantifiable performance metrics."""
        # Look for numbers with time/quantity units
        has_metrics = bool(re.search(r'\d+\s*(ms|seconds?|minute|users?|requests?|%)', 
                                    self.content))
        
        if has_metrics:
            self.good_points.append("Contains quantifiable metrics")
        else:
            self.warnings.append(
                "No quantifiable metrics found. Add measurable performance criteria."
            )
    
    def get_score(self) -> Tuple[int, str]:
        """Calculate testability score and assessment."""
        # Scoring: -5 per issue, -2 per warning, +3 per good point
        score = (len(self.good_points) * 3) - (len(self.issues) * 5) - (len(self.warnings) * 2)
        max_score = 7 * 3  # 7 possible good points
        
        # Normalize to 0-100
        normalized = max(0, min(100, ((score + 35) / (max_score + 35)) * 100))
        
        if normalized >= 80:
            assessment = f"{GREEN}Excellent{RESET}"
        elif normalized >= 60:
            assessment = f"{GREEN}Good{RESET}"
        elif normalized >= 40:
            assessment = f"{YELLOW}Fair{RESET}"
        else:
            assessment = f"{RED}Poor{RESET}"
        
        return int(normalized), assessment


def print_analysis(analyzer: SpecAnalyzer, file_path: Path):
    """Print analysis results."""
    print(f"\n{BOLD}{'=' * 60}")
    print(f"Specification Testability Analysis: {file_path.name}")
    print(f"{'=' * 60}{RESET}\n")
    
    # Score
    score, assessment = analyzer.get_score()
    print(f"{BOLD}Testability Score: {score}/100 - {assessment}{RESET}\n")
    
    # Critical issues
    if analyzer.issues:
        print(f"{BOLD}{RED}Critical Issues ({len(analyzer.issues)}):{RESET}")
        for issue in analyzer.issues:
            print(f"  ❌ {issue}")
        print()
    
    # Warnings
    if analyzer.warnings:
        print(f"{BOLD}{YELLOW}Warnings ({len(analyzer.warnings)}):{RESET}")
        for warning in analyzer.warnings:
            print(f"  ⚠️  {warning}")
        print()
    
    # Good points
    if analyzer.good_points:
        print(f"{BOLD}{GREEN}Strengths ({len(analyzer.good_points)}):{RESET}")
        for point in analyzer.good_points:
            print(f"  ✅ {point}")
        print()
    
    # Recommendations
    print(f"{BOLD}Recommendations:{RESET}")
    if score >= 80:
        print(f"  {GREEN}✓ Specification is testable and ready for implementation{RESET}")
    elif score >= 60:
        print(f"  {YELLOW}→ Address warnings to improve clarity{RESET}")
    elif score >= 40:
        print(f"  {YELLOW}→ Fix critical issues before creating interface skeletons{RESET}")
    else:
        print(f"  {RED}→ Specification needs significant revision{RESET}")
        print(f"  {RED}→ Cannot proceed to implementation with current spec{RESET}")
    
    print(f"\n{BOLD}Next Steps:{RESET}")
    if analyzer.issues:
        print(f"  1. Fix all critical issues")
        print(f"  2. Address warnings")
        print(f"  3. Add concrete examples")
        print(f"  4. Re-run analysis")
    else:
        print(f"  1. Create interface skeletons from specification")
        print(f"  2. Write tests based on acceptance criteria")
        print(f"  3. Review tests before implementation")
    
    print()


def main():
    parser = argparse.ArgumentParser(
        description='Analyze specification testability',
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
Examples:
  %(prog)s specs/user_registration.md
  %(prog)s requirements.txt
  
Checks for:
  ✓ Vague terms (fast, user-friendly, etc.)
  ✓ Implementation details vs behavior
  ✓ Acceptance criteria presence
  ✓ Error condition specifications
  ✓ Concrete examples
  ✓ Boundary specifications
  ✓ Quantifiable metrics
        """
    )
    parser.add_argument('spec_file', type=Path, help='Specification file to analyze')
    
    args = parser.parse_args()
    
    if not args.spec_file.exists():
        print(f"{RED}Error: File not found: {args.spec_file}{RESET}")
        return 1
    
    try:
        content = args.spec_file.read_text()
    except Exception as e:
        print(f"{RED}Error reading file: {e}{RESET}")
        return 1
    
    if len(content.strip()) < 100:
        print(f"{YELLOW}Warning: Specification seems very short ({len(content)} chars){RESET}")
        print(f"{YELLOW}Consider adding more detail for better analysis{RESET}\n")
    
    analyzer = SpecAnalyzer(content)
    analyzer.analyze()
    print_analysis(analyzer, args.spec_file)
    
    # Return exit code based on score
    score, _ = analyzer.get_score()
    return 0 if score >= 60 else 1


if __name__ == '__main__':
    exit(main())
