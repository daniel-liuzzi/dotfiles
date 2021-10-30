# Oh my Posh
$env:POSH_SESSION_DEFAULT_USER = $env:USERNAME # Hide default user@host
Set-PoshPrompt -Theme "$Root/oh-my-posh/daniel.omp.json"

# Workaround for weird bug when using -NoLogo
# https://github.com/microsoft/terminal/issues/8341#issuecomment-917650188
Clear-Host
