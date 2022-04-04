function archive {
    # TODO: delete node_modules, bin, obj recursively
    $Date = Get-Date -Format 'yyyy-MM-dd'
    $Path = Join-Path '~/.archive' $Date
    New-Item -Path $Path -ItemType Directory -Force | Out-Null
    Get-ChildItem -Path '~/Desktop' -Recurse -Force | Move-Item -Destination $Path | Out-Null
    Write-Output 'Desktop archived successfully.'
    Start-Process -FilePath (Resolve-Path $Path)
}
