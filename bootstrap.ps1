function New-Link ($source, $target) {
  if (Test-Path $source) {
    Move-Item -Path $source -Destination "$source.bak" -Force
  }

  New-Item -ItemType SymbolicLink -Path $source -Target $target
}

New-Link ~\.gitconfig .\.gitconfig
New-Link ~\.hyper.js .\.hyper.js
New-Link ~\Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1 .\Microsoft.PowerShell_profile.ps1
