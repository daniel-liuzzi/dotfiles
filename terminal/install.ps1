Import-Module "$PSScriptRoot/../powershell/base" -Force

New-Link `
-Type SymbolicLink `
-Target "$PSScriptRoot/fragments/" `
-Source "$env:LOCALAPPDATA/Microsoft/Windows Terminal/Fragments/" |
Out-Null

New-Link `
-Type SymbolicLink `
-Target "$PSScriptRoot/settings.json" `
-Source @(
    "~/scoop/apps/windows-terminal/current/settings/settings.json"
    "~/scoop/apps/windows-terminal-preview/current/settings/settings.json"
    "$env:LOCALAPPDATA/Packages/Microsoft.WindowsTerminal_8wekyb3d8bbwe/LocalState/settings.json"
    "$env:LOCALAPPDATA/Packages/Microsoft.WindowsTerminalPreview_8wekyb3d8bbwe/LocalState/settings.json"
) |
Out-Null
