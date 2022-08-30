# scoop install bat less

function Invoke-Bat { run bat @args }

Set-Alias -Name cat -Value Invoke-Bat -Option AllScope -Scope Global

$env:BAT_OPTS = @(
    '--style=full'
    '--wrap=never'
)

# https://git-scm.com/docs/git-config/2.37.2#Documentation/git-config.txt-corepager
$env:LESS = @(
    '--chop-long-lines'
    '--clear-screen'
    '--IGNORE-CASE'
    # '--no-init' # spams stdout
    '--quit-if-one-screen'
    # '--raw-control-chars' # breaks --chop-long-lines
    '--shift=4'
    '--tilde'
)

# Better pager for commands that respect it, i.e., `help`
# https://github.com/PowerShell/PowerShell/blob/158d3a64e9c6edabb77070074686b8a75027a8a5/src/System.Management.Automation/engine/InitialSessionState.cs#L4173
$env:PAGER = 'less'
