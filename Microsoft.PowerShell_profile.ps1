Import-Module posh-git
Import-Module PSColor # http://stackoverflow.com/a/30788506

$GitPromptSettings.DefaultPromptAbbreviateHomeDirectory = $true
$GitPromptSettings.EnableWindowTitle = ' '

# Aliases (autocomplete-friendly)
Set-Alias dn dotnet
Set-Alias g git
Set-Alias git hub
Set-Alias l ls
Set-Alias po popd
Set-Alias pu pushd

# Utilities
Set-Alias e edit
Set-Alias edit code
Set-Alias o open
Set-Alias wm winmergeu

# Git
function a { git add @args }
function b { git branch @args }
function c { git commit @args }
function clone { git clone @args }
function co { git checkout @args }
function d { git diff @args }
function dd { git diff develop...HEAD @args }
function dm { git diff master...HEAD @args }
function ds { git diff --staged @args }
function dt { git difftool @args } # allows "Alt+Right", but diff one file at a time
function dtd { git difftool --dir-diff @args } # diffs all files, but no "Alt+Right"
function gh {
  git ls-files | % {
    New-Object psobject -Property ([ordered]@{
      Path = $_

      # https://stackoverflow.com/a/11729072/88709
      Commits = (git log --oneline -- $_ | measure).Count

      # https://stackoverflow.com/a/13598028/88709
      Oldest = [System.DateTimeOffset]::Parse((git log --max-count=1 --format="%ai" --diff-filter=A -- $_))

      # https://stackoverflow.com/a/4784629/88709
      Newest = [System.DateTimeOffset]::Parse((git log --max-count=1 --format="%ai" -- $_))
    })
  }
}
function gr { git recent -n5 @args }
function gra { git rebase --abort @args }
function grc { git rebase --continue @args }
function gri { git rebase --interactive @args }
function grid { git rebase --interactive develop @args }
function grim { git rebase --interactive master @args }
function grd { git rebase develop @args }
function grm { git rebase master @args }
function mt { git mergetool @args }
function sw { git show @args }

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

function lgd($rev) {
    git log `
    --reverse `
    --pretty=format:'%Cgreen%ad%Creset  %Cred%h%Creset  %<(50,trunc)%s  %C(cyan)%an%Creset' `
    --date=format-local:'%a, %d %b %Y, %H:%M' `
    develop..$(if ($rev) { $rev } else { 'HEAD' }) `
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

# Miscellaneous
function la { ls -force @args }
function mcd { mkdir @args >$null; cd @args }
function open { if ($args) { start @args } else { start . } }

# Add bin/ to the system path
$env:path += ";$env:USERPROFILE\bin\"

cd ~
