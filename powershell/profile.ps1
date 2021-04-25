# Modules
Import-Module cd-extras # https://stackoverflow.com/a/48640071/88709
Import-Module DockerCompletion
Import-Module DockerComposeCompletion
Import-Module oh-my-posh
Import-Module posh-git
Import-Module PSColor # http://stackoverflow.com/a/30788506
Import-Module Recycle

# Real paths (i.e., non-symlinked)
$ProfilePath = Get-Item (Get-Item $PSCommandPath).Target
$ProfileDir = $ProfilePath.Directory
$root = $ProfileDir.Parent

# posh-git
$GitPromptSettings.DefaultPromptAbbreviateGitDirectory = $true
$GitPromptSettings.DefaultPromptAbbreviateHomeDirectory = $true

# Oh my Posh
$env:POSH_SESSION_DEFAULT_USER = $env:USERNAME # Hide default user@host
Set-PoshPrompt -Theme "$root/oh-my-posh/daniel.omp.json"
function Set-PoshContext { $env:TITLE = Get-PromptPath }

# Aliases (autocomplete-friendly)
Set-Alias -Name 'console' -Value 'New-ConsoleApp'
Set-Alias -Name 'dn' -Value 'dotnet'
Set-Alias -Name 'g' -Value 'git'
Set-Alias -Name 'gls' -Value 'Get-GitChildItem'
Set-Alias -Name 'j' -Value 'jrnl'
Set-Alias -Name 'l' -Value 'ls'
Set-Alias -Name 'daily' -Value 'Get-Journal'

# Utilities
Set-Alias -Name 'e' -Value 'edit'
Set-Alias -Name 'edit' -Value 'code-insiders'
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
    [Parameter(Mandatory = $true)]
    [string]
    $Path
  )

  if (Test-Path $Path) {
    throw "Path '$Path' already exists. Choose a different one."
  }

  $DirectoryInfo = mkdir $Path
  $OutputName = (Get-Culture).TextInfo.ToTitleCase($DirectoryInfo.Name)
  Set-Location $DirectoryInfo

  git init
  git commit --message="initial" --allow-empty

  dotnet new gitignore
  git add --all
  git commit --message="dotnet new gitignore"

  dotnet new console --name=$OutputName --output=.
  git add --all
  git commit --message="dotnet new console"

  edit . ./Program.cs
}

# .NET CLI
function dna { dotnet add @args }
function dnap { dotnet add package @args }
function dnar { dotnet add reference @args }
function dnb { dotnet build @args }
function dnc { dotnet clean @args }
function dnn { dotnet new @args }
function dnr { dotnet run @args }
function dns { dotnet search @args }
function dnw { dotnet watch @args }
function dnwr { dotnet watch run @args }

# PowerShell parameter completion shim for the dotnet CLI
Register-ArgumentCompleter -Native -CommandName dotnet -ScriptBlock {
  param($commandName, $wordToComplete, $cursorPosition)
  dotnet complete --position $cursorPosition "$wordToComplete" | ForEach-Object {
    [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterValue', $_)
  }
}

# Git
function Get-GitMainBranch {
  foreach ($branch in @('main', 'prod')) {
    if (git branch --list $branch) {
      return $branch
    }
  }
  return 'master'
}

function a { git add @args }
function aa { git add --all @args }
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
function dd { git diff 'develop...HEAD' @args }
function ddx { git diff 'develop..HEAD' @args }
function dm { git diff "$(Get-GitMainBranch)...HEAD" @args }
function dmx { git diff "$(Get-GitMainBranch)..HEAD" @args }
function dr { git diff '@{push}...HEAD' @args }
function drx { git diff '@{push}..HEAD' @args }
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

function Get-GitChildItem {
  $format = '{0,-25}    {1,10}    {2,10}    {3,-25}    {4,-25}'
  $format -f 'Path', 'Size', 'Commits', 'Oldest', 'Newest'
  git ls-tree -l --abbrev HEAD | ForEach-Object {
    $line = $_ -split "`t"
    $file = $line[1]
    $data = $line[0] -split ' +'
    $type = $data[1]
    $size = $data[3]

    # https://stackoverflow.com/a/11729072/88709
    $commits = (git log --oneline -- $file | Measure-Object).Count

    # https://stackoverflow.com/a/13598028/88709
    $oldest = git log --max-count=1 --format="%ai" --diff-filter=A -- $file

    # https://stackoverflow.com/a/4784629/88709
    $newest = git log --max-count=1 --format="%ai" -- $file

    if ($type -eq 'tree') { $file += '/' }
    $format -f $file, $size, $commits, $oldest, $newest
  }
}

# git merge
function gmd { git merge develop @args }
function gmm { git merge "$(Get-GitMainBranch)" @args }

function gr { git recent @args }
function gra { git rebase --abort @args }
function grc { git rebase --continue @args }
function gri { git rebase --interactive @args }
function grid { git rebase --interactive develop @args }
function grim { git rebase --interactive (Get-GitMainBranch) @args }
function grd { git rebase develop @args }
function grm { git rebase (Get-GitMainBranch) @args }
function mt { git mergetool @args }
function sw { git show @args }

function lg { lga --max-count=$($DotfilesOptions.Git.LogMaxCount) @args }
function lga { git log --pretty=small @args }
function lgd { lga --reverse 'develop..HEAD' @args }
function lgdx { lga --reverse 'develop...HEAD' @args }
function lgm { lga --reverse "$(Get-GitMainBranch)..HEAD" @args }
function lgmx { lga --reverse "$(Get-GitMainBranch)...HEAD" @args }
function lgr { lga --reverse '@{push}..HEAD' @args }
function lgrx { lga --reverse '@{push}...HEAD' @args }

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
$env:COLUMNS = 170

# Fix delta hyperlinks - https://github.com/dandavison/delta/issues/332#issuecomment-703149304
$env:DELTA_PAGER = 'less -rFX'

# VS Code as default editor - https://stackoverflow.com/a/57144660/88709
$env:EDITOR = 'code-insiders --wait'

# Default settings
$global:DotfilesOptions = @{
  Git = @{
    LogMaxCount = 10
  }
}

. "$ProfileDir/PSReadLine"
. "$ProfileDir/profile.custom"
