#!/usr/bin/env python3
"""
Pipeline verification script
"""

import os
import subprocess
import sys

def run_command(cmd):
    """Run a command and return the result."""
    try:
        result = subprocess.run(cmd, shell=True, capture_output=True, text=True)
        return result.returncode == 0, result.stdout, result.stderr
    except Exception as e:
        return False, "", str(e)

def main():
    print("🔍 Verifying CI/CD Pipeline Configuration...")
    print("=" * 50)
    
    # Check if we're in the right directory
    if not os.path.exists('.github/workflows/ci-cd.yml'):
        print("❌ CI/CD workflow file not found!")
        return 1
    
    print("✅ CI/CD workflow file found")
    
    # Check for safety references
    with open('.github/workflows/ci-cd.yml', 'r') as f:
        content = f.read()
        if 'safety check' in content or 'safety scan' in content:
            print("❌ Found safety references in workflow!")
            return 1
        else:
            print("✅ No safety references found")
    
    # Check for pip-audit references
    if 'pip-audit' in content:
        print("✅ pip-audit found in workflow")
    else:
        print("❌ pip-audit not found in workflow!")
        return 1
    
    # Check test files
    test_files = []
    for root, dirs, files in os.walk('.'):
        for file in files:
            if file.startswith('test_') and file.endswith('.py'):
                test_files.append(os.path.join(root, file))
    
    if test_files:
        print(f"✅ Found {len(test_files)} test files")
    else:
        print("❌ No test files found!")
        return 1
    
    # Check pytest configuration
    if os.path.exists('pytest.ini'):
        print("✅ pytest.ini found")
    else:
        print("❌ pytest.ini not found!")
        return 1
    
    print("=" * 50)
    print("✅ All checks passed! Pipeline should work correctly.")
    return 0

if __name__ == "__main__":
    sys.exit(main())
