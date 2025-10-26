# PowerShell test runner for Terraform + Conftest (OPA)
# Requirements:
# - Terraform CLI installed and available in PATH
# - Conftest installed and available in PATH

$ErrorActionPreference = "Stop"

Write-Host "==> Cleaning previous artifacts" -ForegroundColor Cyan
Remove-Item -ErrorAction SilentlyContinue tfplan
Remove-Item -ErrorAction SilentlyContinue plan.json

Write-Host "==> Running terraform init (backend disabled)" -ForegroundColor Cyan
terraform init -backend=false | Out-Host

Write-Host "==> Running terraform validate" -ForegroundColor Cyan
terraform validate | Out-Host

Write-Host "==> Generating terraform plan" -ForegroundColor Cyan
# Provide defaults via -var only if your variables do not have defaults; adjust as needed.
terraform plan -out=tfplan | Out-Host

Write-Host "==> Converting plan to JSON" -ForegroundColor Cyan
terraform show -json tfplan > plan.json

Write-Host "==> Running conftest against plan.json" -ForegroundColor Cyan
conftest test plan.json --policy ./test/policies | Out-Host

Write-Host "==> All tests completed" -ForegroundColor Green
