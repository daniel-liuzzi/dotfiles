@('ri', 'rm', 'rmdir', 'del', 'erase', 'rd') | ForEach-Object {
    Set-Alias -Name $_ -Value 'Remove-ItemSafely' -Option AllScope -Scope Global -Force
}
