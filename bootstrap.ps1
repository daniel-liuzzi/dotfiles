if (Test-Path ~\.gitconfig) {
    Move-Item -Path ~\.gitconfig -Destination ~\.gitconfig.bak -Force
}

New-Item -ItemType SymbolicLink -Path ~\.gitconfig -Target .\.gitconfig
