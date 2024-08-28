# scoop install kanata-cmd

Register-ScheduledTask `
    -TaskName 'Kanata' `
    -Trigger (New-ScheduledTaskTrigger `
        -AtLogOn `
        -User $env:USERNAME) `
    -Action (New-ScheduledTaskAction `
        -Execute 'conhost' `
        -Argument '--headless kanata-cmd' `
        -WorkingDirectory $PSScriptRoot) `
    -Settings (New-ScheduledTaskSettingsSet `
        -DontStopOnIdleEnd `
        -AllowStartIfOnBatteries `
        -DontStopIfGoingOnBatteries `
        -ExecutionTimeLimit 0) `
    -RunLevel Highest `
    -Force

# conhost trick credit: https://github.com/jtroo/kanata/discussions/193#discussioncomment-5276656
