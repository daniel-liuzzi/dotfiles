param (
    $Distro = 'Ubuntu-26.04',

    [switch]
    $Force = $false
)

$WSL_UTF8 = $env:WSL_UTF8
$env:WSL_UTF8 = 1
$DistroExists = (wsl --list --quiet) -contains $Distro
$env:WSL_UTF8 = $WSL_UTF8

if ($DistroExists -and -not $Force) {
    Write-Host "Distro '$Distro' already exists. Skipping installation."
    exit 0
}

$Username = $env:USERNAME
$Password = Read-Host 'Enter new WSL password' -AsSecureString

$DistrosPath = "$PSScriptRoot/distros"
$DistroPath = "$DistrosPath/$Distro"
$CachePath = "$DistrosPath/_cache"
$ManifestPath = "$CachePath/_manifest.json"
$ImagePath = "$CachePath/$Distro.wsl"

curl.exe `
    --create-dirs `
    --location `
    --output $ManifestPath `
    --remote-time `
    --silent `
    --skip-existing `
    'https://raw.githubusercontent.com/microsoft/WSL/refs/heads/master/distributions/DistributionInfo.json'

$Manifest = Get-Content $ManifestPath | ConvertFrom-Json
$DistroDetails = $Manifest.ModernDistributions.PSObject.Properties.Value | ? Name -eq $Distro
$Download = $DistroDetails."${env:PROCESSOR_ARCHITECTURE}Url"

curl.exe `
    --create-dirs `
    --location `
    --output $ImagePath `
    --remote-time `
    --skip-existing `
    $Download.Url

$ExpectedHash = $Download.Sha256
$ActualHash = (Get-FileHash $ImagePath).Hash
if ($ActualHash -ne $ExpectedHash) {
    Write-Error "Hash mismatch: expected $ExpectedHash, got $ActualHash"
    exit 1
}

wsl --unregister $Distro *>$null

wsl --install `
    --from-file $ImagePath `
    --location $DistroPath `
    --name $Distro `
    --no-launch

wsl --set-default $Distro *>$null

wsl bash -c @"
    wget --output-document=- --quiet https://apt.fury.io/nushell/gpg.key | gpg --dearmor --output /etc/apt/keyrings/fury-nushell.gpg
    echo "deb [signed-by=/etc/apt/keyrings/fury-nushell.gpg] https://apt.fury.io/nushell/ /" > /etc/apt/sources.list.d/fury-nushell.list
    DEBIAN_FRONTEND=noninteractive apt-get update --quiet=2
    DEBIAN_FRONTEND=noninteractive apt-get upgrade --quiet=2 --yes
    DEBIAN_FRONTEND=noninteractive apt-get install --quiet=2 nushell

    useradd --create-home --groups sudo --shell /bin/bash $Username
    echo "${Username}:${Password}" | sudo chpasswd
"@

wsl --manage $Distro --set-default-user $Username *>$null

wsl bash -c @"
    # supress WSL first login message and telemetry prompt
    ubuntu-insights consent wsl_setup --state=false 2>/dev/null

    # supress login message
    touch ~/.hushlogin

    git clone https://github.com/daniel-liuzzi/dotfiles.git ~/Projects/dotfiles

    # auto launch Nu for interactive shells
    echo '[ -t 1 ] && exec nu' >> ~/.bashrc
"@

wsl nu --login -c @'
    # scaffold Nu config files
    config reset --without-backup

"
# https://www.nushell.sh/book/configuration.html#quickstart
\$env.config.buffer_editor = ["code", "--wait"]

# https://www.nushell.sh/book/configuration.html#remove-welcome-message
\$env.config.show_banner = false

cd ~
" | save --append \$nu.config-path
'@
