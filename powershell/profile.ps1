# Real paths (i.e., non-symlinked)
$ProfilePath = Get-Item (Get-Item $PSCommandPath).Target
$ProfileDir = $ProfilePath.Directory
$root = $ProfileDir.Parent

. "$ProfileDir/profile.pre.custom"

# Modules
Import-Module cd-extras # https://stackoverflow.com/a/48640071/88709
Import-Module DockerCompletion
Import-Module DockerComposeCompletion
Import-Module oh-my-posh
Import-Module posh-git
Import-Module PSColor # http://stackoverflow.com/a/30788506
Import-Module Recycle

# posh-git
$GitPromptSettings.DefaultPromptAbbreviateGitDirectory = $true
$GitPromptSettings.DefaultPromptAbbreviateHomeDirectory = $true

# Oh my Posh
$env:POSH_SESSION_DEFAULT_USER = $env:USERNAME # Hide default user@host
Set-PoshPrompt -Theme "$root/oh-my-posh/daniel.omp.json"
function Set-PoshContext { $env:TITLE = Get-PromptPath }

# Aliases (autocomplete-friendly)
Set-Alias -Name 'ads' -Value 'azuredatastudio'
Set-Alias -Name 'console' -Value 'New-ConsoleApp'
Set-Alias -Name 'gls' -Value 'Get-GitChildItem'
Set-Alias -Name 'j' -Value 'jrnl'
Set-Alias -Name 'l' -Value 'ls'
Set-Alias -Name 'daily' -Value 'Get-Journal'

# Utilities
Set-Alias -Name 'e' -Value 'edit'
Set-Alias -Name 'edit' -Value 'code-insiders'
Set-Alias -Name 'ip' -Value 'Get-MyIp'
Set-Alias -Name 'o' -Value 'open'
Set-Alias -Name 'theme' -Value 'Set-Theme'
Set-Alias -Name 'wm' -Value 'winmergeu'

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

<#
  .SYNOPSIS
  Get journal entries for the previuos, current, and next day
#>
function Get-Journal {
  function Display ($jrnl) {
    $entry = Invoke-Expression "jrnl $jrnl --format dates" | Select-Object -First 1
    if ($entry -notmatch '^\d{4}-\d{2}-\d{2}') { return }
    Write-Host "`n$(Format-RelativeDate $matches.0)`n" -ForegroundColor Blue
    jrnl -on ('{0:yyyy-MM-dd}' -f $matches.0) $jrnl_args
  }

  $jrnl_args = $args
  Display ('-to {0:yyyy-MM-dd} -n 1' -f [datetime]::Today.AddDays(-1))
  Display ('-on {0:yyyy-MM-dd} -n 1' -f [datetime]::Today)
  Display ('-from {0:yyyy-MM-dd}' -f [datetime]::Today.AddDays(1))
}

<#
  .SYNOPSIS
  Get public IP
#>
function Get-MyIp { Invoke-RestMethod 'https://ident.me/' }

function Format-RelativeDate ([datetime]$Value) {
  switch (($Value.Date - [datetime]::Today).Days) {
    { $_ -ge -7 -and $_ -le -2 } { 'Last {0:dddd}' -f $Value }
    { $_ -eq -1 } { 'Yesterday' }
    { $_ -eq 0 } { 'Today' }
    { $_ -eq 1 } { 'Tomorrow' }
    { $_ -ge 2 -and $_ -le 7 } { 'Next {0:dddd}' -f $Value }
    Default { '{0:D}' -f $Value }
  }
}

<#
.SYNOPSIS
    Creates a new dotnet console app and opens it in the text editor.
#>
function New-ConsoleApp {
  param (
    [string]
    $Path = '.'
  )

  if (-not (Test-Path $Path)) {
    mkdir $Path
  }
  elseif (Get-ChildItem $Path -Force) {
    throw 'Error: Directory not empty'
  }

  Set-Location $Path

  git init
  git commit --message="initial" --allow-empty

  dotnet new gitignore
  git add --all
  git commit --message="dotnet new gitignore"

  dotnet new console
  git add --all
  git commit --message="dotnet new console"

  edit . ./Program.cs
}

# dotnet
function dn { run dotnet @args }
function dna { dn add @args }
function dnap { dna package @args }
function dnar { dna reference @args }
function dnb { dn build @args }
function dnc { dn clean @args }
function dnn { dn new @args }
function dnr { dn run @args }
function dns { dn search @args }
function dnw { dn watch @args }
function dnwr { dnw run @args }

