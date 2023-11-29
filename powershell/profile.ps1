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

Import-Module (Get-ChildItem $ProfileDir/modules/*.psm1 -File) -Force
