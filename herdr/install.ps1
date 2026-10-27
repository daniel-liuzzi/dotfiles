$ConfigDirectory = "$env:APPDATA/herdr"

New-Item `
    -ItemType Directory `
    -Path $ConfigDirectory `
    -Force |
Out-Null

New-Item `
    -ItemType SymbolicLink `
    -Path "$ConfigDirectory/config.toml" `
    -Value "$PSScriptRoot/config.toml" `
    -Force |
Out-Null
