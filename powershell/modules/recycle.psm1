Import-Module Recycle

Set-Alias -Name 'del' -Value 'Remove-ItemSafely' -Option AllScope -Scope Global
Set-Alias -Name 'erase' -Value 'Remove-ItemSafely' -Option AllScope -Scope Global
Set-Alias -Name 'rd' -Value 'Remove-ItemSafely' -Option AllScope -Scope Global
Set-Alias -Name 'ri' -Value 'Remove-ItemSafely' -Option AllScope -Force -Scope Global
Set-Alias -Name 'rm' -Value 'Remove-ItemSafely' -Option AllScope -Scope Global
Set-Alias -Name 'rmdir' -Value 'Remove-ItemSafely' -Option AllScope -Scope Global
