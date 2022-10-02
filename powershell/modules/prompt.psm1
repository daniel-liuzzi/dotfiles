oh-my-posh init pwsh --config "$Root/oh-my-posh/minimal.omp.json" | Invoke-Expression

function Set-EnvironmentVariables {
    $env:HEAD_REV = git rev-parse --short HEAD
}

New-Alias -Name Set-PoshContext -Value Set-EnvironmentVariables -Scope Global -Force
