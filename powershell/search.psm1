using namespace System.Web

$Global:DotfilesOptions.Search += @{
    'Amazon.com'                    = 'https://www.amazon.com/s?k='
    'Amazon.es'                     = 'https://www.amazon.es/s?k='
    'ARIN'                          = 'https://search.arin.net/rdap/?query='
    'Ask Ubuntu'                    = 'https://www.google.com/search?q=site%3Aaskubuntu.com+'
    'Bing'                          = 'https://www.bing.com/search?q='
    'Copilot'                       = 'https://copilot.microsoft.com/?q='
    'DBA Stack Exchange'            = 'https://www.google.com/search?q=site%3Adba.stackexchange.com+'
    'DevOps Stack Exchange'         = 'https://www.google.com/search?q=site%3Adevops.stackexchange.com+'
    'DuckDuckGo'                    = 'https://duckduckgo.com/?q='
    'English Stack Exchange'        = 'https://www.google.com/search?q=site%3Aenglish.stackexchange.com+'
    'Google Images'                 = 'https://www.google.com/search?tbm=isch&q='
    'Google Maps'                   = 'https://www.google.com/maps?q='
    'Google News'                   = 'https://www.google.com/search?tbm=nws&q='
    'Google Shopping'               = 'https://www.google.com/search?tbm=shop&q='
    'Google.es'                     = 'https://www.google.es/search?q='
    'Google'                        = 'https://www.google.com/search?q='
    'MDN Web Docs'                  = 'https://www.google.com/search?q=site%3Adeveloper.mozilla.org+'
    'NuGet'                         = 'https://www.google.com/search?q=site%3Anuget.org+'
    'Perplexity'                    = 'https://www.perplexity.ai/search?q='
    'Reddit'                        = 'https://www.google.com/search?q=site%3Areddit.com+'
    'Server Fault'                  = 'https://www.google.com/search?q=site%3Aserverfault.com+'
    'Spanish Stack Exchange'        = 'https://www.google.com/search?q=site%3Aspanish.stackexchange.com+'
    'Stack Overflow'                = 'https://www.google.com/search?q=site%3Astackoverflow.com+'
    'Super User'                    = 'https://www.google.com/search?q=site%3Asuperuser.com+'
    'Unix & Linux Stack Exchange'   = 'https://www.google.com/search?q=site%3Aunix.stackexchange.com+'
    'wallhaven.cc'                  = 'https://wallhaven.cc/search?q='
    'Wikipedia'                     = 'https://www.wikipedia.org/search-redirect.php?search='
    'YouTube'                       = 'https://www.youtube.com/results?search_query='
}

$Global:DotfilesOptions.SearchDefault = 'Google'

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
        $Target
    )

    function Get-QuotedKeywords ($keywords) {
        $keywords | ForEach-Object {
            if ($_ -isnot [string]) { return $_ }
            if ($_ -notmatch ' ') { return $_ }
            return "`"$($_.Replace('"', '""'))`""
        }
    }

    if ($Keywords -or $Target) {
        if (!$Target) { $Target = $Global:DotfilesOptions.SearchDefault }
        $QuotedKeywords = Get-QuotedKeywords $Keywords
        $UrlPrefix = $Global:DotfilesOptions.Search.$Target
        $UrlSuffix = [HttpUtility]::UrlEncode($QuotedKeywords)
        $Url = $UrlPrefix + $UrlSuffix
    } else {
        $Url = 'https://'
    }

    run start $Url
}

function arin { Invoke-Search -Target 'ARIN' @args }
function cop { Invoke-Search -Target 'Copilot' @args }
function eng { Invoke-Search -Target 'English Stack Exchange' @args }
function mdn { Invoke-Search -Target 'MDN Web Docs' @args }
function ppl { Invoke-Search -Target 'Perplexity' @args }
function sf { Invoke-Search -Target 'Server Fault' @args }
function so { Invoke-Search -Target 'Stack Overflow' @args }
function spa { Invoke-Search -Target 'Spanish Stack Exchange' @args }
function su { Invoke-Search -Target 'Super User' @args }
function yt { Invoke-Search -Target 'YouTube' @args }

Set-Alias -Name '??' -Value 'Invoke-Search'
