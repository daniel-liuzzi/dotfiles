function Get-ArgsOptions {
    $args | Where-Object { $_.ToString().StartsWith('-') }
}

function Get-ArgsOther {
    $args | Where-Object { !$_.ToString().StartsWith('-') }
}

function New-Link {
    param (
        [Parameter(Mandatory = $true)]
        [ValidateSet('SymbolicLink', 'Junction', 'HardLink')]
        [string]
        $Type,

        [Parameter(Mandatory = $true)]
        [string]
        $Target,

        [Parameter(Mandatory = $true)]
        [string[]]
        $Source
    )

    $TargetPath = Resolve-Path $Target -ErrorAction SilentlyContinue
    if (!$TargetPath) {
        return Write-Error "Target path '$Target' does not exist."
    }

    $Source | ForEach-Object {
        $Item = Get-Item $_ -ErrorAction SilentlyContinue
        if ($Item) {
            if ($Item.LinkType -eq $Type -and
                $Item.LinkTarget -eq $TargetPath) {
                return $Item
            }

            Move-Item $_ "$_.bak" -Force
        }

        New-Item $_ -ItemType $Type -Target $TargetPath -Force
    }
}

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
