# Terraform Helper Script for Windows PowerShell
# This script sets up the environment and provides easy commands

# Set Terraform path
$env:Path += ";$env:USERPROFILE\terraform"
$TF = "$env:USERPROFILE\terraform\terraform.exe"

Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host "Terraform AWS Infrastructure Setup" -ForegroundColor Cyan
Write-Host "========================================`n" -ForegroundColor Cyan

# Change to infra directory
Set-Location -Path "$PSScriptRoot"

function Show-Menu {
    Write-Host "Available Commands:" -ForegroundColor Yellow
    Write-Host "  1. terraform init    - Initialize Terraform"
    Write-Host "  2. terraform plan    - Preview changes"
    Write-Host "  3. terraform apply   - Create infrastructure"
    Write-Host "  4. terraform output  - Show outputs"
    Write-Host "  5. terraform destroy - Delete all resources"
    Write-Host "  6. exit             - Exit script`n"
}

# Check if initialized
if (-not (Test-Path ".terraform")) {
    Write-Host "⚠️  Terraform not initialized. Running 'terraform init'...`n" -ForegroundColor Yellow
    & $TF init
    Write-Host "`n✅ Terraform initialized!`n" -ForegroundColor Green
}

Show-Menu

while ($true) {
    $choice = Read-Host "Enter command number (or type custom terraform command)"
    
    switch ($choice) {
        "1" {
            Write-Host "`nRunning: terraform init`n" -ForegroundColor Cyan
            & $TF init
        }
        "2" {
            Write-Host "`nRunning: terraform plan`n" -ForegroundColor Cyan
            & $TF plan
        }
        "3" {
            Write-Host "`nRunning: terraform apply`n" -ForegroundColor Cyan
            Write-Host "⚠️  This will create AWS resources and incur costs!" -ForegroundColor Yellow
            $confirm = Read-Host "Continue? (yes/no)"
            if ($confirm -eq "yes") {
                & $TF apply
            } else {
                Write-Host "Cancelled." -ForegroundColor Yellow
            }
        }
        "4" {
            Write-Host "`nRunning: terraform output`n" -ForegroundColor Cyan
            & $TF output
        }
        "5" {
            Write-Host "`nRunning: terraform destroy`n" -ForegroundColor Cyan
            Write-Host "⚠️  This will DELETE all AWS resources!" -ForegroundColor Red
            $confirm = Read-Host "Are you sure? (yes/no)"
            if ($confirm -eq "yes") {
                & $TF destroy
            } else {
                Write-Host "Cancelled." -ForegroundColor Yellow
            }
        }
        "6" { 
            Write-Host "`nExiting...`n" -ForegroundColor Green
            break 
        }
        "exit" { 
            Write-Host "`nExiting...`n" -ForegroundColor Green
            break 
        }
        default {
            # Try to run as custom terraform command
            Write-Host "`nRunning: terraform $choice`n" -ForegroundColor Cyan
            & $TF $choice.Split()
        }
    }
    
    Write-Host "`n"
}
