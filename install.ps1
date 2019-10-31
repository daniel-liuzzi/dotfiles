function New-Link ($target, $source) {
  if (Test-Path $source) {
    Move-Item -Path $source -Destination "$source.bak" -Force
  }

  New-Item -ItemType SymbolicLink -Path $source -Target $target
}

# TODO: create *.custom.* files (from *.custom.sample.*) if they don't already exist

New-Link ".\.gitconfig" "~\.gitconfig"
New-Link ".\.gitconfig.custom" "~\.gitconfig.custom"
New-Link ".\.hyper.js" "$env:APPDATA\Hyper\.hyper.js"
New-Link ".\AutoHotkeyU64.ahk" "~\Documents\AutoHotkeyU64.ahk"
New-Link ".\AutoHotkeyU64.custom.ahk" "~\Documents\AutoHotkeyU64.custom.ahk"
New-Link ".\Microsoft.PowerShell_profile.ps1" $PROFILE.CurrentUserCurrentHost
New-Link ".\Microsoft.PowerShell_profile.custom.ps1" ($PROFILE.CurrentUserCurrentHost -replace '.ps1', '.custom.ps1')
New-Link ".\bin\" "~\bin\"
New-Link ".\Preferences.sublime-settings" "~\scoop\persist\sublime-text\Data\Packages\User\Preferences.sublime-settings"
New-Link ".\profiles.json" "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\profiles.json"
New-Link ".\vscode.json" "$env:APPDATA\Code\User\settings.json"
