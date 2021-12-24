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
Install-Module -Name PowerShellGet -RequiredVersion 2.2.5 -Force
# Install-Module -Name cd-extras -RequiredVersion 2.9.4 -Force
# Install-Module -Name DockerCompletion -RequiredVersion 1.2010.1.211002 -Force
# Install-Module -Name DockerComposeCompletion -RequiredVersion 1.29.0.210407 -Force
Install-Module -Name oh-my-posh -RequiredVersion 6.27.1 -Force
Install-Module -Name PsIni -RequiredVersion 3.1.2 -Force
Install-Module -Name PSReadLine -RequiredVersion 2.2.0-beta4 -AllowPrerelease -Force
Install-Module -Name Recycle -RequiredVersion 1.3.1 -Force
# Install-Module -Name Terminal-Icons -RequiredVersion 0.5.2 -Force
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
        Target = './ahk/AutoHotkeyU64.ahk'
        Source = '~/Documents/AutoHotkeyU64.ahk'
    }
    @{
        Target = './ahk/AutoHotkeyU64.custom.ahk'
        Source = '~/Documents/AutoHotkeyU64.custom.ahk'
    }
    @{
        Target = './azuredatastudio/settings.json'
        Source = "$env:APPDATA/azuredatastudio/User/settings.json"
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
        Target = './git/.gitconfig'
        Source = '~/.gitconfig'
    }
    @{
        Target = './git/.gitconfig.custom'
        Source = '~/.gitconfig.custom'
    }
    @{
        Target = './jrnl'
        Source = '~/.config/jrnl'
    }
    @{
        Target = './powershell/profile.ps1'
        Source = $PROFILE.CurrentUserCurrentHost
    }
    @{
        Target = './terminal/settings.json'
        Source = @(
            "$env:LOCALAPPDATA/Packages/Microsoft.WindowsTerminal_8wekyb3d8bbwe/LocalState/settings.json"
            "$env:LOCALAPPDATA/Packages/Microsoft.WindowsTerminalPreview_8wekyb3d8bbwe/LocalState/settings.json"
        )
    }
    @{
        Target = './vscode/keybindings.json'
        Source = @(
            "$env:APPDATA/Code/User/keybindings.json"
            "$env:APPDATA/Code - Insiders/User/keybindings.json"
        )
    }
    @{
        Target = './vscode/settings.json'
        Source = @(
            "$env:APPDATA/Code/User/settings.json"
            "$env:APPDATA/Code - Insiders/User/settings.json"
        )
    }
    @{
        Target = './vscode/tasks.json'
        Source = @(
            "$env:APPDATA/Code/User/tasks.json"
            "$env:APPDATA/Code - Insiders/User/tasks.json"
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

pause
