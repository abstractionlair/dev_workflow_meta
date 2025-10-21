#!/usr/bin/env python3
"""
Automated Test Analyzer - Detects common test smells and issues.

This script performs static analysis on test files to identify potential problems
before implementation begins.

Usage:
    python analyze_tests.py <test_file_or_directory>
    
Examples:
    python analyze_tests.py tests/test_calculator.py
    python analyze_tests.py tests/
"""

import ast
import argparse
import re
from pathlib import Path
from typing import List, Dict, Tuple
from dataclasses import dataclass

# ANSI color codes
RED = '\033[91m'
YELLOW = '\033[93m'
GREEN = '\033[92m'
BLUE = '\033[94m'
RESET = '\033[0m'
BOLD = '\033[1m'

@dataclass
class Issue:
    """Represents a test issue."""
    severity: str  # 'critical', 'warning', 'suggestion'
    category: str
    message: str
    line: int = None
    
    def __str__(self):
        color = RED if self.severity == 'critical' else YELLOW if self.severity == 'warning' else BLUE
        icon = '❌' if self.severity == 'critical' else '⚠️' if self.severity == 'warning' else '💡'
        location = f" (line {self.line})" if self.line else ""
        return f"{color}{icon} {self.category}: {self.message}{location}{RESET}"


class TestAnalyzer(ast.NodeVisitor):
    """AST visitor to analyze test files for common issues."""
    
    def __init__(self):
        self.issues: List[Issue] = []
        self.test_functions: List[Tuple[str, int]] = []
        self.has_assertions: Dict[str, bool] = {}
        self.current_function = None
        self.module_level_vars = []
        
    def visit_FunctionDef(self, node):
        """Visit function definitions to analyze test functions."""
        if node.name.startswith('test_'):
            self.test_functions.append((node.name, node.lineno))
            self.current_function = node.name
            self.has_assertions[node.name] = False
            
            # Check test name quality
            self._check_test_name(node.name, node.lineno)
            
            # Check for assertions
            for child in ast.walk(node):
                if isinstance(child, ast.Assert):
                    self.has_assertions[node.name] = True
                    break
            
            # Check for conditional logic in tests
            self._check_conditional_logic(node)
            
            # Check for sleep calls
            self._check_for_sleeps(node)
            
        self.generic_visit(node)
        self.current_function = None
    
    def visit_Assign(self, node):
        """Check for module-level assignments (shared state)."""
        # Check if this is a module-level assignment
        if self.current_function is None:
            for target in node.targets:
                if isinstance(target, ast.Name):
                    self.module_level_vars.append((target.id, node.lineno))
        self.generic_visit(node)
    
    def _check_test_name(self, name: str, line: int):
        """Check if test name is descriptive."""
        # Bad patterns
        bad_patterns = [
            (r'^test_\d+$', 'Test name is just a number'),
            (r'^test_[a-z]+$', 'Test name only contains method name, missing behavior'),
            (r'^test_(it_)?works?$', 'Test name "works" is too vague'),
            (r'^test_basic$', 'Test name "basic" is too vague'),
            (r'^test_example$', 'Test name "example" should be renamed'),
        ]
        
        for pattern, message in bad_patterns:
            if re.match(pattern, name):
                self.issues.append(Issue(
                    severity='warning',
                    category='Unclear name',
                    message=f'{name}: {message}',
                    line=line
                ))
                return
        
        # Check for very short names
        if len(name) < 10:  # "test_" is 5, so < 10 means less than 5 chars after prefix
            self.issues.append(Issue(
                severity='warning',
                category='Unclear name',
                message=f'{name}: Test name is too short, add more description',
                line=line
            ))
    
    def _check_conditional_logic(self, node):
        """Check for conditional logic in test functions."""
        has_if = False
        has_for = False
        has_while = False
        
        for child in ast.walk(node):
            if isinstance(child, ast.If):
                has_if = True
            elif isinstance(child, ast.For):
                has_for = True
            elif isinstance(child, ast.While):
                has_while = True
        
        if has_if or has_for or has_while:
            logic_types = []
            if has_if:
                logic_types.append('if statements')
            if has_for:
                logic_types.append('for loops')
            if has_while:
                logic_types.append('while loops')
            
            self.issues.append(Issue(
                severity='warning',
                category='Complex test',
                message=f'{node.name}: Contains {", ".join(logic_types)}. Consider splitting or using parametrize.',
                line=node.lineno
            ))
    
    def _check_for_sleeps(self, node):
        """Check for time.sleep() calls which make tests slow."""
        for child in ast.walk(node):
            if isinstance(child, ast.Call):
                if isinstance(child.func, ast.Attribute):
                    if (isinstance(child.func.value, ast.Name) and 
                        child.func.value.id == 'time' and 
                        child.func.attr == 'sleep'):
                        self.issues.append(Issue(
                            severity='warning',
                            category='Slow test',
                            message=f'{node.name}: Uses time.sleep() which slows down tests',
                            line=child.lineno
                        ))


