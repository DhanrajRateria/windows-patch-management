<#
.SYNOPSIS
Logging utility for Patch Management and Rollback processes.
.DESCRIPTION
Provides functions to log messages during patch management and rollback with detailed timestamps and log levels.
#>



param(
    [string]$Message,
    [string]$LogType = "Patch",  # Default log type is 'Patch'
    [string]$Level = "INFO"
)

$connectionString = "Server=(localdb)\MSSQLLocalDB;Integrated Security=true;"

# Logging Configuration
$LogPath = "C:\WindowsPatchManagement\Logs\PatchLogs"
$RollbackLogPath = "C:\WindowsPatchManagement\Logs\RollbackLogs"

# Ensure log directories exist
if (!(Test-Path $LogPath)) { New-Item -Path $LogPath -ItemType Directory }
if (!(Test-Path $RollbackLogPath)) { New-Item -Path $RollbackLogPath -ItemType Directory }

# Write Log Function
function Write-Log {
    param(
        [string]$Message,
        [string]$LogType = "Patch",  # Default log type is 'Patch'
        [string]$Level = "INFO"
    )
    $Timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $LogEntry = "$Timestamp [$Level] $Message"
    $LogFilePath = if ($LogType -eq "Rollback") { $RollbackLogPath } else { $LogPath }
    Add-Content -Path "$LogFilePath\$(if ($LogType -eq 'Rollback') {'rollback'} else {'patch'})_$(Get-Date -Format 'yyyyMMdd').log" -Value $LogEntry
    Write-Host $LogEntry
}