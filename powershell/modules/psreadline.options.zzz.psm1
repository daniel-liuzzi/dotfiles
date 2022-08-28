if ($PSVersionTable.PSEdition -eq 'Core') {
    Import-Module Az.Tools.Predictor -Global
}

# psreadline overrides
Set-PSReadLineKeyHandler -Key 'UpArrow' -Function 'PreviousHistory'
Set-PSReadLineKeyHandler -Key 'DownArrow' -Function 'NextHistory'
Set-PSReadLineKeyHandler -Key 'Tab', 'Shift+Tab' -Function 'MenuComplete'
Set-PSReadLineOption -EditMode Windows
Set-PSReadLineOption -PredictionViewStyle ListView
Set-PSReadLineOption -WordDelimiters ' /\'
