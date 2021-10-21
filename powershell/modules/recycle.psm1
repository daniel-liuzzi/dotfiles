Get-Alias -Definition 'Remove-Item' | ForEach-Object {
    Set-Alias `
        -Name $_.Name `
        -Value 'Remove-ItemSafely' `
        -Option AllScope `
        -Scope Global `
        -Force
}
