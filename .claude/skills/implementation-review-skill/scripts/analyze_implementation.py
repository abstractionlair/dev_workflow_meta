#!/usr/bin/env python3
"""
Implementation Analyzer - Automated code quality and security checks.

Performs static analysis to detect common issues before detailed manual review.

Usage:
    python analyze_implementation.py <file_or_directory>
    
Examples:
    python analyze_implementation.py src/user_service.py
    python analyze_implementation.py src/
"""

import ast
import argparse
import re
from pathlib import Path
from typing import List, Dict
from dataclasses import dataclass

# ANSI colors
RED = '\033[91m'
YELLOW = '\033[93m'
GREEN = '\033[92m'
BLUE = '\033[94m'
RESET = '\033[0m'
BOLD = '\033[1m'

@dataclass
class Issue:
    severity: str  # 'critical', 'warning', 'info'
    category: str
    message: str
    line: int = None
    
    def __str__(self):
        color = RED if self.severity == 'critical' else YELLOW if self.severity == 'warning' else BLUE
        icon = '❌' if self.severity == 'critical' else '⚠️' if self.severity == 'warning' else 'ℹ️'
        location = f" (line {self.line})" if self.line else ""
        return f"{color}{icon} {self.category}: {self.message}{location}{RESET}"


class ImplementationAnalyzer(ast.NodeVisitor):
    """AST visitor for implementation analysis."""
    
    def __init__(self, source_code: str):
        self.issues: List[Issue] = []
        self.source_lines = source_code.split('\n')
        self.current_class = None
        self.current_function = None
        self.function_lengths: Dict[str, int] = {}
        
    def visit_ClassDef(self, node):
        prev_class = self.current_class
        self.current_class = node.name
        
        # Check class size
        class_lines = node.end_lineno - node.lineno if hasattr(node, 'end_lineno') else 0
        if class_lines > 500:
            self.issues.append(Issue(
                severity='warning',
                category='Large Class',
                message=f'Class {node.name} is {class_lines} lines long (>500 suggests God Class)',
                line=node.lineno
            ))
        
        # Count public methods
        public_methods = [n for n in node.body if isinstance(n, ast.FunctionDef) and not n.name.startswith('_')]
        if len(public_methods) > 10:
            self.issues.append(Issue(
                severity='warning',
                category='Large Class',
                message=f'Class {node.name} has {len(public_methods)} public methods (>10 suggests too many responsibilities)',
                line=node.lineno
            ))
        
        self.generic_visit(node)
        self.current_class = prev_class
    
    def visit_FunctionDef(self, node):
        prev_function = self.current_function
        self.current_function = node.name
        
        # Check function length
        func_lines = node.end_lineno - node.lineno if hasattr(node, 'end_lineno') else 0
        self.function_lengths[node.name] = func_lines
        
        if func_lines > 50:
            self.issues.append(Issue(
                severity='warning',
                category='Long Method',
                message=f'Function {node.name} is {func_lines} lines long (>50 suggests extraction needed)',
                line=node.lineno
            ))
        
        # Check parameter count
        args = node.args
        param_count = len(args.args) + len(args.posonlyargs) + len(args.kwonlyargs)
        if param_count > 4:
            self.issues.append(Issue(
                severity='warning',
                category='Long Parameter List',
                message=f'Function {node.name} has {param_count} parameters (>4 suggests parameter object)',
                line=node.lineno
            ))
        
        # Check for missing type hints (Python 3.5+)
        if not node.returns and node.name != '__init__':
            self.issues.append(Issue(
                severity='info',
                category='Missing Type Hint',
                message=f'Function {node.name} missing return type hint',
                line=node.lineno
            ))
        
        # Check for missing docstring
        if not ast.get_docstring(node) and not node.name.startswith('_'):
            if self.current_class is None or not node.name.startswith('_'):
                self.issues.append(Issue(
                    severity='info',
                    category='Missing Docstring',
                    message=f'Public function {node.name} missing docstring',
                    line=node.lineno
                ))
        
        self.generic_visit(node)
        self.current_function = prev_function
    
    def visit_Call(self, node):
        # Check for SQL string formatting (potential injection)
        if isinstance(node.func, ast.Attribute):
            if node.func.attr in ['execute', 'query', 'raw']:
                # Check if first argument uses f-string or % formatting
                if node.args:
                    first_arg = node.args[0]
                    if isinstance(first_arg, ast.JoinedStr):  # f-string
                        self.issues.append(Issue(
                            severity='critical',
                            category='SQL Injection Risk',
                            message='Using f-string in SQL query - use parameterized queries',
                            line=node.lineno
                        ))
                    elif isinstance(first_arg, ast.BinOp) and isinstance(first_arg.op, ast.Mod):  # % formatting
                        self.issues.append(Issue(
                            severity='critical',
                            category='SQL Injection Risk',
                            message='Using % formatting in SQL query - use parameterized queries',
                            line=node.lineno
                        ))
        
        # Check for eval/exec
        if isinstance(node.func, ast.Name):
            if node.func.id in ['eval', 'exec']:
                self.issues.append(Issue(
                    severity='critical',
                    category='Dangerous Function',
                    message=f'Use of {node.func.id}() is dangerous - avoid if possible',
                    line=node.lineno
                ))
            
            # Check for pickle.loads on untrusted data
            if node.func.id == 'loads':
                self.issues.append(Issue(
                    severity='warning',
                    category='Insecure Deserialization',
                    message='pickle.loads() on untrusted data can execute arbitrary code',
                    line=node.lineno
                ))
        
        # Check for time.sleep in what might be production code
        if isinstance(node.func, ast.Attribute):
            if (isinstance(node.func.value, ast.Name) and 
                node.func.value.id == 'time' and 
                node.func.attr == 'sleep'):
                self.issues.append(Issue(
                    severity='warning',
                    category='Performance',
                    message='time.sleep() found - may slow down application',
                    line=node.lineno
                ))
        
        self.generic_visit(node)
    
    def visit_Try(self, node):
        # Check for bare except
        for handler in node.handlers:
            if handler.type is None:
                self.issues.append(Issue(
                    severity='warning',
                    category='Bare Except',
                    message='Bare except: clause catches all exceptions - be specific',
                    line=handler.lineno
                ))
        
        self.generic_visit(node)
    
    def visit_For(self, node):
        # Check for nested database queries (N+1 pattern)
        # Look for database calls inside the loop
        for child in ast.walk(node):
            if isinstance(child, ast.Call):
                if isinstance(child.func, ast.Attribute):
                    if child.func.attr in ['query', 'execute', 'get', 'find', 'find_one']:
                        self.issues.append(Issue(
                            severity='warning',
                            category='N+1 Query',
                            message='Database query inside loop - possible N+1 problem',
                            line=node.lineno
                        ))
                        break
        
        self.generic_visit(node)


