Import-Module $ProfileDir/modules/base

<#
  .SYNOPSIS
  Get journal entries for the previuos, current, and next day
#>
function Get-DailyJournal {
    function Display ($Range) {
        $Entry = Invoke-Expression "jrnl $Range --format dates" 2> $null | Select-Object -First 1
        if ($null -eq $Entry -or $Entry -notmatch '^\d{4}-\d{2}-\d{2}') { return }
        Write-Host "`n$(Format-RelativeDate $matches.0)`n" -ForegroundColor Blue
        quietly j -on ('{0:yyyy-MM-dd}' -f $matches.0) $JournalArgs 2> $null
    }

    $JournalArgs = $args
    Display ('-to {0:yyyy-MM-dd} -n 1' -f [datetime]::Today.AddDays(-1))
    Display ('-on {0:yyyy-MM-dd} -n 1' -f [datetime]::Today)
    Display ('-from {0:yyyy-MM-dd}' -f [datetime]::Today.AddDays(1))
}

function Get-WeeklyJournal { j -from monday -to today --format short @args 2> $null }

function j { run jrnl @args }

Set-Alias -Name 'jd' -Value 'Get-DailyJournal'
Set-Alias -Name 'jw' -Value 'Get-WeeklyJournal'
