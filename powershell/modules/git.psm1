Import-Module $ProfileDir/modules/base

function g { run git @args }
function a { g add @args }
function aa { a --all @args }
function b { g branch @args }
function c { g commit @args }
function ca { c --amend @args }
function can { ca --no-edit @args }
function cn { c --no-edit @args }
function dt { g difftool @args } # allows "Alt+Right", but diff one file at a time
function dtd { dt --dir-diff @args } # diffs all files, but no "Alt+Right"
function mt { g mergetool @args }

function pull {
    if (quietly lgu --grep='^WIP$' 2> $null) { throw 'WIP commits found. Please unwip before pulling.' }
    g pull @args
}

function push {
    if (quietly lgp --grep='^WIP$' 2> $null) { throw 'WIP commits found. Please unwip before pushing.' }
    g push --set-upstream @args
}

function re { g recent @args }
function s { g status @args }
function show { g show @args }
function sw { show @args }
function wip { aa; c --message=WIP }

function unwip {
    if (quietly sw --grep='^WIP$' --invert-grep) { throw 'Nothing to unwip.' }
    rs HEAD^
}

# git checkout
function co { g checkout @args }
function cob {
    co @(
        Get-GitFlags @args
        Get-GitBranchBase
        Get-GitArgs @args
    )
}
function cod {
    co @(
        Get-GitFlags @args
        Get-GitBranchDev
        Get-GitArgs @args
    )
}
function com {
    co @(
        Get-GitFlags @args
        Get-GitBranchMain
        Get-GitArgs @args
    )
}

# git diff
function d { g diff @args }
function ds { d --staged @args }
function db {
    $Ref = Get-GitRevs @args
    if (!$Ref) { $Ref = 'HEAD' }
    d @(
        Get-GitFlags @args
        "$(Get-GitBranchBase $Ref)...$Ref"
        Get-GitArgs @args
    )
}
function dba {
    $Ref = Get-GitRevs @args
    if (!$Ref) { $Ref = 'HEAD' }
    d @(
        Get-GitFlags @args
        "$(Get-GitBranchBase $Ref)..$Ref"
        Get-GitArgs @args
    )
}
function dd { d "$(Get-GitBranchDev)...HEAD" @args }
function dda { d "$(Get-GitBranchDev)..HEAD" @args }
function dm { d "$(Get-GitBranchMain)...HEAD" @args }
function dma { d "$(Get-GitBranchMain)..HEAD" @args }
function dp { d '@{push}...HEAD' @args }
function dpa { d '@{push}..HEAD' @args }
function du { d '@{upstream}...HEAD' @args }
function dua { d '@{upstream}..HEAD' @args }

# git log
function lg { g log --pretty=s @args }
function lgr { lg --reverse @args }
function lgb {
    $Ref = Get-GitRevs @args
    if (!$Ref) { $Ref = 'HEAD' }
    lgr @(
        Get-GitFlags @args
        "$(Get-GitBranchBase $Ref)..$Ref"
        Get-GitArgs @args
    )
}
function lgba {
    $Ref = Get-GitRevs @args
    if (!$Ref) { $Ref = 'HEAD' }
    lgr @(
        Get-GitFlags @args
        "$(Get-GitBranchBase $Ref)...$Ref"
        Get-GitArgs @args
    )
}
function lgd { lgr "$(Get-GitBranchDev)..HEAD" @args }
function lgda { lgr "$(Get-GitBranchDev)...HEAD" @args }
function lgm { lgr "$(Get-GitBranchMain)..HEAD" @args }
function lgma { lgr "$(Get-GitBranchMain)...HEAD" @args }
function lgp { lgr '@{push}..HEAD' @args }
function lgpa { lgr '@{push}...HEAD' @args }
function lgu { lgr '@{upstream}..HEAD' @args }
function lgua { lgr '@{upstream}...HEAD' @args }

# git merge
function gm_ { g merge @args }
function gma { gm_ --abort @args }
function gmc { gm_ --continue @args }
function gmb {
    gm_ @(
        Get-GitFlags @args
        Get-GitBranchBase
        Get-GitArgs @args
    )
}
function gmd {
    gm_ @(
        Get-GitFlags @args
        Get-GitBranchDev
        Get-GitArgs @args
    )
}
function gmm {
    gm_ @(
        Get-GitFlags @args
        Get-GitBranchMain
        Get-GitArgs @args
    )
}

