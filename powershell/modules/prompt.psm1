oh-my-posh init pwsh --config "$Root/oh-my-posh/daniel.omp.json" | Invoke-Expression

# Workaround for weird bug when using -NoLogo
# https://github.com/microsoft/terminal/issues/8341#issuecomment-917650188
Clear-Host
