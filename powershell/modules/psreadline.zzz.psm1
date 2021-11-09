# psreadline overrides
Set-PSReadLineKeyHandler -Key 'UpArrow' -Function 'PreviousHistory'
Set-PSReadLineKeyHandler -Key 'DownArrow' -Function 'NextHistory'
Set-PSReadLineKeyHandler -Key 'Tab', 'Shift+Tab' -Function 'MenuComplete'
Set-PSReadLineOption -EditMode Windows
Set-PSReadLineOption -PredictionSource History
Set-PSReadLineOption -PredictionViewStyle ListView
Set-PSReadLineOption -WordDelimiters ' '
