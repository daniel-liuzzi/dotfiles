using namespace System.IO

Import-Module PsIni -Force
Import-Module "$PSScriptRoot/../powershell/base" -Force

function Get-FirefoxProfiles {
    $FirefoxPath = [Path]::Combine($env:APPDATA, 'Mozilla', 'Firefox')
    $ProfilesIniPath = [Path]::Combine($FirefoxPath, 'profiles.ini')
    if (![Path]::Exists($ProfilesIniPath)) { return }
    $ProfilesIniContent = Get-IniContent $ProfilesIniPath

    $ProfilesIniContent.Keys |
    where { $_.StartsWith('Profile') } |
    foreach { [Path]::Combine($FirefoxPath, $ProfilesIniContent.$_.Path) }
}

$FirefoxProfiles = Get-FirefoxProfiles
$Files = @(
    'chrome/'
    'user.js'
)

foreach ($FirefoxProfile in $FirefoxProfiles) {
    foreach ($File in $Files) {
        New-Link `
            -Type SymbolicLink `
            -Target (Join-Path $PSScriptRoot $File) `
            -Source (Join-Path $FirefoxProfile $File) |
        Out-Null
    }
}
