<#
.SYNOPSIS
Automated Windows Patch Management System with Logging and Compliance Reporting
.DESCRIPTION
Comprehensive script for scanning, downloading, and installing Windows updates,
with advanced logging and compliance reporting.
#>

$connectionString = "Server=(localdb)\MSSQLLocalDB;Integrated Security=true;"

param(
    [switch]$ScanOnly = $false,
    [switch]$AutoInstall = $false,
    [int]$MaxUpdatesToInstall = 50
)

# Import Logging and Compliance Reporting functions
. "$PSScriptRoot\Write-Log.ps1"
. "$PSScriptRoot\Export-ComplianceReport.ps1"

# Update Scanning Function
function Get-SystemUpdates {
    try {
        Write-Log "Initializing Windows Update Scan" -LogType "Patch"
        $Updates = Get-WindowsUpdate -MicrosoftUpdate -ErrorAction Stop
        Write-Log "Found $($Updates.Count) available updates" -LogType "Patch"
        return $Updates
    }
    catch {
        Write-Log "Update scan failed: $_" -LogType "Patch" -Level "ERROR"
        return $null
    }
}

# Update Installation Function
function Install-SystemUpdates {
    param($Updates)
    
    if (!$Updates) {
        Write-Log "No updates available for installation" -LogType "Patch" -Level "WARN"
        return
    }

    $UpdatesToInstall = $Updates | Select-Object -First $MaxUpdatesToInstall

    try {
        Write-Log "Preparing to install $($UpdatesToInstall.Count) updates" -LogType "Patch"
        
        $InstallResults = $UpdatesToInstall | Install-WindowsUpdate -AcceptAll -IgnoreReboot
        
        foreach ($Result in $InstallResults) {
            Write-Log "Update Result: $($Result.Title) - Status: $($Result.Status)" -LogType "Patch"
        }

        Write-Log "Patch installation completed" -LogType "Patch" -Level "SUCCESS"
    }
    catch {
        Write-Log "Patch installation failed: $_" -LogType "Patch" -Level "ERROR"
    }
}

# Main Patch Management Execution
function Invoke-PatchManagement {
    Write-Log "Starting Patch Management Process" -LogType "Patch"

    $AvailableUpdates = Get-SystemUpdates

    if ($ScanOnly) {
        # Just report available updates
        Export-ComplianceReport -Updates $AvailableUpdates -ReportType "scan"
    }
    elseif ($AutoInstall) {
        Install-SystemUpdates -Updates $AvailableUpdates
        Export-ComplianceReport -Updates $AvailableUpdates -ReportType "install"
    }

    Write-Log "Patch Management Process Completed" -LogType "Patch"
}

# Execute Patch Management
Invoke-PatchManagement