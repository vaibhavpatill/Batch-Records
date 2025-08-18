# SSRS Configuration Script
# Run as Administrator

Write-Host "Configuring SSRS..." -ForegroundColor Green

# Import SSRS WMI module
try {
    $rsConfig = Get-WmiObject -Namespace "root\Microsoft\SqlServer\ReportServer\RS_SSRS\v15\Admin" -Class MSReportServer_ConfigurationSetting
    
    if ($rsConfig) {
        Write-Host "SSRS instance found" -ForegroundColor Green
        
        # Initialize SSRS
        $rsConfig.InitializeReportServer()
        
        # Set Web Service URL
        $rsConfig.SetVirtualDirectory("ReportServerWebService", "ReportServer", 1033)
        $rsConfig.ReserveURL("ReportServerWebService", "http://+:80", 1033)
        
        # Set Web Portal URL  
        $rsConfig.SetVirtualDirectory("ReportServerWebApp", "Reports", 1033)
        $rsConfig.ReserveURL("ReportServerWebApp", "http://+:80", 1033)
        
        Write-Host "SSRS configured successfully!" -ForegroundColor Green
        Write-Host "Report Server URL: http://localhost/ReportServer" -ForegroundColor Cyan
        Write-Host "Web Portal URL: http://localhost/Reports" -ForegroundColor Cyan
    }
    else {
        Write-Host "SSRS instance not found. Please install SSRS first." -ForegroundColor Red
    }
}
catch {
    Write-Host "Error configuring SSRS: $_" -ForegroundColor Red
    Write-Host "Please install complete SSRS package from Microsoft" -ForegroundColor Yellow
}