#!/bin/bash
# Docker Setup Verification Script
# This script verifies all Task 1 requirements

echo "============================================"
echo "Docker Setup Verification - Task 1"
echo "============================================"
echo ""

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

check_pass() {
    echo -e "${GREEN}✓ PASS${NC}: $1"
}

check_fail() {
    echo -e "${RED}✗ FAIL${NC}: $1"
}

check_warn() {
    echo -e "${YELLOW}⚠ WARN${NC}: $1"
}

# Requirement 1: Check for Multistage Dockerfile
echo "1. Checking for optimized multistage Dockerfile..."
if [ -f "Dockerfile.multistage" ]; then
    if grep -q "FROM.*as builder" Dockerfile.multistage && grep -q "FROM.*as runtime" Dockerfile.multistage; then
        check_pass "Multistage Dockerfile exists with builder and runtime stages"
    else
        check_fail "Dockerfile.multistage exists but may not be properly multistage"
    fi
else
    check_fail "Dockerfile.multistage not found"
fi
echo ""

# Requirement 2: Check for docker-compose.yml
echo "2. Checking for docker-compose.yml..."
if [ -f "docker-compose.yml" ]; then
    check_pass "docker-compose.yml exists"
    
    # Check for database service
    if grep -q "web_app_db:" docker-compose.yml; then
        check_pass "PostgreSQL database service configured"
    else
        check_fail "Database service not found"
    fi
    
    # Check for cache/message queue
    if grep -q "redis_cache:" docker-compose.yml; then
        check_pass "Redis cache/message queue service configured"
    else
        check_fail "Redis service not found"
    fi
else
    check_fail "docker-compose.yml not found"
fi
echo ""

# Requirement 3: Check for container networking
echo "3. Checking container networking configuration..."
if grep -q "networks:" docker-compose.yml; then
    check_pass "Custom network defined in docker-compose.yml"
    
    if grep -q "django_network:" docker-compose.yml; then
        check_pass "Network name 'django_network' configured"
    fi
    
    if grep -q "subnet:" docker-compose.yml; then
        check_pass "Custom subnet configuration found"
    fi
else
    check_fail "No custom network configuration found"
fi
echo ""

# Requirement 4: Check for persistent storage
echo "4. Checking persistent storage configuration..."
if grep -q "volumes:" docker-compose.yml; then
    check_pass "Named volumes section exists"
    
    if grep -q "postgres_data:" docker-compose.yml; then
        check_pass "PostgreSQL persistent volume configured"
    else
        check_fail "PostgreSQL volume not found"
    fi
    
    if grep -q "redis_data:" docker-compose.yml; then
        check_pass "Redis persistent volume configured"
    else
        check_warn "Redis volume not found"
    fi
else
    check_fail "No volumes configuration found"
fi
echo ""

# Requirement 5: Check for no hardcoded secrets
echo "5. Checking for environment-based configuration (no hardcoded secrets)..."
if [ -f ".env.example" ]; then
    check_pass ".env.example file exists as template"
else
    check_warn ".env.example not found"
fi

if grep -q "\${.*}" docker-compose.yml; then
    check_pass "Environment variables used in docker-compose.yml"
else
    check_fail "No environment variable substitution found"
fi

if [ -f "django_project/config/settings/base.py" ]; then
    if grep -q "environ\|env(" django_project/config/settings/base.py; then
        check_pass "Settings file uses environment variables"
    else
        check_fail "Settings file may have hardcoded values"
    fi
fi
echo ""

# Additional checks
echo "============================================"
echo "Additional Verification"
echo "============================================"
echo ""

# Check if Docker is running
echo "Checking Docker status..."
if docker info > /dev/null 2>&1; then
    check_pass "Docker daemon is running"
else
    check_fail "Docker daemon is not running"
    exit 1
fi
echo ""

# Check if containers are running (if compose is up)
echo "Checking running containers..."
if docker compose ps > /dev/null 2>&1; then
    RUNNING=$(docker compose ps --services --filter "status=running" 2>/dev/null | wc -l)
    if [ "$RUNNING" -gt 0 ]; then
        check_pass "$RUNNING service(s) running"
        docker compose ps
    else
        check_warn "No services are currently running (run 'docker compose up -d')"
    fi
fi
echo ""

# Check for network if containers are running
if docker network ls | grep -q "django_app_network"; then
    check_pass "Custom Docker network exists"
    echo ""
    echo "Network details:"
    docker network inspect django_app_network --format='{{range .Containers}}  - {{.Name}}: {{.IPv4Address}}{{"\n"}}{{end}}'
fi
echo ""

# Check for volumes
echo "Checking Docker volumes..."
VOLUMES=$(docker volume ls | grep -c "django_")
if [ "$VOLUMES" -gt 0 ]; then
    check_pass "$VOLUMES Django-related volume(s) exist"
    docker volume ls | grep "django_"
else
    check_warn "No Django volumes found (volumes created on first 'docker compose up')"
fi
echo ""

# Summary
echo "============================================"
echo "Verification Complete!"
echo "============================================"
echo ""
echo "To start the services, run:"
echo "  docker compose up -d"
echo ""
echo "To view logs:"
echo "  docker compose logs -f"
echo ""
echo "For detailed setup instructions, see: DOCKER_SETUP.md"
echo ""
