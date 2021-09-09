function Format-RelativeDate ([datetime]$Value) {
    switch (($Value.Date - [datetime]::Today).Days) {
        { $_ -ge -7 -and $_ -le -2 } { 'Last {0:dddd}' -f $Value }
        { $_ -eq -1 } { 'Yesterday' }
        { $_ -eq 0 } { 'Today' }
        { $_ -eq 1 } { 'Tomorrow' }
        { $_ -ge 2 -and $_ -le 7 } { 'Next {0:dddd}' -f $Value }
        Default { '{0:D}' -f $Value }
    }
}

function run {
    $Command = $args.ForEach( {
            if ($_ -isnot [string]) { return $_ }
            $Qualify = $_.ToCharArray().ForEach( { [char]::IsWhiteSpace($_) -or $_ -in @('"', "'") } ).Contains($true)
            $Value = $_.Replace("'", "''")
            if ($Qualify) { "'$Value'" } else { $Value }
        } ) -join ' '

    if (!$Quiet) { Write-Host "> $Command" -ForegroundColor DarkGray }
    Invoke-Expression $Command
}

function quietly { $Quiet = $true; run @args }
