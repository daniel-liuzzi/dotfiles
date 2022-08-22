oh-my-posh init pwsh --config "$Root/oh-my-posh/daniel.omp.json" | Invoke-Expression

function Set-EnvironmentVariables {
    $RepoPath = git rev-parse --show-toplevel
    $env:REPO_NAME = if ($RepoPath) { [System.IO.Path]::GetFileName($RepoPath) }
    $env:HEAD_REV = git rev-parse --short HEAD
}

New-Alias -Name Set-PoshContext -Value Set-EnvironmentVariables -Scope Global -Force
