﻿Import-Module PSColor # http://stackoverflow.com/a/30788506
Import-Module cd-extras # https://stackoverflow.com/a/48640071/88709

Import-Module posh-git
Import-Module oh-my-posh
$DefaultUser = $env:USERNAME # Hide username@domain when not in a VM
Set-Theme Paradox
Set-PSReadLineKeyHandler -Key 'Tab', 'Shift+Tab' -Function 'MenuComplete'
Set-PSReadlineOption -ExtraPromptLineCount 1
$ThemeSettings.Colors.GitForegroundColor = [ConsoleColor]::White
$ThemeSettings.Colors.PromptBackgroundColor = [ConsoleColor]::DarkGray
$ThemeSettings.Colors.PromptForegroundColor = [ConsoleColor]::White

# Aliases (autocomplete-friendly)
Set-Alias dn dotnet
Set-Alias g git
Set-Alias l ls

# Utilities
Set-Alias e edit
Set-Alias edit code-insiders
Set-Alias o open
Set-Alias wm winmergeu

# Move to Recycle Bin instead of deleting
# https://www.powershellgallery.com/packages/Recycle
Set-Alias -Name 'del' -Value 'Remove-ItemSafely' -Option AllScope
Set-Alias -Name 'erase' -Value 'Remove-ItemSafely'
Set-Alias -Name 'rd' -Value 'Remove-ItemSafely'
Set-Alias -Name 'ri' -Value 'Remove-ItemSafely' -Force
Set-Alias -Name 'rm' -Value 'Remove-ItemSafely'
Set-Alias -Name 'rmdir' -Value 'Remove-ItemSafely'

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
function dd { git diff 'develop..' @args }
function dm { git diff 'master..' @args }
function dr { git diff '@{push}..' @args }
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

function lg { git log --pretty=small @args }
function lgd { git log --pretty=small --reverse 'develop..' @args }
function lgm { git log --pretty=small --reverse 'master..' @args }
function lgr { git log --pretty=small --reverse '@{push}..' @args }

function pull { git pull @args }
function push { git push @args }
function s { git status @args }
function show { git show @args }

# Visual Studio
function dob { Get-ChildItem bin, obj -Directory -Recurse | Remove-Item -Force -Recurse }

function sln {
  $path = Get-ChildItem *.sln -Recurse -Depth 1 -File | Select-Object -First 1
  if ($path) {
    Write-Output "Starting $path"
    Start-Process $path
  }
  else {
    Write-Error 'Solution file not found'
  }
}

# Navigation
function / { cd / }
function \ { cd \ }
function ~ { cd ~ }
function .. { cd .. }

# Miscellaneous
function archive {
  $date = Get-Date -Format 'yyyy-MM-dd'
  $path = Join-Path '~/!Archive' $date
  New-Item -Path $path -ItemType Directory -Force | Out-Null
  Get-ChildItem -Path '~/Desktop' -Recurse -Force | Move-Item -Destination $path | Out-Null
  Write-Output "Desktop archived successfully."
  Start-Process -FilePath (Resolve-Path $path)
}
function la { ls -force @args }
function mcd { mkdir @args >$null; cd @args }
function open { if ($args) { start @args } else { start . } }

# Enable 24-bit color support - https://unix.stackexchange.com/a/450366
$env:COLORTERM = 'truecolor'

# Make git diff --stat show full file path - https://stackoverflow.com/a/16733338
$env:COLUMNS = 170

# Fix delta hyperlinks - https://github.com/dandavison/delta/issues/332#issuecomment-703149304
$env:DELTA_PAGER = 'less -rFX'

# VS Code as default editor - https://stackoverflow.com/a/57144660/88709
$env:EDITOR = 'code-insiders --wait'

# Enable Hyperlinks - https://github.com/microsoft/terminal/pull/7251#issuecomment-692953180
$ESC = "`e"

# Add bin/ to the system path (if not already present)
if (!$env:Path.Contains("$env:USERPROFILE\bin\")) {
  $env:Path = "$env:USERPROFILE\bin\;$env:Path"
}

. "$PSScriptRoot\Microsoft.PowerShell_profile.custom.ps1"