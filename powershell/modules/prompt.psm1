oh-my-posh init pwsh --config "$Root/oh-my-posh/daniel.omp.json" | Invoke-Expression

function Set-EnvironmentVariables {
    $env:HEAD_REV = git rev-parse --short HEAD
}

New-Alias -Name Set-PoshContext -Value Set-EnvironmentVariables -Scope Global -Force
