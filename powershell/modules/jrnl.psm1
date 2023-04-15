Import-Module $ProfileDir/modules/base

<#
    .SYNOPSIS
    Get journal entries for the previuos, current, and next day
#>
function Get-DailyJournal([datetime]$Date = [datetime]::Today) {
    function Display($Op, $Delta, $Limit) {
        $Day = '{0:yyyy-MM-dd}' -f $Date.AddDays($Delta)
        $Entry = quietly j $Op $Day $Limit --format dates 2> $null | Select-Object -First 1
        if ($null -eq $Entry -or $Entry -notmatch '^\d{4}-\d{2}-\d{2}') { return }
        Write-Host "`n$(Format-RelativeDate $matches.0)`n" -ForegroundColor Blue
        quietly j -on ('{0:yyyy-MM-dd}' -f $matches.0) $JournalArgs 2> $null
    }

    $JournalArgs = $args
    Display '-to' -1 '-n 1'
    Display '-on' 0 '-n 1'
    Display '-from' 1
}

function Get-MonthlyJournal { j -from (Get-Date -Format 'yyyy-MM') -to today --format short @args 2> $null }
function Get-WeeklyJournal { j -from monday -to today --format short @args 2> $null }

function j { run jrnl @args }

Set-Alias -Name 'jd' -Value 'Get-DailyJournal'
Set-Alias -Name 'jm' -Value 'Get-MonthlyJournal'
Set-Alias -Name 'jw' -Value 'Get-WeeklyJournal'
