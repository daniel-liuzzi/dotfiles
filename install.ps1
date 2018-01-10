function New-Link ($target, $source) {
  if (Test-Path $source) {
    Move-Item -Path $source -Destination "$source.bak" -Force
  }

  New-Item -ItemType SymbolicLink -Path $source -Target $target
}

New-Link ".\.gitconfig" "~\.gitconfig"
New-Link ".\.hyper.js" "~\.hyper.js"
New-Link ".\AutoHotkey.ahk" "~\Documents\AutoHotkey.ahk"
New-Link ".\Microsoft.PowerShell_profile.ps1" $PROFILE.CurrentUserCurrentHost
New-Link ".\path\" "~\path\"
New-Link ".\Preferences.sublime-settings" "$env:APPDATA\Sublime Text 3\Packages\User\Preferences.sublime-settings"
New-Link ".\vscode.json" "$env:APPDATA\Code\User\settings.json"
