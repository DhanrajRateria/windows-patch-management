<#
.SYNOPSIS
Exports compliance data for updates to CSV format.
.DESCRIPTION
Exports a list of available or installed updates to a CSV file for compliance tracking.
#>

$connectionString = "Server=(localdb)\MSSQLLocalDB;Integrated Security=true;"

param(
    [array]$Updates,
    [string]$ReportType
)

# Ensure compliance report directory exists
$ComplianceReportPath = "C:\WindowsPatchManagement\Logs\ComplianceReports"
if (!(Test-Path $ComplianceReportPath)) {
    New-Item -Path $ComplianceReportPath -ItemType Directory
}

# Export updates to CSV
function Export-ComplianceReport {
    param(
        [array]$Updates,
        [string]$ReportType
    )
    $ReportFile = "$ComplianceReportPath\$ReportType`_$(Get-Date -Format 'yyyyMMdd').csv"
    $Updates | Export-Csv $ReportFile -NoTypeInformation
    Write-Log "Exported $ReportType compliance report to $ReportFile" -LogType "Patch"
}
