using namespace System.IO

Import-Module PsIni

function Get-FirefoxProfiles {
    $FirefoxPath = [Path]::Combine($env:APPDATA, 'Mozilla/Firefox')
    $ProfilesIniPath = [Path]::Combine($FirefoxPath, 'profiles.ini')
    $ProfilesIniContent = Get-IniContent $ProfilesIniPath

    $ProfilesIniContent.Keys |
    Where-Object { $_.StartsWith('Profile') } |
    ForEach-Object { [Path]::Combine($FirefoxPath, $ProfilesIniContent.$_.Path) }
}
