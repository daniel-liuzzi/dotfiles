$CommandPath = Get-Item $PSCommandPath
$Global:ProfilePath = if ($CommandPath.Target) { $CommandPath.Target } else { $CommandPath.FullName }
$Global:ProfileDir = Split-Path $Global:ProfilePath -Parent
$Global:Root = Split-Path $Global:ProfileDir -Parent
$Global:DotfilesOptions = @{
    Git = @{
        Dev  = @('develop')
        Main = @('main', 'master')
    }
}

Get-ChildItem $ProfileDir/*.psm1 -File | foreach { Import-Module $_ -Force }
