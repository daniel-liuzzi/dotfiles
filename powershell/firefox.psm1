using namespace System.IO

Import-Module PsIni

function Get-FirefoxProfiles {
    $FirefoxPath = [Path]::Combine($env:APPDATA, 'Mozilla', 'Firefox')
    $ProfilesIniPath = [Path]::Combine($FirefoxPath, 'profiles.ini')
    if (![Path]::Exists($ProfilesIniPath)) { return }
    $ProfilesIniContent = Get-IniContent $ProfilesIniPath

    $ProfilesIniContent.Keys |
    where { $_.StartsWith('Profile') } |
    foreach { [Path]::Combine($FirefoxPath, $ProfilesIniContent.$_.Path) }
}