# PowerShell parameter completion shim for the dotnet CLI
Register-ArgumentCompleter -Native -CommandName dotnet -ScriptBlock {
  param($commandName, $wordToComplete, $cursorPosition)
  dotnet complete --position $cursorPosition "$wordToComplete" | ForEach-Object {
    [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterValue', $_)
  }
}

# git
function g { run git @args }
function a { g add @args }
function aa { a --all @args }
function b { g branch @args }
function c { g commit @args }
function ca { c --amend @args }
function can { ca --no-edit @args }
function dt { g difftool @args } # allows "Alt+Right", but diff one file at a time
function dtd { dt --dir-diff @args } # diffs all files, but no "Alt+Right"
function mt { g mergetool @args }

function pull {
  if (lgu --grep='^WIP$') { throw 'WIP commits found. Please unwip before pulling.' }
  g pull @args
}

function push {
  if (lgp --grep='^WIP$') { throw 'WIP commits found. Please unwip before pushing.' }
  g push @args
}

function re { g recent @args }
function s { g status @args }
function show { g show @args }
function sw { g show @args }
function wip { aa; c -m 'WIP' }

function unwip {
  if (sw --grep='^WIP$' --invert-grep) { throw 'Nothing to unwip.' }
  rs HEAD^
}

# git flow
function gf { g flow @args }
function gfi { gf init @args }
function gfid { gfi -d }
function gff { gf feature @args }
function gffd { gff delete @args }
function gfff { gff finish @args }
function gffp { gff publish @args }
function gffs { gff start @args }
function gfft { gff track @args }

# git checkout
function co { g checkout @args }
function cob { co (Get-GitBranchBase) @args }
function cod { co (Get-GitBranchDev) @args }
function com { co (Get-GitBranchMain) @args }

# git diff
function d { g diff @args }
function ds { d --staged @args }
function db { d "$(Get-GitBranchBase)...HEAD" @args }
function dba { d "$(Get-GitBranchBase)..HEAD" @args }
function dd { d "$(Get-GitBranchDev)...HEAD" @args }
function dda { d "$(Get-GitBranchDev)..HEAD" @args }
function dm { d "$(Get-GitBranchMain)...HEAD" @args }
function dma { d "$(Get-GitBranchMain)..HEAD" @args }
function dp { d '"@{push}...HEAD"' @args }
function dpa { d '"@{push}..HEAD"' @args }
function du { d '"@{upstream}...HEAD"' @args }
function dua { d '"@{upstream}..HEAD"' @args }

# git log
function lg { g log --pretty=small @args }
function lgr { lg --reverse @args }
function lgb { lgr "$(Get-GitBranchBase)..HEAD" @args }
function lgba { lgr "$(Get-GitBranchBase)...HEAD" @args }
function lgd { lgr "$(Get-GitBranchDev)..HEAD" @args }
function lgda { lgr "$(Get-GitBranchDev)...HEAD" @args }
function lgm { lgr "$(Get-GitBranchMain)..HEAD" @args }
function lgma { lgr "$(Get-GitBranchMain)...HEAD" @args }
function lgp { lgr '"@{push}..HEAD"' @args }
function lgpa { lgr '"@{push}...HEAD"' @args }
function lgu { lgr '"@{upstream}..HEAD"' @args }
function lgua { lgr '"@{upstream}...HEAD"' @args }

# git merge
function gm_ { g merge @args }
function gma { gm_ --abort @args }
function gmc { gm_ --continue @args }
function gmb { gm_ (Get-GitBranchBase) @args }
function gmd { gm_ (Get-GitBranchDev) @args }
function gmm { gm_ (Get-GitBranchMain) @args }

# git rebase
function gr { g rebase @args }
function gra { gr --abort @args }
function grc { gr --continue @args }
function grb { gr (Get-GitBranchBase) @args }
function grd { gr (Get-GitBranchDev) @args }
function grm { gr (Get-GitBranchMain) @args }
function gri { gr --interactive @args }
function grib { gri (Get-GitBranchBase) @args }
function grid { gri (Get-GitBranchDev) @args }
function grim { gri (Get-GitBranchMain) @args }

# git reset
function rs { g reset @args }
function rsb { rs (Get-GitBranchBase) @args }
function rsd { rs (Get-GitBranchDev) @args }
function rsm { rs (Get-GitBranchMain) @args }
function rsp { rs '"@{push}"' @args }
function rsu { rs '"@{upstream}"' @args }

# git cherry-pick
function gcp { g cherry-pick @args }
function gcpa { gcp --abort @args }
function gcpc { gcp --continue @args }
function gcps { gcp --skip @args }

function clone($repository) {
  # TODO: Support all URLs syntaxes - https://git-scm.com/docs/git-clone#_git_urls_a_id_urls_a
  if ($repository -notmatch '^(?:git@.*?:|https://.*?/)(?<path>.*?)(?:.git)?$') { throw 'Unsupported URL syntax' }
  $directory = $Matches.path -replace '/', '_' # flatten path
  g clone -- $repository $directory
  Set-Location $directory
}

function Get-GitBranchBase {
  $current = Get-GitBranchCurrent

  $base = git config gitflow.branch.$current.base
  if ($base) { return $base }

  $main = Get-GitBranchMain
  if ($current -eq $main) { return $null }

  $develop = Get-GitBranchDev
  if (!$develop) { return $main }
  if ($develop -eq $current) { return $main }

  return $develop
}

function Get-GitBranchCurrent {
  git branch --show-current
}
function Get-GitBranchDev {
  Find-GitBranch (@(git config gitflow.branch.develop) + $DotfilesOptions.Git.Dev)
}
function Get-GitBranchMain {
  Find-GitBranch (@(git config gitflow.branch.master) + $DotfilesOptions.Git.Main)
}

function Find-GitBranch($Names) {
  foreach ($branch in $Names) {
    if (git branch --list $branch) {
      return $branch
    }
  }
}

function Get-GitChildItem {
  $format = '| {0,-50} | {1,7} | {2,-25} | {3,-25} |'
  $format -f 'Path', 'Commits', 'Oldest', 'Newest'
  $format -f ":$('-' * 49)", "$('-' * 6):", ":$('-' * 23):", ":$('-' * 23):"
  git ls-tree -l --abbrev HEAD | ForEach-Object {
    $line = $_ -split "`t"
    $file = $line[1]
    $data = $line[0] -split ' +'
    $type = $data[1]

    # https://stackoverflow.com/a/11729072/88709
    $commits = (git log --oneline -- $file | Measure-Object).Count

    # https://stackoverflow.com/a/13598028/88709
    $oldest = git log --max-count=1 --format="%ai" --diff-filter=A -- $file

    # https://stackoverflow.com/a/4784629/88709
    $newest = git log --max-count=1 --format="%ai" -- $file

    if ($type -eq 'tree') { $file += '/' }
    $format -f $file, $commits, $oldest, $newest
  }
}

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
function / { Set-Location '/' }
function \ { Set-Location '\' }
function ~ { Set-Location '~' }
function .. { Set-Location '..' }

# Miscellaneous
function archive {
  # TODO: delete node_modules, bin, obj recursively
  $date = Get-Date -Format 'yyyy-MM-dd'
  $path = Join-Path '~/!Archive' $date
  New-Item -Path $path -ItemType Directory -Force | Out-Null
  Get-ChildItem -Path '~/Desktop' -Recurse -Force | Move-Item -Destination $path | Out-Null
  Write-Output 'Desktop archived successfully.'
  Start-Process -FilePath (Resolve-Path $path)
}
function hosts { sudo code-insiders $env:SystemRoot\System32\drivers\etc\hosts }
function la { Get-ChildItem -Force @args }
function mcd { mkdir @args | Set-Location }
function open { if ($args) { Start-Process @args } else { Start-Process . } }
function sh { & '~/scoop/apps/git/current/bin/sh.exe' }
function run {
  $cmd = $args.ForEach( {
      $token = $_.ToString()
      $qualify = $token.ToCharArray().ForEach( { [char]::IsWhiteSpace($_) -or $_ -in @('"', "'") } ).Contains($true)
      $value = $token.Replace("'", "''")
      if ($qualify) { "'$value'" } else { $value }
    } ) -join ' '

  Write-Host "> $cmd" -ForegroundColor DarkGray
  Invoke-Expression $cmd
}

<#
  .SYNOPSIS
  Switch apps and system color themes.

  .DESCRIPTION
  Omitting both parameters will toggle between dark and light themes.
#>
function Set-Theme {
  [CmdletBinding(DefaultParameterSetName = 'toggle')]
  param (
    # Switch to dark color scheme.
    [parameter(ParameterSetName = 'dark')]
    [switch]
    $Dark,

    # Switch to light color scheme.
    [parameter(ParameterSetName = 'light')]
    [switch]
    $Light
  )

  $Key = 'HKCU:/SOFTWARE/Microsoft/Windows/CurrentVersion/Themes/Personalize'

  $OldIsLight = [bool](Get-ItemProperty -Path $Key).SystemUsesLightTheme
  $NewIsLight = if ($Dark -or $Light) { !$Dark } else { !$OldIsLight }
  if ($NewIsLight -eq $OldIsLight) { return }

  Set-ItemProperty -Path $Key -Name 'AppsUseLightTheme' -Value $NewIsLight
  Set-ItemProperty -Path $Key -Name 'SystemUsesLightTheme' -Value $NewIsLight
}

# SQL Server
function Stop-SqlServer { sudo pwsh -Command 'net stop SQLSERVERAGENT; net stop MSSQLSERVER' }
function Start-SqlServer { sudo pwsh -Command 'net start MSSQLSERVER; net start SQLSERVERAGENT' }
function Restart-SqlServer { sudo pwsh -Command 'Stop-SqlServer; Start-SqlServer' }

# Enable 24-bit color support - https://unix.stackexchange.com/a/450366
$env:COLORTERM = 'truecolor'

# Make git diff --stat show full file path - https://stackoverflow.com/a/16733338
$env:COLUMNS = 135

# Fix delta hyperlinks - https://github.com/dandavison/delta/issues/332#issuecomment-703149304
$env:DELTA_PAGER = 'less -rFX'

# VS Code as default editor - https://stackoverflow.com/a/57144660/88709
$env:EDITOR = 'code-insiders --wait'

# Default settings
$global:DotfilesOptions = @{
  Git = @{
    Dev  = @('develop')
    Main = @('main', 'master')
  }
}

. "$ProfileDir/PSReadLine"

. "$ProfileDir/profile.post.custom"
