Import-Module PsIni

function Get-FirefoxProfiles {
    $FirefoxPath = Join-Path $env:APPDATA 'Mozilla/Firefox'
    $ProfilesIniPath = Join-Path $FirefoxPath 'profiles.ini'
    $ProfilesIniContent = Get-IniContent $ProfilesIniPath

    $ProfilesIniContent.Keys |
    Where-Object { $_.StartsWith('Profile') } |
    ForEach-Object { Join-Path $FirefoxPath $ProfilesIniContent.$_.Path }
}
