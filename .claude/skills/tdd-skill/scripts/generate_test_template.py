#!/usr/bin/env python3
"""
Generate test file templates for TDD.

Usage:
    python generate_test_template.py <module_name> [--language python|typescript]
    
Examples:
    python generate_test_template.py calculator
    python generate_test_template.py calculator --language typescript
"""

import argparse
import os
from pathlib import Path

PYTHON_TEMPLATE = '''"""
Tests for {module_name} module.

Following TDD principles:
1. Write test first (Red)
2. Make it pass (Green)
3. Refactor
"""

import pytest
from src.{module_name} import {class_name}


class Test{class_name}:
    """Test suite for {class_name}."""
    
    def setup_method(self):
        """Set up test fixtures before each test method."""
        # Arrange - Set up any test data or objects needed
        pass
    
    def teardown_method(self):
        """Clean up after each test method."""
        pass
    
    def test_placeholder(self):
        """
        Test description following pattern:
        test_<what>_<condition>_<expected_result>
        """
        # Arrange
        # Act
        # Assert
        pass


# Standalone test functions (alternative to class-based tests)

def test_{module_name}_example():
    """Example standalone test."""
    # Arrange
    
    # Act
    
    # Assert
    pass


@pytest.fixture
def {module_name}_instance():
    """Fixture providing a {class_name} instance for tests."""
    return {class_name}()


def test_with_fixture({module_name}_instance):
    """Example test using fixture."""
    # Arrange
    
    # Act
    
    # Assert
    pass


# Parameterized tests for multiple inputs

@pytest.mark.parametrize("input_value,expected_output", [
    (1, 2),
    (2, 4),
    (3, 6),
])
def test_{module_name}_with_parameters(input_value, expected_output):
    """Example parameterized test."""
    # Act
    result = input_value * 2
    
    # Assert
    assert result == expected_output
'''

TYPESCRIPT_TEMPLATE = '''/**
 * Tests for {module_name} module.
 * 
 * Following TDD principles:
 * 1. Write test first (Red)
 * 2. Make it pass (Green)
 * 3. Refactor
 */

import {{ describe, it, expect, beforeEach, afterEach }} from 'vitest';
// Or for Jest: import {{ describe, it, expect, beforeEach, afterEach }} from '@jest/globals';
import {{ {class_name} }} from '../src/{module_name}';

describe('{class_name}', () => {{
  let instance: {class_name};

  beforeEach(() => {{
    // Arrange - Set up test fixtures before each test
    instance = new {class_name}();
  }});

  afterEach(() => {{
    // Clean up after each test
  }});

  it('should exist', () => {{
    expect(instance).toBeDefined();
  }});

  describe('when doing something', () => {{
    it('should have expected behavior', () => {{
      // Arrange
      
      // Act
      
      // Assert
      expect(true).toBe(true);
    }});
  }});

  // Example: Testing error cases
  describe('when given invalid input', () => {{
    it('should throw an error', () => {{
      // Arrange
      const invalidInput = null;
      
      // Act & Assert
      expect(() => {{
        instance.someMethod(invalidInput);
      }}).toThrow();
    }});
  }});
}});

// Parameterized tests using test.each
describe('{module_name} with multiple inputs', () => {{
  it.each([
    {{ input: 1, expected: 2 }},
    {{ input: 2, expected: 4 }},
    {{ input: 3, expected: 6 }},
  ])('should return $expected when given $input', ({{ input, expected }}) => {{
    const result = input * 2;
    expect(result).toBe(expected);
  }});
}});
'''

def to_class_name(module_name: str) -> str:
    """Convert module name to class name (PascalCase)."""
    return ''.join(word.capitalize() for word in module_name.split('_'))

def generate_python_test(module_name: str, output_path: Path):
    """Generate Python test file."""
    class_name = to_class_name(module_name)
    content = PYTHON_TEMPLATE.format(
        module_name=module_name,
        class_name=class_name
    )
    
    test_file = output_path / f"test_{module_name}.py"
    test_file.write_text(content)
    print(f"✓ Created Python test file: {test_file}")
    print(f"\nNext steps:")
    print(f"1. Create src/{module_name}.py with a {class_name} class")
    print(f"2. Run: pytest {test_file}")
    print(f"3. Watch it fail (Red)")
    print(f"4. Implement minimal code to pass (Green)")
    print(f"5. Refactor")

def generate_typescript_test(module_name: str, output_path: Path):
    """Generate TypeScript test file."""
    class_name = to_class_name(module_name)
    content = TYPESCRIPT_TEMPLATE.format(
        module_name=module_name,
        class_name=class_name
    )
    
    test_file = output_path / f"{module_name}.test.ts"
    test_file.write_text(content)
    print(f"✓ Created TypeScript test file: {test_file}")
    print(f"\nNext steps:")
    print(f"1. Create src/{module_name}.ts with a {class_name} class")
    print(f"2. Run: npm test {module_name}")
    print(f"3. Watch it fail (Red)")
    print(f"4. Implement minimal code to pass (Green)")
    print(f"5. Refactor")

def main():
    parser = argparse.ArgumentParser(
        description='Generate test file templates for TDD',
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
Examples:
  %(prog)s calculator
  %(prog)s calculator --language typescript
  %(prog)s user_service --output tests/
        """
    )
    parser.add_argument('module_name', help='Name of the module to test (e.g., calculator, user_service)')
    parser.add_argument(
        '--language', '-l',
        choices=['python', 'typescript'],
        default='python',
        help='Programming language (default: python)'
    )
    parser.add_argument(
        '--output', '-o',
        type=Path,
        default=Path('tests'),
        help='Output directory (default: tests/)'
    )
    
    args = parser.parse_args()
    
    # Create output directory if it doesn't exist
    args.output.mkdir(parents=True, exist_ok=True)
    
    # Generate test file
    if args.language == 'python':
        generate_python_test(args.module_name, args.output)
    else:
        generate_typescript_test(args.module_name, args.output)

if __name__ == '__main__':
    main()
