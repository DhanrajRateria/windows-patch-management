<#
.SYNOPSIS
Exports compliance data for updates to CSV format and logs the action.
.DESCRIPTION
Exports a list of available or installed updates to a CSV file and records the action in an SQL database for compliance tracking.
#>

$connectionString = "Server=(localdb)\MSSQLLocalDB;Integrated Security=true;Database=PatchManagement;"

param(
    [array]$Updates,
    [string]$ReportType
)

# Compliance report directory path
$ComplianceReportPath = "C:\WindowsPatchManagement\Logs\ComplianceReports"

# Ensure compliance report directory exists
if (!(Test-Path $ComplianceReportPath)) {
    New-Item -Path $ComplianceReportPath -ItemType Directory
}

# Export Compliance Report Function
function Export-ComplianceReport {
    param(
        [array]$Updates,
        [string]$ReportType
    )

    # Generate CSV report
    $Timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $ReportFile = "$ComplianceReportPath\$ReportType`_$(Get-Date -Format 'yyyyMMdd').csv"

    if ($Updates) {
        $Updates | Export-Csv -Path $ReportFile -NoTypeInformation
        Write-Log "Exported $ReportType compliance report to $ReportFile" -LogType "Patch"

        # Log report generation into SQL database
        $query = @"
        INSERT INTO ComplianceReports (ComplianceStatus, ReportDate)
        VALUES ('$ReportType', GETDATE());
"@
        Invoke-Sqlcmd -Query $query -ConnectionString $connectionString
    } else {
        Write-Log "No updates found to export for $ReportType compliance report." -LogType "Patch" -Level "WARN"
    }
}