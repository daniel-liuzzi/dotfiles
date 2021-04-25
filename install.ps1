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

function New-Link ($target, $source) {
  if (Test-Path $source) {
    if ((Get-Item $source).LinkType -eq 'SymbolicLink') {
      Remove-Item $source
    }
    else {
      Move-Item -Path $source -Destination "$source.bak" -Force
    }
  }

  New-Item -ItemType SymbolicLink -Path $source -Target (Resolve-Path $target)
}

# TODO: create *.custom.* files (from *.custom.sample.*) if they don't already exist

Write-Output '- Installing Powershell modules...'
Install-Module -Name cd-extras -RequiredVersion 2.9.0 -Force
Install-Module -Name DockerCompletion -RequiredVersion 1.2010.0.201211 -Force
Install-Module -Name DockerComposeCompletion -RequiredVersion 1.29.0.210407 -Force
Install-Module -Name oh-my-posh -RequiredVersion 3.139.1 -Force
Install-Module -Name posh-git -RequiredVersion 1.0.0 -Force
Install-Module -Name PSColor -RequiredVersion 1.0.0.0 -Force
Install-Module -Name PSReadLine -RequiredVersion 2.2.0-beta2 -AllowPrerelease -Force
Install-Module -Name Recycle -RequiredVersion 1.1.1 -Force
Install-Module -Name z -RequiredVersion 1.1.9 -Force

Write-Output '- Creating symlinks...'
New-Link "./.omnisharp" "~/.omnisharp"
New-Link "./ahk/AutoHotkeyU64.ahk" "~/Documents/AutoHotkeyU64.ahk"
New-Link "./ahk/AutoHotkeyU64.custom.ahk" "~/Documents/AutoHotkeyU64.custom.ahk"
New-Link "./git/.gitconfig" "~/.gitconfig"
New-Link "./git/.gitconfig.custom" "~/.gitconfig.custom"
New-Link "./jrnl" "~/.config/jrnl"
New-Link "./powershell/profile.ps1" $PROFILE.CurrentUserCurrentHost
New-Link "./terminal/settings.json" "$env:LOCALAPPDATA/Packages/Microsoft.WindowsTerminal_8wekyb3d8bbwe/LocalState/settings.json"
New-Link "./terminal/settings.json" "$env:LOCALAPPDATA/Packages/Microsoft.WindowsTerminalPreview_8wekyb3d8bbwe/LocalState/settings.json"
New-Link "./vscode/settings.json" "$env:APPDATA/Code/User/settings.json"
New-Link "./vscode/keybindings.json" "$env:APPDATA/Code/User/keybindings.json"
New-Link "./vscode/settings.json" "$env:APPDATA/Code - Insiders/User/settings.json"
New-Link "./vscode/keybindings.json" "$env:APPDATA/Code - Insiders/User/keybindings.json"

Write-Output '- Done.'
Write-Output ''
Write-Output 'Close PowerShell and reopen it for changes to take effect.'
Write-Output ''

pause
