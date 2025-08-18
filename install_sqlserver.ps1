# SQL Server Express Installation Script
# Run as Administrator

Write-Host "Downloading SQL Server Express..." -ForegroundColor Green

# Download SQL Server Express
$url = "https://download.microsoft.com/download/7/f/8/7f8a9c43-8c8a-4f7c-9f92-83c18d96b681/SQLEXPR_x64_ENU.exe"
$output = "$env:TEMP\SQLEXPR_x64_ENU.exe"

try {
    Invoke-WebRequest -Uri $url -OutFile $output
    Write-Host "Download completed." -ForegroundColor Green
    
    Write-Host "Installing SQL Server Express..." -ForegroundColor Yellow
    
    # Install SQL Server Express with default settings
    Start-Process -FilePath $output -ArgumentList "/Q", "/IACCEPTSQLSERVERLICENSETERMS", "/ACTION=Install", "/FEATURES=SQLEngine", "/INSTANCENAME=SQLEXPRESS", "/SECURITYMODE=SQL", "/SAPWD=Password123", "/ADDCURRENTUSERASSQLADMIN" -Wait
    
    Write-Host "SQL Server Express installed successfully!" -ForegroundColor Green
    Write-Host "Instance Name: .\SQLEXPRESS" -ForegroundColor Cyan
    Write-Host "SA Password: Password123" -ForegroundColor Cyan
    
    # Start SQL Server service
    Start-Service -Name "MSSQL`$SQLEXPRESS"
    Write-Host "SQL Server service started." -ForegroundColor Green
    
} catch {
    Write-Host "Error: $_" -ForegroundColor Red
}