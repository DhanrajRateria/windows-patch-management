# Windows Automated Patch Management System
This project provides a comprehensive solution for automating Windows updates and patch management. It is designed to ensure system compliance, reduce manual effort, and streamline the update process while providing features like scheduling, rollback capabilities, compliance reporting, and real-time dashboards.

## Directory Structure
```plaintext
Windows-Patch-Management/
│
├── Config/
│   └── PatchPolicy.json          # JSON configuration for update policies (e.g., scheduling, exclusions)
│
├── Database/
│   └── PatchManagement.sql       # SQL script for setting up the database for tracking updates
│
├── Scripts/
│   ├── Export-ComplianceReport.ps1      # Script to generate compliance reports in CSV or PDF format
│   ├── Rollback-SystemPatches.ps1       # Script to rollback updates if necessary
│   ├── Schedule-UpdateTask.ps1          # Script to schedule updates based on policies
│   ├── Update-StatusDashboard.ps1       # Script to update the real-time status dashboard
│   ├── Update-SystemPatches.ps1         # Script to install Windows updates
│   └── Write-Log.ps1                    # Script to log all operations and errors in a centralized log file
```

## Features
### Policy-Based Scheduling:
Updates are scheduled based on user-defined policies in the PatchPolicy.json file.

### Automated Patching:
Automatically scans and installs pending updates using the Update-SystemPatches.ps1 script.

### Compliance Reporting:
Generates detailed compliance reports (Export-ComplianceReport.ps1) to ensure systems are up-to-date.

### Rollback Capability:
Rollback any faulty patches using the Rollback-SystemPatches.ps1 script.

### Real-Time Dashboard:
View patching status on a live dashboard (Update-StatusDashboard.ps1).
### Error Handling & Logging:
All operations are logged using Write-Log.ps1 for troubleshooting and audit purposes.

## Getting Started
- Prerequisites
1. PowerShell: Ensure PowerShell 5.1 or higher is installed.
2. Database: Set up the tracking database using the PatchManagement.sql script on a compatible SQL Server instance.
3. Permissions: Run the scripts with administrative privileges to manage system updates.

- Setup
Clone the repository:

```bash
git clone https://github.com/YourUsername/Windows-Patch-Management.git
cd Windows-Patch-Management
```
- Configure policies in Config/PatchPolicy.json:

```json
{
  "UpdateSchedule": "02:00 AM",
  "ExcludedUpdates": ["KB123456", "KB789012"],
  "EnableAutoRollback": true
}
```

- Set up the database:

``` bash
sqlcmd -S <YourServerName> -d <YourDatabaseName> -i Database/PatchManagement.sql
```

## Usage
1. Schedule Updates: Run the Schedule-UpdateTask.ps1 script to schedule updates:

```powershell
.\Scripts\Schedule-UpdateTask.ps1 -PolicyPath .\Config\PatchPolicy.json
```

2. Install Updates: Run the Update-SystemPatches.ps1 script to install pending updates:

```powershell
.\Scripts\Update-SystemPatches.ps1
```

3. Rollback Updates: If needed, roll back updates using:

```powershell
.\Scripts\Rollback-SystemPatches.ps1 -UpdateID KB123456
```

4. Export Compliance Report: Generate compliance reports in CSV format:

```powershell
.\Scripts\Export-ComplianceReport.ps1 -OutputPath .\Reports
```

5. Update Status Dashboard: Update the real-time dashboard:

```powershell
.\Scripts\Update-StatusDashboard.ps1
```
## Logging
All operations and errors are logged to C:\Logs\PatchManagement.log. Customize the log file path in the Write-Log.ps1 script if required.

## Contributing
Contributions are welcome! Please fork the repository and submit a pull request with your changes.

## License
This project is licensed under the MIT License. See the LICENSE file for more details.
