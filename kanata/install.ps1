# winget install --id jtroo.kanata_gui --exact --version 1.11.0
# winget pin add --id jtroo.kanata_gui --exact --version 1.11.0
#
# Pinned below 1.12.0, which made keystate sync ignore windows-sync-keystates
# no and desync real keys. Fix is on main (windows-sync-keystates none,
# commit def6432c79) but unreleased as of 2026-09-16 -- unpin once it ships.

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
