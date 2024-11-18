$TaskName = "WindowsPatchManagement"
$ScriptPath = "C:\Users\dhanr\OneDrive\Documents\windows-patch\Scripts\Update-SystemPatches.ps1"
$ScheduleTime = (Get-Date).AddDays(1).Date.AddHours(2)  # Example: Tomorrow at 2:00 AM

# Task action
$Action = New-ScheduledTaskAction -Execute "PowerShell.exe" -Argument "-File $ScriptPath"

# Task trigger
$Trigger = New-ScheduledTaskTrigger -Once -At $ScheduleTime

# Register task
Register-ScheduledTask -TaskName $TaskName -Action $Action -Trigger $Trigger -Description "Scheduled update management task"

Write-Host "Task $TaskName scheduled to run at $ScheduleTime."
