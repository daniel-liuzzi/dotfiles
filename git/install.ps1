Import-Module "$PSScriptRoot/../powershell/base" -Force

New-Link `
    -Type SymbolicLink `
    -Target $PSScriptRoot `
    -Source '~/.config/git' |
Out-Null
