#!/bin/bash

echo "🔍 Checking CI/CD Pipeline Configuration..."

echo "📋 Checking for safety references:"
grep -r "safety" .github/workflows/ || echo "✅ No safety references found"

echo "📋 Checking for pip-audit references:"
grep -r "pip-audit" .github/workflows/ || echo "❌ No pip-audit references found"

echo "📋 Checking test files:"
find . -name "test_*.py" -o -name "*_test.py" | head -5

echo "📋 Checking pytest configuration:"
cat pytest.ini | grep -E "(addopts|DJANGO_SETTINGS_MODULE)" || echo "❌ pytest.ini not found"

echo "✅ Pipeline check completed!"
