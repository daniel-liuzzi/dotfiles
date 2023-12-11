using namespace System.Web

# PS 5.1 needs this - https://stackoverflow.com/a/38409183/88709
Add-Type -AssemblyName System.Web

function Get-UrlEncoded ($s) { [HTTPUtility]::UrlEncode($s).Replace('+', '%20') }

if ($global:SqlOptions.Databases) {
    foreach ($db in $global:SqlOptions.Databases.GetEnumerator()) {
        $key = $global:SqlOptions.Prefix + $db.Key
        $value = @(
            (Get-UrlEncoded $db.Value.Server.Driver); '://'
            (Get-UrlEncoded $db.Value.Server.User); ':'
            (Get-UrlEncoded $db.Value.Server.Pass); '@'
            (Get-UrlEncoded $db.Value.Server.Host); '/'
            (Get-UrlEncoded $db.Value.Name)
        ) -join $null

        Set-Content env:$key $value
    }
}

# scoop install usql
Set-Alias -Name 'sql' -Value 'usql'
