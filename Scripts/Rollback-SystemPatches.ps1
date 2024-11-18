<#
.SYNOPSIS
Windows Update Rollback Mechanism
.DESCRIPTION
Provides capability to rollback recent system updates
#>

param(
    [int]$DaysToRollback = 7,
    [switch]$RollbackAll = $false
)

# Import Logging function
. "$PSScriptRoot\Write-Log.ps1"


$connectionString = "Server=(localdb)\MSSQLLocalDB;Integrated Security=true;"

# Rollback Functionality
function Get-RollbackUpdates {
    param($DaysThreshold)
    
    try {
        $Updates = Get-WindowsUpdate -InstalledUpdates | 
            Where-Object { $_.Date -gt (Get-Date).AddDays(-$DaysThreshold) }
        
        Write-Log "Found $($Updates.Count) updates eligible for rollback" -LogType "Rollback"
        return $Updates
    }
    catch {
        Write-Log "Failed to retrieve installed updates: $_" -LogType "Rollback" -Level "ERROR"
        return $null
    }
}

# Rollback Updates
function Uninstall-WindowsUpdates {
    param($UpdatesToRollback)
    
    if (!$UpdatesToRollback) {
        Write-Log "No updates available for rollback" -LogType "Rollback" -Level "WARN"
        return
    }

    try {
        foreach ($Update in $UpdatesToRollback) {
            Write-Log "Attempting to uninstall: $($Update.Title)" -LogType "Rollback"
            $Update | Remove-WindowsUpdate -Confirm:$false
             # Log rollback action to SQL
             $query = @"
             INSERT INTO RollbackLogs (UpdateId, RollbackDate, Status)
             SELECT Id, GETDATE(), 'Rolled Back'
             FROM Updates
             WHERE Title = '$($Update.Title)';
"@
            Invoke-Sqlcmd -Query $query -ConnectionString $connectionString
            Write-Log "Successfully rolled back: $($Update.Title)" -LogType "Rollback" -Level "SUCCESS"
        }
    }
    catch {
        Write-Log "Rollback failed: $_" -LogType "Rollback" -Level "ERROR"
    }
}

# Main Rollback Execution
function Invoke-PatchRollback {
    Write-Log "Initiating Patch Rollback Process" -LogType "Rollback"
    
    $RollbackCandidates = if ($RollbackAll) {
        Get-RollbackUpdates -DaysThreshold 30
    }
    else {
        Get-RollbackUpdates -DaysThreshold $DaysToRollback
    }

    Uninstall-WindowsUpdates -UpdatesToRollback $RollbackCandidates
    
    Write-Log "Patch Rollback Process Completed" -LogType "Rollback"
}

# Execute Rollback
Invoke-PatchRollback