def check_security_patterns(source_code: str) -> List[Issue]:
    """Check for security anti-patterns using regex."""
    issues = []
    
    patterns = [
        (r'password\s*=\s*["\'][^"\']+["\']', 'Hardcoded Password', 
         'Hardcoded password detected - use environment variables'),
        (r'api[_-]?key\s*=\s*["\'][^"\']+["\']', 'Hardcoded Secret',
         'Hardcoded API key - use environment variables'),
        (r'secret[_-]?key\s*=\s*["\'][^"\']+["\']', 'Hardcoded Secret',
         'Hardcoded secret key - use environment variables'),
        (r'random\.choice|random\.randint', 'Weak Random',
         'Using random module for security - use secrets module instead'),
        (r'\.execute\([\'"].*%s.*[\'"]\)', 'SQL Injection',
         'String formatting in SQL query - use parameterized queries'),
        (r'os\.system\(', 'Command Injection',
         'os.system() with user input is dangerous - use subprocess with list'),
    ]
    
    lines = source_code.split('\n')
    for i, line in enumerate(lines, 1):
        for pattern, category, message in patterns:
            if re.search(pattern, line, re.IGNORECASE):
                issues.append(Issue(
                    severity='critical',
                    category=category,
                    message=message,
                    line=i
                ))
    
    return issues


def analyze_file(file_path: Path) -> List[Issue]:
    """Analyze a single Python file."""
    try:
        source_code = file_path.read_text()
    except Exception as e:
        return [Issue(
            severity='critical',
            category='File Error',
            message=f'Cannot read file: {e}'
        )]
    
    issues = []
    
    # AST-based analysis
    try:
        tree = ast.parse(source_code, filename=str(file_path))
        analyzer = ImplementationAnalyzer(source_code)
        analyzer.visit(tree)
        issues.extend(analyzer.issues)
    except SyntaxError as e:
        issues.append(Issue(
            severity='critical',
            category='Syntax Error',
            message=f'Cannot parse file: {e}',
            line=e.lineno
        ))
        return issues
    
    # Regex-based security checks
    issues.extend(check_security_patterns(source_code))
    
    return issues


