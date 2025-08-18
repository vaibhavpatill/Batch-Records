# Complete SSRS Configuration Script
# Run as Administrator

Write-Host "Configuring SQL Server Reporting Services..." -ForegroundColor Green

try {
    # Get SSRS WMI instance
    $rsConfig = Get-WmiObject -Namespace "root\Microsoft\SqlServer\ReportServer" -Class MSReportServer_ConfigurationSetting -ErrorAction Stop
    
    if ($rsConfig) {
        Write-Host "Found SSRS instance: $($rsConfig.InstanceName)" -ForegroundColor Green
        
        # Initialize Report Server Database
        Write-Host "Initializing Report Server..." -ForegroundColor Yellow
        $result = $rsConfig.InitializeReportServer($rsConfig.InstallationID)
        if ($result.HRESULT -eq 0) {
            Write-Host "Report Server initialized successfully" -ForegroundColor Green
        }
        
        # Configure Web Service URL
        Write-Host "Configuring Web Service URL..." -ForegroundColor Yellow
        $rsConfig.RemoveURL("ReportServerWebService", "http://+:80", 1033)
        $result = $rsConfig.ReserveURL("ReportServerWebService", "http://+:80", 1033)
        if ($result.HRESULT -eq 0) {
            Write-Host "Web Service URL configured: http://localhost/ReportServer" -ForegroundColor Green
        }
        
        # Configure Web Portal URL
        Write-Host "Configuring Web Portal URL..." -ForegroundColor Yellow
        $rsConfig.RemoveURL("ReportServerWebApp", "http://+:80", 1033)
        $result = $rsConfig.ReserveURL("ReportServerWebApp", "http://+:80", 1033)
        if ($result.HRESULT -eq 0) {
            Write-Host "Web Portal URL configured: http://localhost/Reports" -ForegroundColor Green
        }
        
        # Set Virtual Directory
        $rsConfig.SetVirtualDirectory("ReportServerWebService", "ReportServer", 1033)
        $rsConfig.SetVirtualDirectory("ReportServerWebApp", "Reports", 1033)
        
        Write-Host "`nSSRS Configuration completed successfully!" -ForegroundColor Green
        Write-Host "Report Server URL: http://localhost/ReportServer" -ForegroundColor Cyan
        Write-Host "Web Portal URL: http://localhost/Reports" -ForegroundColor Cyan
        
        # Test URLs
        Write-Host "`nTesting URLs..." -ForegroundColor Yellow
        try {
            $response = Invoke-WebRequest -Uri "http://localhost/ReportServer" -UseBasicParsing -TimeoutSec 10
            Write-Host "Report Server URL is accessible (Status: $($response.StatusCode))" -ForegroundColor Green
        } catch {
            Write-Host "Report Server URL test failed: $($_.Exception.Message)" -ForegroundColor Red
        }
        
        try {
            $response = Invoke-WebRequest -Uri "http://localhost/Reports" -UseBasicParsing -TimeoutSec 10
            Write-Host "Web Portal URL is accessible (Status: $($response.StatusCode))" -ForegroundColor Green
        } catch {
            Write-Host "Web Portal URL test failed: $($_.Exception.Message)" -ForegroundColor Red
        }
    }
    else {
        Write-Host "SSRS WMI instance not found" -ForegroundColor Red
    }
}
catch {
    Write-Host "Error configuring SSRS: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host "Trying alternative configuration method..." -ForegroundColor Yellow
    
    # Alternative method using rsconfig.exe
    try {
        $rsConfigPath = Get-ChildItem -Path "C:\Program Files\Microsoft SQL Server" -Recurse -Name "rsconfig.exe" -ErrorAction SilentlyContinue | Select-Object -First 1
        if ($rsConfigPath) {
            $fullPath = Join-Path "C:\Program Files\Microsoft SQL Server" $rsConfigPath
            Write-Host "Found rsconfig.exe at: $fullPath" -ForegroundColor Green
            
            # Configure using rsconfig.exe
            & $fullPath -c -s localhost -d ReportServer -a Windows
            Write-Host "SSRS configured using rsconfig.exe" -ForegroundColor Green
        }
        else {
            Write-Host "rsconfig.exe not found" -ForegroundColor Red
        }
    }
    catch {
        Write-Host "Alternative configuration failed: $($_.Exception.Message)" -ForegroundColor Red
    }
}

Write-Host "`nNext steps:" -ForegroundColor Yellow
Write-Host "1. Open web browser and go to http://localhost/Reports" -ForegroundColor White
Write-Host "2. Create a new folder called 'BatchReports'" -ForegroundColor White
Write-Host "3. Upload the BatchProcessReport.rdl file" -ForegroundColor White