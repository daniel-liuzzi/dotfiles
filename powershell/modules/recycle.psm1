Get-Alias -Definition 'Remove-Item' -ErrorAction SilentlyContinue | ForEach-Object {
    Set-Alias `
        -Name $_.Name `
        -Value 'Remove-ItemSafely' `
        -Option AllScope `
        -Scope Global `
        -Force
}
