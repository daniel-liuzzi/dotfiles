using namespace System.Security.Principal

# Self-elevate
if (!([WindowsPrincipal] [WindowsIdentity]::GetCurrent()).IsInRole([WindowsBuiltInRole]::Administrator)) {
    Start-Process `
        -FilePath (Get-Process -Id $PID).Path `
        -ArgumentList @('-NoProfile', '-File', "`"$PSCommandPath`"") `
        -Verb RunAs `
        -Wait
    return
}

Write-Output '- Installing Powershell modules...'
Install-Module -Name Az.Accounts -RequiredVersion 2.9.1 -Force
Install-Module -Name Az.Resources -RequiredVersion 6.1.0 -Force
Install-Module -Name Az.Tools.Predictor -RequiredVersion 1.0.1 -Force
Install-Module -Name PowerShellGet -RequiredVersion 2.2.5 -Force
Install-Module -Name PsIni -RequiredVersion 3.1.2 -Force
Install-Module -Name PSReadLine -RequiredVersion 2.2.6 -Force
Install-Module -Name Recycle -RequiredVersion 1.3.1 -Force
Install-Module -Name Terminal-Icons -RequiredVersion 0.5.2 -Force
Install-Module -Name z -RequiredVersion 1.1.13 -Force -AllowClobber

Import-Module $PSScriptRoot/powershell/modules/base -Force
Import-Module $PSScriptRoot/powershell/modules/firefox -Force

# TODO: create *.custom.* files (from *.custom.sample.*) if they don't already exist

Write-Output '- Creating symlinks...'
$FirefoxProfiles = Get-FirefoxProfiles
@(
    @{
        Target = './.omnisharp'
        Source = '~/.omnisharp'
    }
    @{
        Target = './azuredatastudio/settings.json'
        Source = "$env:APPDATA/azuredatastudio/User/settings.json"
    }
    @{
        Target = './config'
        Source = '~/.config'
    }
    @{
        Target = './firefox/chrome'
        Source = $FirefoxProfiles | ForEach-Object { Join-Path $_ 'chrome' }
    }
    @{
        Target = './firefox/user.js'
        Source = $FirefoxProfiles | ForEach-Object { Join-Path $_ 'user.js' }
    }
    @{
        Target = './powershell/profile.ps1'
        Source = $PROFILE.CurrentUserCurrentHost
    }
    @{
        Target = './terminal/settings.json'
        Source = @(
            "$env:LOCALAPPDATA/Microsoft/Windows Terminal/settings.json"
            "$env:LOCALAPPDATA/Packages/Microsoft.WindowsTerminal_8wekyb3d8bbwe/LocalState/settings.json"
            "$env:LOCALAPPDATA/Packages/Microsoft.WindowsTerminalPreview_8wekyb3d8bbwe/LocalState/settings.json"
        )
    }
    @{
        Target = './vscode/keybindings.json'
        Source = @(
            "~/scoop/persist/vscode/data/user-data/User/keybindings.json"
            "~/scoop/persist/vscode-insiders/data/user-data/User/keybindings.json"
        )
    }
    @{
        Target = './vscode/settings.json'
        Source = @(
            "~/scoop/persist/vscode/data/user-data/User/settings.json"
            "~/scoop/persist/vscode-insiders/data/user-data/User/settings.json"
        )
    }
    @{
        Target = './vscode/tasks.json'
        Source = @(
            "~/scoop/persist/vscode/data/user-data/User/tasks.json"
            "~/scoop/persist/vscode-insiders/data/user-data/User/tasks.json"
        )
    }
) | ForEach-Object {
    New-Link `
        -Type SymbolicLink `
        -Target "$PSScriptRoot/$($_.Target)" `
        -Source $_.Source |
    Out-Null
}

# Create AutoHotkey scheduled task
Write-Output '- Creating scheduled tasks...'
& './ahk/install' | Out-Null

Write-Output '- Done.'
Write-Output ''
Write-Output 'Close PowerShell and reopen it for changes to take effect.'
Write-Output ''

# Enable long paths (Windows 10 version 1607 and Later)
# https://docs.microsoft.com/en-us/windows/win32/fileio/maximum-file-path-limitation?tabs=powershell#enable-long-paths-in-windows-10-version-1607-and-later
New-ItemProperty `
    -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\FileSystem' `
    -Name 'LongPathsEnabled' `
    -Value 1 `
    -PropertyType DWORD `
    -Force

pause
