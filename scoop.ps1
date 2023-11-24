# Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser -Force
# irm scoop.liuzzi.net | iex

# Scoop
if (Get-Command -Name 'scoop' -ErrorAction Ignore) {
    Write-Host 'Scoop is already installed.' -ForegroundColor Green
} else {
    Write-Host 'Installing Scoop ...'
    irm get.scoop.sh | iex
    Write-Host 'Scoop has been installed.' -ForegroundColor Green
}

# Git
if (scoop list 6> $null | where Name -EQ git) {
    Write-Host 'Git is already installed.' -ForegroundColor Green
} else {
    Write-Host 'Installing Git ...'
    scoop install git
    Write-Host 'Git has been installed.' -ForegroundColor Green
}

# Buckets
$DesiredBuckets = @(
    'extras'
    'main'
    'nerd-fonts'
    'versions'
)
$InstalledBuckets = scoop bucket list
$MissingBuckets = $DesiredBuckets | where { $_ -notin $InstalledBuckets.Name }
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
