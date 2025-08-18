# SSRS Report Deployment Guide

## 📋 Prerequisites
- SQL Server with Reporting Services installed
- SQL Server Management Studio (SSMS)
- Administrative access to the server
- Report Builder or Visual Studio with SSDT

## 🚀 Automated Deployment (Recommended)

### Option 1: Run PowerShell Script
```powershell
# Run as Administrator
cd "C:\Django C"
.\deploy_ssrs_report.ps1
```

## 🔧 Manual Deployment Steps

### Step 1: Verify SSRS Installation
1. **Check Services:**
   - Open Services (services.msc)
   - Verify "SQL Server Reporting Services" is running
   - Verify "SQL Server (MSSQLSERVER)" is running

2. **Test SSRS Access:**
   - Open browser: `http://localhost/ReportServer`
   - Should show SSRS directory listing
   - Open Report Manager: `http://localhost/Reports`

### Step 2: Setup Database
1. **Open SQL Server Management Studio**
2. **Connect to your SQL Server instance**
3. **Run database setup:**
   ```sql
   -- Execute: C:\Django C\batch_project\setup_sqlserver_db.sql
   ```
4. **Generate sample data:**
   ```sql
   -- Execute: C:\Django C\batch_project\generate_sample_data.sql
   ```

### Step 3: Create Data Source
1. **Open Report Manager** (`http://localhost/Reports`)
2. **Click "New Data Source"**
3. **Configure:**
   - Name: `BatchDataSource`
   - Type: `Microsoft SQL Server`
   - Connection String: `Data Source=localhost\SQLEXPRESS;Initial Catalog=BatchDB`
   - Credentials: `Windows integrated security`
4. **Click "OK"**

### Step 4: Create Report Folder
1. **In Report Manager, click "New Folder"**
2. **Name:** `BatchReports`
3. **Click "OK"**

### Step 5: Deploy Report
#### Method A: Using Report Manager (Web Interface)
1. **Navigate to BatchReports folder**
2. **Click "Upload File"**
3. **Browse to:** `C:\Django C\batch_project\ssrs_reports\BatchProcessReport_Professional.rdl`
4. **Name:** `BatchProcessReport_Professional`
5. **Click "OK"**

#### Method B: Using Report Builder
1. **Open SQL Server Report Builder**
2. **File → Open**
3. **Select:** `BatchProcessReport_Professional.rdl`
4. **File → Save As**
5. **Save to Report Server:**
   - Server: `http://localhost/ReportServer`
   - Folder: `/BatchReports`
   - Name: `BatchProcessReport_Professional`

#### Method C: Using Visual Studio (SSDT)
1. **Create new Reporting Services Project**
2. **Add existing report:** `BatchProcessReport_Professional.rdl`
3. **Configure Project Properties:**
   - TargetServerURL: `http://localhost/ReportServer`
   - TargetReportFolder: `BatchReports`
4. **Right-click project → Deploy**

### Step 6: Configure Data Source Reference
1. **In Report Manager, navigate to the deployed report**
2. **Click on report name**
3. **Go to "Data Sources" tab**
4. **Click "BatchDataSource"**
5. **Select "A shared data source"**
6. **Browse and select:** `/BatchDataSource`
7. **Click "Apply"**

### Step 7: Test Report
1. **Click on report name in Report Manager**
2. **Enter parameters:**
   - BatchNumber: `B001` (or `B002`)
3. **Click "View Report"**
4. **Verify:**
   - Logo appears (if logo file exists)
   - Batch information displays correctly
   - Time-series data table shows all records
   - Professional formatting is applied

## 🔍 Troubleshooting

### Common Issues:

#### 1. "Data source 'BatchDataSource' could not be found"
**Solution:**
- Verify data source is created in Report Manager
- Check data source name matches exactly
- Ensure report references correct data source

#### 2. "Login failed for user"
**Solution:**
- Use Windows Authentication in connection string
- Verify SQL Server allows Windows Authentication
- Check user has access to BatchDB database

#### 3. "Report Server is not available"
**Solution:**
- Verify SSRS service is running
- Check Report Server URL is correct
- Ensure firewall allows access to port 80

#### 4. "Image cannot be loaded"
**Solution:**
- Add company logo to: `C:\Django C\batch_project\static\images\company_logo.png`
- Or remove image element from report

#### 5. "No data available"
**Solution:**
- Run sample data generation script
- Verify database connection
- Check batch number parameter matches existing data

## 📊 Report URLs

After successful deployment:

- **Report Manager:** `http://localhost/Reports`
- **Direct Report URL:** `http://localhost/ReportServer/Pages/ReportViewer.aspx?/BatchReports/BatchProcessReport_Professional`
- **Report with Parameters:** `http://localhost/ReportServer/Pages/ReportViewer.aspx?/BatchReports/BatchProcessReport_Professional&BatchNumber=B001`

## 🎯 Next Steps

1. **Customize the report** with your company logo
2. **Add more batch data** for testing
3. **Set up automated report generation** from Django
4. **Configure report subscriptions** for automatic delivery
5. **Add security roles** for different user access levels

## 📞 Support

If you encounter issues:
1. Check Windows Event Logs
2. Review SSRS log files in: `C:\Program Files\Microsoft SQL Server\MSRS13.MSSQLSERVER\Reporting Services\LogFiles`
3. Verify SQL Server error logs
4. Test database connectivity separately