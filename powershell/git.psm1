Import-Module $ProfileDir/base

function Test-Wips {
    if (quietly lp --grep='^WIP$' 2> $null) {
        throw 'WIP commits found. Aborting...'
    }
}

function g { run git @args }
function a { g add @args }
function aa { a --all @args }
function ancestry {
    $Ref = Get-GitRevs @args
    if (!$Ref) { $Ref = 'HEAD' }
    l @(
        '--all'
        '--ancestry-path'
        '--graph'
        Get-GitFlags @args
        "$Ref.."
        Get-GitArgs @args
    )
}
function b { g branch @args }
function c { g commit @args }
function ca { c --amend @args }
function can { ca --no-edit @args }
function cl { g clean -d --force --interactive @args }
function cn { c --no-edit @args }
function dt { g difftool @args } # allows "Alt+Right", but diff one file at a time
function dtd { dt --dir-diff @args } # diffs all files, but no "Alt+Right"
function f { g fetch @args }
function init { g init; cn --allow-empty --allow-empty-message @args }
function mt { g mergetool @args }
function pull { Test-Wips; g pull @args }
function push { Test-Wips; g push @args }
function s { g status @args }
function show { g show @args }
function sw { show @args }
function sync { pull; push }
function tag { g tag @args }
function undo { rs HEAD^ @args }
function wip { aa; c --message=WIP }

# git worktree
function w { g worktree @args }
function wa {
    $Ref = Get-GitRevs @args
    if (!$Ref) { $Ref = 'HEAD' }
    w add "../$(Split-Path $PWD -Leaf)_worktrees/$Ref" $Ref
}
function wl { w list @args }
function wr { w remove @args }

