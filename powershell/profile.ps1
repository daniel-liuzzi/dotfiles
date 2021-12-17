$Global:ProfilePath = (Get-Item $PSCommandPath).Target # real path (non-symlinked)
$Global:ProfileDir = Split-Path $ProfilePath -Parent
$Global:Root = Split-Path $ProfileDir -Parent
$Global:DotfilesOptions = @{
    Git = @{
        Dev  = @('develop')
        Main = @('main', 'master')
    }
}

Import-Module (Get-ChildItem $ProfileDir/modules/*.psm1 -File) -Force
