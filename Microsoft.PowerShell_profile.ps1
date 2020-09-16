Import-Module PSColor # http://stackoverflow.com/a/30788506

Import-Module posh-git
Import-Module oh-my-posh
$DefaultUser = $env:USERNAME # Hide username@domain when not in a VM
Set-Theme Paradox
Set-PSReadlineOption -ExtraPromptLineCount 1

# Aliases (autocomplete-friendly)
Set-Alias dn dotnet
Set-Alias g git
Set-Alias git hub
Set-Alias l ls
Set-Alias po popd
Set-Alias pu pushd

# Utilities
Set-Alias e edit
Set-Alias edit code-insiders
Set-Alias o open
Set-Alias wm winmergeu

# https://stackoverflow.com/a/7785226/88709
filter Search-String {
  [Alias("ss")]
  [OutputType([System.IO.FileInfo])]
  param([string[]] $Patterns)
  foreach ($Pattern in $Patterns) {
    if (-not ($_ | Select-String -Pattern $Pattern)) {
      return
    }
  }

  $_
}

# Git
function a { git add @args }
function b { git branch @args }
function c { git commit @args }
function ca { git commit --amend @args }
function can { git commit --amend --no-edit @args }

function clone($repository) {
  # TODO: Support all URLs syntaxes - https://git-scm.com/docs/git-clone#_git_urls_a_id_urls_a
  if ($repository -notmatch '^(?:git@.*?:|https://.*?/)(?<path>.*?)(?:.git)?$') { throw 'Unsupported URL syntax' }
  $directory = $Matches.path -replace '/', '_' # flatten path
  git clone -- $repository $directory
  Set-Location $directory
}

function co { git checkout @args }
function d { git diff @args }
function dd { git diff develop...HEAD @args }
function dm { git diff master...HEAD @args }
function ds { git diff --staged @args }
function dt { git difftool @args } # allows "Alt+Right", but diff one file at a time
function dtd { git difftool --dir-diff @args } # diffs all files, but no "Alt+Right"

# git-flow
function gf { git flow @args }
function gff { git flow feature @args }
function gffd { git flow feature delete @args }
function gfff { git flow feature finish @args }
function gffp { git flow feature publish @args }
function gffs { git flow feature start @args }
function gfft { git flow feature track @args }
function gfid { git flow init -d }

function gh {
  git ls-files | % {
    New-Object psobject -Property ([ordered]@{
        Path    = $_

        # https://stackoverflow.com/a/11729072/88709
        Commits = (git log --oneline -- $_ | measure).Count

        # https://stackoverflow.com/a/13598028/88709
        Oldest  = [System.DateTimeOffset]::Parse((git log --max-count=1 --format="%ai" --diff-filter=A -- $_))

        # https://stackoverflow.com/a/4784629/88709
        Newest  = [System.DateTimeOffset]::Parse((git log --max-count=1 --format="%ai" -- $_))
      })
  }
}
function gr { git recent @args }
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

# Visual Studio
function dob { Get-ChildItem bin, obj -Directory -Recurse | Remove-Item -Force -Recurse }
function sln { start (ls *.sln -file -recurse) }

# Navigation
function / { cd / }
function \ { cd \ }
function ~ { cd ~ }
function .. { cd .. }

# Miscellaneous
function archive {
  $date = Get-Date -Format 'yyyy-MM-dd'
  $dest = Join-Path '~/!Archive' $date
  New-Item -Path $dest -ItemType Directory
  Get-ChildItem -Path '~/Desktop' -Recurse -Force | Move-Item -Destination $dest
}
function la { ls -force @args }
function mcd { mkdir @args >$null; cd @args }
function open { if ($args) { start @args } else { start . } }

# Enable 24-bit color support - https://unix.stackexchange.com/a/450366
$env:COLORTERM = 'truecolor'

# Make git diff --stat show full file path - https://stackoverflow.com/a/16733338
$env:COLUMNS = 170

# VS Code as default editor - https://stackoverflow.com/a/57144660/88709
$env:EDITOR = 'code-insiders --wait'

# Enable Hyperlinks - https://github.com/microsoft/terminal/pull/7251#issuecomment-692953180
$ESC = "`e"

# Add bin/ to the system path
$env:path += ";$env:USERPROFILE\bin\"

. "$PSScriptRoot\Microsoft.PowerShell_profile.custom.ps1"
