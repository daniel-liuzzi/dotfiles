Import-Module "$PSScriptRoot/../powershell/base" -Force

New-Link `
    -Type SymbolicLink `
    -Target "$PSScriptRoot/KeePass.config.enforced.xml" `
    -Source '~/scoop/apps/keepass/current/KeePass.config.enforced.xml' |
Out-Null
