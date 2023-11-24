# Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser -Force
# irm raw.githubusercontent.com/daniel-liuzzi/dotfiles/feat/improve-installer/scoop/install.ps1 | iex

$ErrorActionPreference = 'Stop'

# Scoop
if (Get-Command -Name 'scoop' -ErrorAction Ignore) {
    Write-Host 'Scoop is already installed.' -ForegroundColor Green
} else {
    Write-Host 'Installing Scoop ...'
    irm get.scoop.sh | iex
    Write-Host 'Scoop has been installed.' -ForegroundColor Green
}

# Git (for adding buckets)
if (scoop list 6> $null | where Name -EQ git) {
    Write-Host 'Git is already installed.' -ForegroundColor Green
} else {
    Write-Host 'Installing Git ...'
    scoop install git
    Write-Host 'Git has been installed.' -ForegroundColor Green
}

# Add buckets
$DesiredBuckets = @(
    'extras'
    'main'
    'nerd-fonts'
    'versions'
)
$InstalledBuckets = scoop bucket list | select -ExpandProperty Name
$MissingBuckets = $DesiredBuckets | where { $_ -notin $InstalledBuckets }
if ($MissingBuckets) {
    Write-Host 'Adding buckets ...'
    $MissingBuckets | foreach {
        Write-Host "- $_ ..."
        scoop bucket add $_ *> $null
        if ($LASTEXITCODE) { throw "Failed to add bucket '$_'." }
    }
    Write-Host 'All buckets have been added.' -ForegroundColor Green
} else {
    Write-Host 'All buckets are already added.' -ForegroundColor Green
}

$DesiredApps = @(
    'https://raw.githubusercontent.com/ScoopInstaller/Main/45371c57c7e00022d8b161f259b7eb79a95b282c/bucket/erlang.json'             # erlang 25.3.2 (rabbitmq 3.11.17 dep.)
    'https://raw.githubusercontent.com/ScoopInstaller/Versions/ea61ddd649414b30bb679f7435ffb4f0ad1f0446/bucket/python27.json'       # python27 2.7.18 (rabbitmqadmin 3.8.9 dep.)
    'https://raw.githubusercontent.com/ScoopInstaller/Extras/d2e48ea23c824b1667484d8f92ad7b39e937c96a/bucket/rabbitmq.json'         # rabbitmq 3.11.17
    'https://raw.githubusercontent.com/ScoopInstaller/Extras/95b63cc3b26a2872bd922ec7005f767a499f439c/bucket/rabbitmqadmin.json'    # rabbitmqadmin 3.8.9
    'https://raw.githubusercontent.com/ScoopInstaller/Main/22bff7afc5b8987c0f213f1f5943948b91db1957/bucket/redis.json'              # redis 5.0.14.1
    'autohotkey'
    'aws'
    'bat'
    'bottom'
    'dbeaver'
    'delta'
    'dockercompletion'
    'git'
    'graphviz'
    'hadolint'
    'hxd'
    'ilspy'
    'jq'
    'less'
    'Meslo-NF'
    'ntop'
    'nvm'
    'oh-my-posh'
    'oracle-instant-client'
    'pasteboard'
    'powertoys'
    'pwsh'
    'px'
    'sqlite'
    'sudo'
    'usql'
    'vscode'
    'vswhere'
    'windows-terminal'
    'yq'
    'z'
)
$InstalledApps = scoop list 6> $null | foreach { if ($_.Source.Contains('://')) { $_.Source } else { $_.Name } }
$MissingApps = $DesiredApps | where { $_ -notin $InstalledApps }
if ($MissingApps) {
    Write-Host 'Installing apps ...'
    $MissingApps | foreach {
        Write-Host "- $_ ..."
        scoop install $_
        if ($LASTEXITCODE) { throw "Failed to install app '$_'." }
    }
    Write-Host 'All apps have been installed.' -ForegroundColor Green
} else {
    Write-Host 'All apps are already installed.' -ForegroundColor Green
}