def print_summary(issues: List[Issue], file_path: Path):
    """Print analysis summary."""
    critical = [i for i in issues if i.severity == 'critical']
    warnings = [i for i in issues if i.severity == 'warning']
    info = [i for i in issues if i.severity == 'info']
    
    print(f"\n{BOLD}{'=' * 60}")
    print(f"IMPLEMENTATION ANALYSIS: {file_path}")
    print(f"{'=' * 60}{RESET}\n")
    
    if not issues:
        print(f"{GREEN}✅ No issues found!{RESET}\n")
        return
    
    # Print summary
    print(f"{BOLD}Summary:{RESET}")
    if critical:
        print(f"  {RED}❌ {len(critical)} Critical issues{RESET}")
    if warnings:
        print(f"  {YELLOW}⚠️  {len(warnings)} Warnings{RESET}")
    if info:
        print(f"  {BLUE}ℹ️  {len(info)} Informational{RESET}")
    
    # Print issues by severity
    if critical:
        print(f"\n{BOLD}CRITICAL ISSUES (must fix):{RESET}")
        for issue in critical:
            print(f"  {issue}")
    
    if warnings:
        print(f"\n{BOLD}WARNINGS (should review):{RESET}")
        for issue in warnings:
            print(f"  {issue}")
    
    if info:
        print(f"\n{BOLD}INFORMATIONAL:{RESET}")
        for issue in info:
            print(f"  {issue}")
    
    # Overall assessment
    print(f"\n{BOLD}Assessment:{RESET}")
    if critical:
        print(f"  {RED}❌ Critical issues must be fixed before merge{RESET}")
    elif warnings:
        print(f"  {YELLOW}⚠️  Review warnings - some may need fixes{RESET}")
    else:
        print(f"  {GREEN}✅ No critical issues, minor improvements suggested{RESET}")
    
    print()


def analyze_directory(directory: Path) -> Dict[Path, List[Issue]]:
    """Analyze all Python files in a directory."""
    python_files = list(directory.rglob('*.py'))
    
    results = {}
    for py_file in python_files:
        # Skip __pycache__ and test files for now
        if '__pycache__' in str(py_file):
            continue
        
        issues = analyze_file(py_file)
        if issues:
            results[py_file] = issues
    
    return results


def main():
    parser = argparse.ArgumentParser(
        description='Implementation Analyzer - Detect code quality and security issues',
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
Examples:
  %(prog)s src/user_service.py
  %(prog)s src/
  %(prog)s . --summary-only

What this analyzes:
  ✓ Code quality (long methods, large classes, many parameters)
  ✓ Security vulnerabilities (SQL injection, hardcoded secrets, etc.)
  ✓ Performance anti-patterns (N+1 queries, time.sleep)
  ✓ Best practices (docstrings, type hints, error handling)
        """
    )
    parser.add_argument('path', type=Path, help='Python file or directory to analyze')
    parser.add_argument('--summary-only', action='store_true', help='Only show summary, not individual issues')
    
    args = parser.parse_args()
    
    if not args.path.exists():
        print(f"{RED}Error: Path not found: {args.path}{RESET}")
        return 1
    
    # Analyze
    if args.path.is_file():
        issues = analyze_file(args.path)
        print_summary(issues, args.path)
        return 1 if any(i.severity == 'critical' for i in issues) else 0
    else:
        results = analyze_directory(args.path)
        
        if not results:
            print(f"{GREEN}✅ No Python files found or no issues detected{RESET}")
            return 0
        
        # Print results for each file
        total_critical = 0
        total_warnings = 0
        total_info = 0
        
        for file_path, issues in results.items():
            if not args.summary_only:
                print_summary(issues, file_path)
            
            total_critical += len([i for i in issues if i.severity == 'critical'])
            total_warnings += len([i for i in issues if i.severity == 'warning'])
            total_info += len([i for i in issues if i.severity == 'info'])
        
        # Print overall summary
        print(f"{BOLD}{'=' * 60}")
        print(f"Overall Summary ({len(results)} files analyzed)")
        print(f"{'=' * 60}{RESET}")
        print(f"  {RED}❌ {total_critical} Critical issues{RESET}")
        print(f"  {YELLOW}⚠️  {total_warnings} Warnings{RESET}")
        print(f"  {BLUE}ℹ️  {total_info} Informational{RESET}\n")
        
        return 1 if total_critical > 0 else 0


if __name__ == '__main__':
    exit(main())
