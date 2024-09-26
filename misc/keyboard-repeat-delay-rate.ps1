$LogonTrigger = New-ScheduledTaskTrigger -AtLogOn

$TaskEventTriggerClass = Get-CimClass -Namespace 'Root/Microsoft/Windows/TaskScheduler' -ClassName 'MSFT_TaskEventTrigger'
$WakeUpTrigger = New-CimInstance -CimClass $TaskEventTriggerClass -ClientOnly
$WakeUpTrigger.Subscription =
@"
<QueryList><Query Id="0" Path="System"><Select Path="System">*[System[Provider[@Name='Microsoft-Windows-Kernel-Power'] and EventID=507]]</Select></Query></QueryList>
"@

$Action = New-ScheduledTaskAction -Execute 'conhost' -Argument '--headless cmd /c mode con: rate=32 delay=0'

$Settings = New-ScheduledTaskSettingsSet `
    -AllowStartIfOnBatteries `
    -DontStopIfGoingOnBatteries `
    -DontStopOnIdleEnd `
    -ExecutionTimeLimit 0

Register-ScheduledTask `
    -TaskName 'Set keyboard rate & delay' `
    -Trigger $LogonTrigger, $WakeUpTrigger `
    -Action $Action `
    -Settings $Settings `
    -Force

# credits:
# - https://superuser.com/a/1829244/18964
# - https://stackoverflow.com/a/62311097/88709
