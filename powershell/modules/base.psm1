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
        Write-Host '&' (Get-QuotedValues $Command @args) -ForegroundColor DarkGray
    }

    & $Command @args
}

function quietly { $Quiet = $true; run @args }

function Get-QuotedValues {
    $args | ForEach-Object {
        if ($_ -isnot [string]) { return $_ }
        if ($_ -notmatch '[^-./\\\w^=~]') { return $_ }
        return "'$($_.Replace("'", "''"))'"
    }
}

Set-Alias -Name 'quote' -Value 'Get-QuotedValues'
