# http://stackoverflow.com/a/30788506
Import-Module PSColor

# http://haacked.com/archive/2015/10/29/git-shell/
. (Resolve-Path "$env:LOCALAPPDATA\GitHub\shell.ps1")
. (Resolve-Path "$env:github_posh_git\profile.example.ps1")

$GitPromptSettings.EnableWindowTitle = ' '

# # Useful, but too slow
# $GitPromptSettings.EnableStashStatus = $true

# $global:GitPromptSettings.BeforeText = '['
# $global:GitPromptSettings.AfterText  = '] '

# # Prompt
# function global:prompt {
#     $realLASTEXITCODE = $LASTEXITCODE

#     $ui = $Host.UI.RawUI

#     $path = $PWD.Path
#     if ($path.StartsWith($env:HOME)) {
#         $path = '~' + $path.Substring($env:HOME.Length)
#     }
#     elseif ($path.StartsWith($env:SystemDrive)) {
#         $path = $path.Substring($env:SystemDrive.Length)
#     }

#     # Path
#     $bg = $ui.BackgroundColor
#     $ui.BackgroundColor = 'Blue'
#     Write-Host $path.PadRight($ui.WindowSize.Width - 1, ' ')
#     $ui.BackgroundColor = $bg

#     # Reset color, which can be messed up by Enable-GitColors
#     $ui.ForegroundColor = $GitPromptSettings.DefaultForegroundColor

#     Write-VcsStatus

#     $global:LASTEXITCODE = $realLASTEXITCODE
#     return '> '
# }

$GitPromptSettings.DefaultPromptSuffix = '
> '

# Aliases (autocomplete-friendly)
Set-Alias g git
Set-Alias l ls
Set-Alias po popd
Set-Alias pu pushd

# Utilities
# # function atom { cmd /c "$env:LOCALAPPDATA\atom\Update.exe --processStart atom.exe" } # http://stackoverflow.com/a/4167071
# # Set-Alias code "${env:ProgramFiles(x86)}\Microsoft VS Code\Code.exe"
# Set-Alias subl "$env:ProgramFiles\Sublime Text 3\subl.exe" # http://stackoverflow.com/a/10853587
Set-Alias wm winmerge
Set-Alias edit subl
Set-Alias e edit

# Git
function a { git add @args }
function b { git branch @args }

# # -vv doesn't play well on Sublime Text w/editorconfig-sublime
# # https://github.com/sindresorhus/editorconfig-sublime/issues/55
# function co { git commit -vv @args }
function c { git commit @args }

function co { git checkout @args }
function d { git diff @args }
function ds { git diff --staged @args }
function dt { git difftool --dir-diff @args }
function gr { git recent @args }
function mt { git mergetool @args }

function lg {
    git log `
    --pretty=format:'%Cgreen%ad%Creset  %Cred%h%Creset  %<(50,trunc)%s  %C(cyan)%an%Creset' `
    --date=format-local:'%a, %d %b %Y, %H:%M' `
    --graph `
    @args
}

function lgm($rev) {
    git log `
    --reverse `
    --pretty=format:'%Cgreen%ad%Creset  %Cred%h%Creset  %<(50,trunc)%s  %C(cyan)%an%Creset' `
    --date=format-local:'%a, %d %b %Y, %H:%M' `
    master..$(if ($rev) { $rev } else { 'HEAD' }) `
    @args
}

function pull { git pull @args }
function push { git push @args }
function s { git status @args }
function show { git show @args }

# Navigation
function \ { cd \ }
function ~ { cd ~ }
function .. { cd .. }
function ... { cd ..\.. }
function .... { cd ..\..\.. }
function ..... { cd ..\..\..\.. }
function ...... { cd ..\..\..\..\.. }
function ....... { cd ..\..\..\..\..\.. }
function ........ { cd ..\..\..\..\..\..\.. }
function ......... { cd ..\..\..\..\..\..\..\.. }
function .......... { cd ..\..\..\..\..\..\..\..\.. }
function ........... { cd ..\..\..\..\..\..\..\..\..\.. }

# Miscellaneous
# function e { if ($args) { subl @args } else { subl . } }
# # function e { if ($args) { atom @args } else { atom . } }
function la { ls -force @args }
function mcd { mkdir @args >$null; cd @args }
function o { if ($args) { start @args } else { start . } }

# Chocolatey profile
$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
if (Test-Path($ChocolateyProfile)) {
  Import-Module "$ChocolateyProfile"
}