# git rebase
function gr { g rebase @args }
function gra { gr --abort @args }
function grc { gr --continue @args }
function grb {
    gr @(
        Get-GitFlags @args
        Get-GitBranchBase
        Get-GitArgs @args
    )
}
function grd {
    gr @(
        Get-GitFlags @args
        Get-GitBranchDev
        Get-GitArgs @args
    )
}
function grm {
    gr @(
        Get-GitFlags @args
        Get-GitBranchMain
        Get-GitArgs @args
    )
}
function gri { gr --interactive @args }
function grib {
    gri @(
        Get-GitFlags @args
        Get-GitBranchBase
        Get-GitArgs @args
    )
}
function grid {
    gri @(
        Get-GitFlags @args
        Get-GitBranchDev
        Get-GitArgs @args
    )
}
function grim {
    gri @(
        Get-GitFlags @args
        Get-GitBranchMain
        Get-GitArgs @args
    )
}

# git reset
function rs { g reset @args }
function rsb {
    rs @(
        Get-GitFlags @args
        Get-GitBranchBase
        Get-GitArgs @args
    )
}
function rsd {
    rs @(
        Get-GitFlags @args
        Get-GitBranchDev
        Get-GitArgs @args
    )
}
function rsm {
    rs @(
        Get-GitFlags @args
        Get-GitBranchMain
        Get-GitArgs @args
    )
}
function rsp { rs '@{push}' @args }
function rsu { rs '@{upstream}' @args }

# git cherry-pick
function gcp { g cherry-pick @args }
function gcpa { gcp --abort @args }
function gcpc { gcp --continue @args }
function gcps { gcp --skip @args }

function clone($Url) {
    # TODO: Support all URLs syntaxes - https://git-scm.com/docs/git-clone#_git_urls_a_id_urls_a
    if ($Url -notmatch '^(?:git@.*?:|https://.*?/)(?<path>.*?)(?:.git)?$') { throw 'Unsupported URL syntax' }
    $Directory = $Matches.path -replace '/', '_' # flatten path
    g clone -- $Url $Directory && Set-Location $Directory
}

function Get-GitFlags { git rev-parse --no-revs --flags @args }
function Get-GitRevs { git rev-parse --revs-only --symbolic @args }
function Get-GitArgs { git rev-parse --no-revs --no-flags @args }

function Get-GitBranchBase($Ref) {
    if (!$Ref -or $Ref -eq 'HEAD') { $Ref = Get-GitBranchCurrent }

    $Base = git config gitflow.branch.$Ref.base
    if ($Base) { return $Base }

    $Main = Get-GitBranchMain
    if ($Ref -eq $Main) { return $null }

    $Develop = Get-GitBranchDev
    if (!$Develop) { return $Main }
    if ($Develop -eq $Ref) { return $Main }

    return $Develop
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
    foreach ($Branch in $Names) {
        if (git branch --list $Branch) {
            return $Branch
        }
    }
}

function Get-GitChildItem {
    $Format = '| {0,-50} | {1,7} | {2,-25} | {3,-25} |'
    $Format -f 'Path', 'Commits', 'Oldest', 'Newest'
    $Format -f ":$('-' * 49)", "$('-' * 6):", ":$('-' * 23):", ":$('-' * 23):"
    git ls-tree --long --abbrev HEAD | ForEach-Object {
        $Line = $_ -split "`t"
        $File = $Line[1]
        $Data = $Line[0] -split ' +'
        $Type = $Data[1]

        # https://stackoverflow.com/a/11729072/88709
        $Commits = (git log --oneline -- $File | Measure-Object).Count

        # https://stackoverflow.com/a/13598028/88709
        $Oldest = git log --max-count=1 --format="%ai" --diff-filter=A -- $File

        # https://stackoverflow.com/a/4784629/88709
        $Newest = git log --max-count=1 --format="%ai" -- $File

        if ($Type -eq 'tree') { $File += '/' }
        $Format -f $File, $Commits, $Oldest, $Newest
    }
}

# Fix delta hyperlinks - https://github.com/dandavison/delta/issues/332#issuecomment-703149304
$env:DELTA_PAGER = 'less -rFX'

Set-Alias -Name 'gls' -Value 'Get-GitChildItem'
