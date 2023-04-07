if ($PSVersionTable.PSEdition -eq 'Core') {
    Import-Module Az.Tools.Predictor -Global
}

@(
    @{ Key = 'UpArrow'; Function = 'PreviousHistory' }
    @{ Key = 'DownArrow'; Function = 'NextHistory' }
    @{ Key = 'Tab', 'Shift+Tab'; Function = 'MenuComplete' }
) | % { Set-PSReadLineKeyHandler @_ }

Set-PSReadLineOption `
    -EditMode Windows `
    -PredictionViewStyle ListView `
    -WordDelimiters ' /\' `
