$Global:ProfilePath = (Get-Item $PSCommandPath).Target # real path (non-symlinked)
$Global:ProfileDir = Split-Path $ProfilePath -Parent
$Global:Root = Split-Path $ProfileDir -Parent
$Global:DotfilesOptions = @{
    Git = @{
        Dev  = @('develop')
        Main = @('main', 'master')
    }
}

Get-ChildItem $ProfileDir/modules -Filter *.psm1 -File | Import-Module
