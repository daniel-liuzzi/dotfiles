Import-Module $ProfileDir/modules/base

<#
  .SYNOPSIS
  Get journal entries for the previuos, current, and next day
#>
function Get-Journal {
    function Display ($Range) {
        $Entry = Invoke-Expression "jrnl $Range --format dates" | Select-Object -First 1
        if ($Entry -notmatch '^\d{4}-\d{2}-\d{2}') { return }
        Write-Host "`n$(Format-RelativeDate $matches.0)`n" -ForegroundColor Blue
        quietly j -on ('{0:yyyy-MM-dd}' -f $matches.0) $JournalArgs
    }

    $JournalArgs = $args
    Display ('-to {0:yyyy-MM-dd} -n 1' -f [datetime]::Today.AddDays(-1))
    Display ('-on {0:yyyy-MM-dd} -n 1' -f [datetime]::Today)
    Display ('-from {0:yyyy-MM-dd}' -f [datetime]::Today.AddDays(1))
}

function j { run jrnl @args }
function jw { j -from monday -to today --format short @args }

Set-Alias -Name 'daily' -Value 'Get-Journal'
