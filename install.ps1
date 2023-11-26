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

# Enable Developer Mode
# https://stackoverflow.com/a/40033638/88709
$RegistryKeyPath = 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\AppModelUnlock'
if (-not (Test-Path -Path $RegistryKeyPath)) {
    New-Item `
        -Path $RegistryKeyPath `
        -ItemType Directory `
        -Force
}

New-ItemProperty `
    -Path $RegistryKeyPath `
    -Name 'AllowDevelopmentWithoutDevLicense' `
    -PropertyType DWORD `
    -Value 1 `
    -Force

# Enable long paths (Windows 10 version 1607 and Later)
# https://docs.microsoft.com/en-us/windows/win32/fileio/maximum-file-path-limitation?tabs=powershell#enable-long-paths-in-windows-10-version-1607-and-later
New-ItemProperty `
    -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\FileSystem' `
    -Name 'LongPathsEnabled' `
    -PropertyType DWORD `
    -Value 1 `
    -Force

Write-Output '- Installing package providers...'
@(
    @{ Name = 'NuGet'; MinimumVersion = '2.8.5.201' }
) | where {
    $Provider = Get-PackageProvider $_.Name -ErrorAction SilentlyContinue
    if (!$Provider) { return $true }
    if ($Provider.Version -lt $_.MinimumVersion) { return $true }
    return $false
} | foreach {
    "  $($_.Name)"
    Install-PackageProvider @_ -Scope CurrentUser -Force
}

Write-Output '- Installing Powershell modules...'
@(
    @{ Name = 'PowerShellGet'; RequiredVersion = '2.2.5' }
    @{ Name = 'Az.Accounts'; RequiredVersion = '2.9.1' }
    @{ Name = 'Az.Resources'; RequiredVersion = '6.1.0' }
    @{ Name = 'Az.Tools.Predictor'; RequiredVersion = '1.0.1' }
    @{ Name = 'PsIni'; RequiredVersion = '3.1.2' }
    @{ Name = 'PSReadLine'; RequiredVersion = '2.2.6' }
    @{ Name = 'Recycle'; RequiredVersion = '1.3.1' }
    @{ Name = 'Terminal-Icons'; RequiredVersion = '0.11.0' }
    @{ Name = 'z'; RequiredVersion = '1.1.13' }
) | where {
    !(Get-InstalledModule @_ -ErrorAction SilentlyContinue)
} | foreach {
    "  $($_.Name)"
    Install-Module @_ -Scope CurrentUser -AllowClobber -Force
}

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
        Target = './espanso'
        Source = '~/scoop/persist/espanso/.espanso'
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
            "~/scoop/apps/windows-terminal/current/settings/settings.json"
            "~/scoop/apps/windows-terminal-preview/current/settings/settings.json"
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
    @{
        Target = './wsl/.wslconfig'
        Source = '~/.wslconfig'
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
