Import-Module Recycle

# We need to wrap this in a function because otherwise we get an `Alias is not
# writeable because alias ri is read-only or constant and cannot be written to.`
# error.
function Initialize-RecycleAliases {
    Set-Alias -Name 'del' -Value 'Remove-ItemSafely' -Option AllScope
    Set-Alias -Name 'erase' -Value 'Remove-ItemSafely' -Option AllScope
    Set-Alias -Name 'rd' -Value 'Remove-ItemSafely' -Option AllScope
    Set-Alias -Name 'ri' -Value 'Remove-ItemSafely' -Option AllScope -Force
    Set-Alias -Name 'rm' -Value 'Remove-ItemSafely' -Option AllScope
    Set-Alias -Name 'rmdir' -Value 'Remove-ItemSafely' -Option AllScope
}

Initialize-RecycleAliases
