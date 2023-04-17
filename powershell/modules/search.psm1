using namespace System.Web

$Urls = @{
    'Amazon.com'             = 'https://www.amazon.com/s?k='
    'Amazon.es'              = 'https://www.amazon.es/s?k='
    'Bing'                   = 'https://www.bing.com/search?q='
    'DBA Stack Exchange'     = 'https://dba.stackexchange.com/search?q='
    'DevOps Stack Exchange'  = 'https://devops.stackexchange.com/search?q='
    'DuckDuckGo'             = 'https://duckduckgo.com/?q='
    'Google Images'          = 'https://www.google.com/search?tbm=isch&q='
    'Google Maps'            = 'https://www.google.com/maps?q='
    'Google News'            = 'https://www.google.com/search?tbm=nws&q='
    'Google Shopping'        = 'https://www.google.com/search?tbm=shop&q='
    'Google: Stack Overflow' = 'https://www.google.com/search?q=site%3Astackoverflow.com+'
    'Google: Super User'     = 'https://www.google.com/search?q=site%3Asuperuser.com+'
    'Google'                 = 'https://www.google.com/search?q='
    'Reddit'                 = 'https://www.reddit.com/search/?q='
    'Stack Overflow'         = 'https://stackoverflow.com/search?q='
    'Super User'             = 'https://superuser.com/search?q='
    'wallhaven.cc'           = 'https://wallhaven.cc/search?q='
    'Wikipedia'              = 'https://www.wikipedia.org/search-redirect.php?search='
    'YouTube'                = 'https://www.youtube.com/results?search_query='
}

function Get-SearchTargets($Pattern) {
    $Urls.GetEnumerator().Name | Where-Object { $_ -like "*$Pattern*" }
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

    $Url = $Urls.$Target + [HttpUtility]::UrlEncode("$Keywords")
    run start $Url
}

function gso { Invoke-Search -Target 'Google: Stack Overflow' @args }
function gsu { Invoke-Search -Target 'Google: Super User' @args }
function so { Invoke-Search -Target 'Stack Overflow' @args }
function yt { Invoke-Search -Target 'YouTube' @args }

Set-Alias -Name '??' -Value 'Invoke-Search'
