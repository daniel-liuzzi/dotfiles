# http://stackoverflow.com/a/30788506
Import-Module PSColor

# http://haacked.com/archive/2015/10/29/git-shell/
. (Resolve-Path "$env:LOCALAPPDATA\GitHub\shell.ps1")
. (Resolve-Path "$env:github_posh_git\profile.example.ps1")

$GitPromptSettings.EnableWindowTitle = ' '
$GitPromptSettings.DefaultPromptSuffix = "`r`n> "

# Aliases (autocomplete-friendly)
Set-Alias g git
Set-Alias l ls
Set-Alias po popd
Set-Alias pu pushd

# Utilities
Set-Alias e edit
Set-Alias edit subl
Set-Alias o open
Set-Alias wm winmerge

# Git
function a { git add @args }
function b { git branch @args }
function c { git commit @args }
function co { git checkout @args }
function d { git diff @args }
function dm { git diff master @args }
function ds { git diff --staged @args }
function dt { git difftool @args } # allows "Alt+Right", but diff one file at a time
function dtd { git difftool --dir-diff @args } # diffs all files, but no "Alt+Right"
function gr { git recent @args }
function grc { git rebase --continue @args }
function gri { git rebase --interactive @args }
function grim { git rebase --interactive master @args }
function grm { git rebase master @args }
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
function la { ls -force @args }
function mcd { mkdir @args >$null; cd @args }
function open { if ($args) { start @args } else { start . } }

# Add bin/ to the system path
$env:path += ";$env:USERPROFILE\bin\"

# Chocolatey profile
$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
if (Test-Path($ChocolateyProfile)) {
  Import-Module "$ChocolateyProfile"
}
