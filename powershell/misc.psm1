function / { Set-Location '/' }
function \ { Set-Location '\' }
function ~ { Set-Location '~' }
function .. { Set-Location '..' }
function ... { Set-Location '../..' }
function .... { Set-Location '../../..' }
function ..... { Set-Location '../../../..' }
function ...... { Set-Location '../../../../..' }
function ....... { Set-Location '../../../../../..' }
function ........ { Set-Location '../../../../../../..' }
function ......... { Set-Location '../../../../../../../..' }
function .......... { Set-Location '../../../../../../../../..' }
function ........... { Set-Location '../../../../../../../../../..' }

function Get-SavedHistory { Get-Content (Get-PSReadlineOption).HistorySavePath @args }
function hosts { sudo code $env:SystemRoot\System32\drivers\etc\hosts }
function la { Get-ChildItem -Force @args }
function mcd { mkdir -Force @args | Set-Location }
function sh { & '~/scoop/apps/git/current/bin/sh.exe' @args }
function which { Get-Command @args | Select-Object -ExpandProperty Definition }

Set-Alias -Name 'ads' -Value 'azuredatastudio'
Set-Alias -Name 'hist' -Value 'Get-SavedHistory'
Set-Alias -Name 'LogParser' -Value "${env:ProgramFiles(x86)}/Log Parser 2.2/LogParser.exe"
Set-Alias -Name 'o' -Value 'Start-Process'
Set-Alias -Name 'open' -Value 'Start-Process'
Set-Alias -Name 'top' -Value 'ntop'
