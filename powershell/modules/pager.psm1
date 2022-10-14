# scoop install bat less

function Get-ContentColorized { run bat --paging=never @args }

@('cat', 'gc', 'type') | ForEach-Object {
    Set-Alias -Name $_ -Value 'Get-ContentColorized' -Option AllScope -Scope Global -Force
}

$env:BAT_OPTS = @(
    '--map-syntax="[Aa]pp.config:XML"'
    '--map-syntax="[Ww]eb.config:XML"'
    '--map-syntax="*.??proj:XML"'
    '--map-syntax="packages.config:XML"'
    '--style=full'
    '--theme="Solarized (dark)"'
    '--wrap=never'
)

# https://git-scm.com/docs/git-config/2.37.2#Documentation/git-config.txt-corepager
$env:LESS = @(
    '--chop-long-lines'         # -S    Truncate long lines rather than wrapping
    '--IGNORE-CASE'             # -I    Ignore case in all searches
    '--no-init'                 # -X    Don't use termcap init/deinit strings
    '--quit-if-one-screen'      # -F    Quit if entire file fits on first screen
    ##'--raw-control-chars'     # -r    Output "raw" control characters (Breaks --chop-long-lines)
    '--shift=4'                 # -#    Set horizontal scroll amount (0 = one half screen width)
    '--tilde'                   # -~    Don't display tildes after end of file
)

# Better pager for commands that respect it, i.e., `help`
# https://github.com/PowerShell/PowerShell/blob/158d3a64e9c6edabb77070074686b8a75027a8a5/src/System.Management.Automation/engine/InitialSessionState.cs#L4173
$env:PAGER = 'less'
