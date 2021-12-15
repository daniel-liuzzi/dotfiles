Import-Module $ProfileDir/modules/base

<#
  .SYNOPSIS
  Get journal entries for the previuos, current, and next day
#>
function Get-DailyJournal {
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

function Get-WeeklyJournal { j -from monday -to today --format short @args }

# jrnl v2.8.1 doesn't work with Python 3.10
function Repair-Journal { scoop reset python@3.9.7 }

function j { run jrnl @args }

Set-Alias -Name 'jd' -Value 'Get-DailyJournal'
Set-Alias -Name 'jw' -Value 'Get-WeeklyJournal'
