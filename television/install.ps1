Import-Module "$PSScriptRoot/../powershell/base" -Force

New-Link `
    -Type SymbolicLink `
    -Target $PSScriptRoot `
    -Source "$env:LOCALAPPDATA/television" |
Out-Null
