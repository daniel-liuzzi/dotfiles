$ConfigDirectory = "$HOME/.config/wezterm"

New-Item `
    -ItemType Directory `
    -Path $ConfigDirectory `
    -Force |
Out-Null

New-Item `
    -ItemType SymbolicLink `
    -Path "$ConfigDirectory/wezterm.lua" `
    -Value "$PSScriptRoot/wezterm.lua" `
    -Force |
Out-Null
