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

function run ($Command) {
    if (!$Quiet) {
        Write-Host @(
            '>'
            Get-QuotedValue $Command
            $args | ForEach-Object { Get-QuotedValue $_ }
        ) -ForegroundColor DarkGray
    }

    & $Command @args
}

function quietly { $Quiet = $true; run @args }

function Get-QuotedValue($Value) {
    if ($Value -isnot [string]) { return $Value }
    if ($Value -notmatch '\W') { return $Value }
    return "'$($Value.Replace("'", "''"))'"
}

Set-Alias -Name 'quote' -Value 'Get-QuotedValue'