def analyze_test_file(file_path: Path) -> List[Issue]:
    """Analyze a single test file."""
    try:
        with open(file_path, 'r') as f:
            tree = ast.parse(f.read(), filename=str(file_path))
    except SyntaxError as e:
        return [Issue(
            severity='critical',
            category='Syntax error',
            message=f'Cannot parse file: {e}',
            line=e.lineno
        )]
    except Exception as e:
        return [Issue(
            severity='critical',
            category='Error',
            message=f'Cannot read file: {e}'
        )]
    
    analyzer = TestAnalyzer()
    analyzer.visit(tree)
    
    # Check for tests without assertions
    for func_name, line in analyzer.test_functions:
        if not analyzer.has_assertions.get(func_name, False):
            analyzer.issues.append(Issue(
                severity='critical',
                category='No assertion',
                message=f'{func_name}: Test has no assertions',
                line=line
            ))
    
    # Check for module-level mutable variables (potential shared state)
    for var_name, line in analyzer.module_level_vars:
        # Check if it's a mutable type initialization
        if not var_name.isupper():  # Not a constant
            analyzer.issues.append(Issue(
                severity='critical',
                category='Shared state',
                message=f'Module-level variable "{var_name}" may cause test interdependence',
                line=line
            ))
    
    # Check test count
    if len(analyzer.test_functions) == 0:
        analyzer.issues.append(Issue(
            severity='warning',
            category='No tests',
            message='No test functions found in file'
        ))
    elif len(analyzer.test_functions) == 1:
        analyzer.issues.append(Issue(
            severity='suggestion',
            category='Single test',
            message='Only one test found. Consider testing edge cases and error scenarios.'
        ))
    
    return analyzer.issues


def print_summary(issues: List[Issue], file_path: Path):
    """Print analysis summary."""
    critical = [i for i in issues if i.severity == 'critical']
    warnings = [i for i in issues if i.severity == 'warning']
    suggestions = [i for i in issues if i.severity == 'suggestion']
    
    print(f"\n{BOLD}{'=' * 60}")
    print(f"Test Analysis: {file_path}")
    print(f"{'=' * 60}{RESET}\n")
    
    if not issues:
        print(f"{GREEN}✅ No issues found! Tests look good.{RESET}\n")
        return
    
    # Print summary
    print(f"{BOLD}Summary:{RESET}")
    if critical:
        print(f"  {RED}❌ {len(critical)} Critical issues{RESET}")
    if warnings:
        print(f"  {YELLOW}⚠️  {len(warnings)} Warnings{RESET}")
    if suggestions:
        print(f"  {BLUE}💡 {len(suggestions)} Suggestions{RESET}")
    
    # Print issues by severity
    if critical:
        print(f"\n{BOLD}Critical Issues (must fix):{RESET}")
        for issue in critical:
            print(f"  {issue}")
    
    if warnings:
        print(f"\n{BOLD}Warnings (should fix):{RESET}")
        for issue in warnings:
            print(f"  {issue}")
    
    if suggestions:
        print(f"\n{BOLD}Suggestions:{RESET}")
        for issue in suggestions:
            print(f"  {issue}")
    
    # Overall assessment
    print(f"\n{BOLD}Assessment:{RESET}")
    if critical:
        print(f"  {RED}❌ Tests need critical fixes before implementation{RESET}")
    elif warnings:
        print(f"  {YELLOW}⚠️  Tests have issues that should be addressed{RESET}")
    else:
        print(f"  {GREEN}✅ Tests are in reasonable shape{RESET}")
    
    print()


def analyze_directory(directory: Path) -> Dict[Path, List[Issue]]:
    """Analyze all test files in a directory."""
    test_files = []
    
    # Find Python test files
    for pattern in ['test_*.py', '*_test.py']:
        test_files.extend(directory.rglob(pattern))
    
    results = {}
    for test_file in test_files:
        issues = analyze_test_file(test_file)
        if issues:
            results[test_file] = issues
    
    return results


def main():
    parser = argparse.ArgumentParser(
        description='Automated Test Analyzer - Detect test smells',
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
Examples:
  %(prog)s tests/test_calculator.py
  %(prog)s tests/
  %(prog)s . --summary-only

What this analyzes:
  ✓ Test naming quality
  ✓ Missing assertions
  ✓ Shared state (module-level variables)
  ✓ Conditional logic in tests
  ✓ Slow tests (time.sleep)
  ✓ Test count and coverage hints
        """
    )
    parser.add_argument('path', type=Path, help='Test file or directory to analyze')
    parser.add_argument('--summary-only', action='store_true', help='Only show summary, not individual issues')
    
    args = parser.parse_args()
    
    if not args.path.exists():
        print(f"{RED}Error: Path not found: {args.path}{RESET}")
        return 1
    
    # Analyze
    if args.path.is_file():
        issues = analyze_test_file(args.path)
        print_summary(issues, args.path)
    else:
        results = analyze_directory(args.path)
        
        if not results:
            print(f"{GREEN}✅ No test files found or no issues detected{RESET}")
            return 0
        
        # Print results for each file
        total_critical = 0
        total_warnings = 0
        total_suggestions = 0
        
        for file_path, issues in results.items():
            if not args.summary_only:
                print_summary(issues, file_path)
            
            total_critical += len([i for i in issues if i.severity == 'critical'])
            total_warnings += len([i for i in issues if i.severity == 'warning'])
            total_suggestions += len([i for i in issues if i.severity == 'suggestion'])
        
        # Print overall summary
        print(f"{BOLD}{'=' * 60}")
        print(f"Overall Summary ({len(results)} files analyzed)")
        print(f"{'=' * 60}{RESET}")
        print(f"  {RED}❌ {total_critical} Critical issues{RESET}")
        print(f"  {YELLOW}⚠️  {total_warnings} Warnings{RESET}")
        print(f"  {BLUE}💡 {total_suggestions} Suggestions{RESET}\n")
        
        if total_critical > 0:
            return 1
    
    return 0


if __name__ == '__main__':
    exit(main())