function unwip {
    if (quietly sw --grep='^WIP$' --invert-grep) { throw 'Nothing to unwip.' }
    undo
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
function ln_($number) { lr --max-count=$number @args }
function l1 { ln_ 1 @args }
function l5 { ln_ 5 @args }
function l9 { ln_ 9 @args }
function l19 { ln_ 29 @args }
function l49 { ln_ 49 @args }
function l99 { ln_ 99 @args }
function l { g log --boundary --pretty=s @args }
function lr { l --reverse @args }
function lb {
    $Ref = Get-GitRevs @args
    if (!$Ref) { $Ref = 'HEAD' }
    lr @(
        Get-GitFlags @args
        "$(Get-GitBranchBase $Ref)..$Ref"
        Get-GitArgs @args
    )
}
function lba {
    $Ref = Get-GitRevs @args
    if (!$Ref) { $Ref = 'HEAD' }
    lr @(
        Get-GitFlags @args
        "$(Get-GitBranchBase $Ref)...$Ref"
        Get-GitArgs @args
    )
}
function ld { lr "$(Get-GitBranchDev)..HEAD" @args }
function lda { lr "$(Get-GitBranchDev)...HEAD" @args }
function lm { lr "$(Get-GitBranchMain)..HEAD" @args }
function lma { lr "$(Get-GitBranchMain)...HEAD" @args }
function lp { lr '@{push}..HEAD' @args }
function lpa { lr '@{push}...HEAD' @args }
function lu { lr '@{upstream}..HEAD' @args }
function lua { lr '@{upstream}...HEAD' @args }

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
function gmp { gm_ '@{push}' @args }
function gmu { gm_ '@{upstream}' @args }

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
function grp { gr '@{push}' @args }
function gru { gr '@{upstream}' @args }

# git recent
function r_ { g recent @args }
function rn($number) { r_ "-n$number" @args }
function r1 { rn 1 @args }
function r5 { rn 5 @args }
function r9 { rn 9 @args }
function r19 { rn 29 @args }
function r49 { rn 49 @args }
function r99 { rn 99 @args }

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

# git absorb
# scoop install https://raw.githubusercontent.com/studoot/my-scoop-bucket/master/bucket/git-absorb.json
function ga { g absorb @args }
function gab { ga --base (Get-GitBranchBase) @args }
function gabr { gab --and-rebase @args }

# git cherry-pick
function gcp { g cherry-pick @args }
function gcpa { gcp --abort @args }
function gcpc { gcp --continue @args }
function gcps { gcp --skip @args }

function clone($Url) {
    # TODO: Support all URLs syntaxes - https://git-scm.com/docs/git-clone#_git_urls_a_id_urls_a
    if ($Url -notmatch '^(?:git@.*?:|https://.*?/)(?<path>.*?)(?:.git)?$') { throw 'Unsupported URL syntax' }
    $Directory = $Matches.path -replace '/', '_' # flatten path
    g clone -- $Url $Directory
    Set-Location $Directory
}

# These three don't always work as expected. For instance `lb -3` generates
# `git log --pretty=s --reverse develop..-3` which results in `ambiguous
# argument 'develop..-3'`. This happens because flags like -3, -n3, or even
# --max-count=3 *are all valid revs* and as such they get picked up by
# Get-GitRevs and not Get-GitFlags.
function Get-GitFlags { git rev-parse --no-revs --flags @args }
function Get-GitRevs { git rev-parse --revs-only --symbolic @args }
function Get-GitArgs { git rev-parse --no-revs --no-flags @args }

function Get-GitBranchBase($Ref) {
    if (!$Ref -or $Ref -eq 'HEAD') { $Ref = Get-GitBranchCurrent }

    $Base = git config gitflow.branch.$Ref.base
    if ($Base) { return $Base }

    $Main = Get-GitBranchMain
    if ($Ref -eq $Main) { return Get-GitEmptyTree }

    $Develop = Get-GitBranchDev
    if (!$Develop) { return $Main }
    if ($Develop -eq $Ref) { return $Main }

    return $Develop
}

function Get-GitBranchCurrent {
    git branch --show-current
}
function Get-GitBranchDev {
    Find-GitBranch (@(git config gitflow.branch.develop) + $Global:DotfilesOptions.Git.Dev)
}
function Get-GitBranchMain {
    Find-GitBranch (@(git config gitflow.branch.master) + $Global:DotfilesOptions.Git.Main)
}

function Find-GitBranch($Names) {
    foreach ($Branch in $Names) {
        if (git branch --list $Branch) {
            return $Branch
        }
    }
}

function Get-GitChildItem {
    $Ref = Get-GitRevs @args
    if (!$Ref) { $Ref = 'HEAD' }

    git @(
        'ls-tree'
        '--long'
        Get-GitFlags @args
        $Ref
        Get-GitArgs @args
    ) | ForEach-Object {
        $Data, $File = $_ -split "`t"
        $Mode, $Type, $Object, $Size = $Data -split ' +'

        if ($Type -eq 'tree') { $File += '/' }
        if ($Size -eq '-') { $Size = $null }
        $OldestRef, $OldestRefDate = (git log --max-count=1 --format="%h`t%ai" --diff-filter=A -- $File) -split "`t"
        $NewestRef, $NewestRefDate = (git log --max-count=1 --format="%h`t%ai" -- $File) -split "`t"

        [PSCustomObject]@{
            PSTypeName    = 'GitChildItem'
            Path          = $File
            Size          = [Nullable[long]]$Size
            Authors       = [Nullable[long]](git shortlog --numbered --summary -- $File | Measure-Object).Count
            Commits       = [Nullable[long]](git log --oneline -- $File | Measure-Object).Count
            OldestRef     = $OldestRef
            OldestRefDate = [Nullable[DateTimeOffset]]$OldestRefDate
            NewestRef     = $NewestRef
            NewestRefDate = [Nullable[DateTimeOffset]]$NewestRefDate
        }
    }
}

function Get-GitEmptyTree { $null | git mktree }

Set-Alias -Name 'gls' -Value 'Get-GitChildItem'
