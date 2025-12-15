# Docker Setup Verification Script (PowerShell)
# This script verifies all Task 1 requirements

Write-Host "============================================" -ForegroundColor Cyan
Write-Host "Docker Setup Verification - Task 1" -ForegroundColor Cyan
Write-Host "============================================" -ForegroundColor Cyan
Write-Host ""

function Check-Pass {
    param([string]$Message)
    Write-Host "✓ PASS: $Message" -ForegroundColor Green
}

function Check-Fail {
    param([string]$Message)
    Write-Host "✗ FAIL: $Message" -ForegroundColor Red
}

function Check-Warn {
    param([string]$Message)
    Write-Host "⚠ WARN: $Message" -ForegroundColor Yellow
}

# Requirement 1: Check for Multistage Dockerfile
Write-Host "1. Checking for optimized multistage Dockerfile..." -ForegroundColor White
if (Test-Path "Dockerfile.multistage") {
    $content = Get-Content "Dockerfile.multistage" -Raw
    if ($content -match "FROM.*as builder" -and $content -match "FROM.*as runtime") {
        Check-Pass "Multistage Dockerfile exists with builder and runtime stages"
    } else {
        Check-Fail "Dockerfile.multistage exists but may not be properly multistage"
    }
} else {
    Check-Fail "Dockerfile.multistage not found"
}
Write-Host ""

# Requirement 2: Check for docker-compose.yml
Write-Host "2. Checking for docker-compose.yml..." -ForegroundColor White
if (Test-Path "docker-compose.yml") {
    Check-Pass "docker-compose.yml exists"
    
    $composeContent = Get-Content "docker-compose.yml" -Raw
    
    # Check for database service
    if ($composeContent -match "web_app_db:") {
        Check-Pass "PostgreSQL database service configured"
    } else {
        Check-Fail "Database service not found"
    }
    
    # Check for cache/message queue
    if ($composeContent -match "redis_cache:") {
        Check-Pass "Redis cache/message queue service configured"
    } else {
        Check-Fail "Redis service not found"
    }
} else {
    Check-Fail "docker-compose.yml not found"
}
Write-Host ""

# Requirement 3: Check for container networking
Write-Host "3. Checking container networking configuration..." -ForegroundColor White
if (Test-Path "docker-compose.yml") {
    $composeContent = Get-Content "docker-compose.yml" -Raw
    
    if ($composeContent -match "networks:") {
        Check-Pass "Custom network defined in docker-compose.yml"
        
        if ($composeContent -match "django_network:") {
            Check-Pass "Network name 'django_network' configured"
        }
        
        if ($composeContent -match "subnet:") {
            Check-Pass "Custom subnet configuration found"
        }
    } else {
        Check-Fail "No custom network configuration found"
    }
}
Write-Host ""

# Requirement 4: Check for persistent storage
Write-Host "4. Checking persistent storage configuration..." -ForegroundColor White
if (Test-Path "docker-compose.yml") {
    $composeContent = Get-Content "docker-compose.yml" -Raw
    
    if ($composeContent -match "volumes:") {
        Check-Pass "Named volumes section exists"
        
        if ($composeContent -match "postgres_data:") {
            Check-Pass "PostgreSQL persistent volume configured"
        } else {
            Check-Fail "PostgreSQL volume not found"
        }
        
        if ($composeContent -match "redis_data:") {
            Check-Pass "Redis persistent volume configured"
        } else {
            Check-Warn "Redis volume not found"
        }
    } else {
        Check-Fail "No volumes configuration found"
    }
}
Write-Host ""

# Requirement 5: Check for no hardcoded secrets
Write-Host "5. Checking for environment-based configuration (no hardcoded secrets)..." -ForegroundColor White
if (Test-Path ".env.example") {
    Check-Pass ".env.example file exists as template"
} else {
    Check-Warn ".env.example not found"
}

if (Test-Path "docker-compose.yml") {
    $composeContent = Get-Content "docker-compose.yml" -Raw
    if ($composeContent -match '\$\{.*\}') {
        Check-Pass "Environment variables used in docker-compose.yml"
    } else {
        Check-Fail "No environment variable substitution found"
    }
}

if (Test-Path "django_project/config/settings/base.py") {
    $settingsContent = Get-Content "django_project/config/settings/base.py" -Raw
    if ($settingsContent -match "environ|env\(") {
        Check-Pass "Settings file uses environment variables"
    } else {
        Check-Fail "Settings file may have hardcoded values"
    }
}
Write-Host ""

# Additional checks
Write-Host "============================================" -ForegroundColor Cyan
Write-Host "Additional Verification" -ForegroundColor Cyan
Write-Host "============================================" -ForegroundColor Cyan
Write-Host ""

# Check if Docker is running
Write-Host "Checking Docker status..." -ForegroundColor White
try {
    docker info | Out-Null
    Check-Pass "Docker daemon is running"
} catch {
    Check-Fail "Docker daemon is not running"
    exit 1
}
Write-Host ""

# Check if containers are running
Write-Host "Checking running containers..." -ForegroundColor White
try {
    $running = docker compose ps --services --filter "status=running" 2>$null
    if ($running) {
        $count = ($running | Measure-Object).Count
        Check-Pass "$count service(s) running"
        docker compose ps
    } else {
        Check-Warn "No services are currently running (run 'docker compose up -d')"
    }
} catch {
    Check-Warn "Could not check running services"
}
Write-Host ""

# Check for network
Write-Host "Checking Docker network..." -ForegroundColor White
$networks = docker network ls | Select-String "django_app_network"
if ($networks) {
    Check-Pass "Custom Docker network exists"
    Write-Host ""
    Write-Host "Network details:" -ForegroundColor Cyan
    docker network inspect django_app_network --format='{{range .Containers}}  - {{.Name}}: {{.IPv4Address}}{{"\n"}}{{end}}'
} else {
    Check-Warn "Network not found (created on first 'docker compose up')"
}
Write-Host ""

# Check for volumes
Write-Host "Checking Docker volumes..." -ForegroundColor White
$volumes = docker volume ls | Select-String "django_"
if ($volumes) {
    $count = ($volumes | Measure-Object).Count
    Check-Pass "$count Django-related volume(s) exist"
    docker volume ls | Select-String "django_"
} else {
    Check-Warn "No Django volumes found (volumes created on first 'docker compose up')"
}
Write-Host ""

# Summary
Write-Host "============================================" -ForegroundColor Cyan
Write-Host "Verification Complete!" -ForegroundColor Cyan
Write-Host "============================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "To start the services, run:" -ForegroundColor Yellow
Write-Host "  docker compose up -d" -ForegroundColor White
Write-Host ""
Write-Host "To view logs:" -ForegroundColor Yellow
Write-Host "  docker compose logs -f" -ForegroundColor White
Write-Host ""
Write-Host "For detailed setup instructions, see: DOCKER_SETUP.md" -ForegroundColor Cyan
Write-Host ""
