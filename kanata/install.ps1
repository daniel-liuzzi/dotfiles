# winget install --id jtroo.kanata_gui --exact

Register-ScheduledTask `
    -TaskName 'Kanata' `
    -Trigger (New-ScheduledTaskTrigger `
        -AtLogOn `
        -User $env:USERNAME) `
    -Action (New-ScheduledTaskAction `
        -Execute '%LOCALAPPDATA%\Microsoft\WinGet\Links\kanata_windows_gui_winIOv2_x64.exe' `
        -WorkingDirectory $PSScriptRoot) `
    -Settings (New-ScheduledTaskSettingsSet `
        -DontStopOnIdleEnd `
        -AllowStartIfOnBatteries `
        -DontStopIfGoingOnBatteries `
        -ExecutionTimeLimit 0) `
    -RunLevel Highest `
    -Force
