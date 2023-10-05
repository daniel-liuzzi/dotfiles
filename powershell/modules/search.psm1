using namespace System.Web

$Global:DotfilesOptions.Search += @{
    'Amazon.com'             = 'https://www.amazon.com/s?k='
    'Amazon.es'              = 'https://www.amazon.es/s?k='
    'ARIN'                   = 'https://search.arin.net/rdap/?query='
    'Bing'                   = 'https://www.bing.com/search?q='
    'DBA Stack Exchange'     = 'https://www.google.com/search?q=site%3Adba.stackexchange.com+'
    'DevOps Stack Exchange'  = 'https://www.google.com/search?q=site%3Adevops.stackexchange.com+'
    'DuckDuckGo'             = 'https://duckduckgo.com/?q='
    'Google Images'          = 'https://www.google.com/search?tbm=isch&q='
    'Google Maps'            = 'https://www.google.com/maps?q='
    'Google News'            = 'https://www.google.com/search?tbm=nws&q='
    'Google Shopping'        = 'https://www.google.com/search?tbm=shop&q='
    'Google'                 = 'https://www.google.com/search?q='
    'Reddit'                 = 'https://www.reddit.com/search/?q='
    'Server Fault'           = 'https://www.google.com/search?q=site%3Aserverfault.com+'
    'Stack Overflow'         = 'https://www.google.com/search?q=site%3Astackoverflow.com+'
    'Super User'             = 'https://www.google.com/search?q=site%3Asuperuser.com+'
    'wallhaven.cc'           = 'https://wallhaven.cc/search?q='
    'Wikipedia'              = 'https://www.wikipedia.org/search-redirect.php?search='
    'YouTube'                = 'https://www.youtube.com/results?search_query='
}

function Get-SearchTargets($Pattern) {
    $Global:DotfilesOptions.Search.GetEnumerator().Name | Where-Object { $_ -like "*$Pattern*" }
}

function Invoke-Search {
    param(
        [Parameter(Position = 0, ValueFromRemainingArguments = $true)]
        [string[]]
        $Keywords,

        [ArgumentCompleter({
                param($Command, $Parameter, $WordToComplete, $CommandAst, $FakeBoundParams)
                Get-SearchTargets $WordToComplete | ForEach-Object { "'$_'" }
            })]
        [ValidateScript({
                $_ -in (Get-SearchTargets)
            })]
        [string]
        $Target = 'Google'
    )

    $Url = $Global:DotfilesOptions.Search.$Target + [HttpUtility]::UrlEncode("$Keywords")
    run start $Url
}

function arin { Invoke-Search -Target 'ARIN' @args }
function sf { Invoke-Search -Target 'Server Fault' @args }
function so { Invoke-Search -Target 'Stack Overflow' @args }
function su { Invoke-Search -Target 'Super User' @args }
function yt { Invoke-Search -Target 'YouTube' @args }

Set-Alias -Name '??' -Value 'Invoke-Search'
