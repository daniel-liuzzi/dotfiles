function / { Set-Location '/' }
function \ { Set-Location '\' }
function ~ { Set-Location '~' }
function .. { Set-Location '..' }

function hosts { sudo code $env:SystemRoot\System32\drivers\etc\hosts }
function la { Get-ChildItem -Force @args }
function mcd { mkdir @args | Set-Location }
function sh { & '~/scoop/apps/git/current/bin/sh.exe' @args }
function which { Get-Command @args | Select-Object -ExpandProperty Definition }

Set-Alias -Name 'ads' -Value 'azuredatastudio'
Set-Alias -Name 'l' -Value 'Get-ChildItem'
Set-Alias -Name 'o' -Value 'Start-Process'
Set-Alias -Name 'open' -Value 'Start-Process'
