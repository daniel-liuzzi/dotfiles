using namespace Microsoft.PowerShell

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

# # Temporarily disabled as it sometimes leaves the screen buffer dirty
# # https://www.reddit.com/r/PowerShell/comments/a2hs0i/comment/eb3m6hf/?utm_source=share&utm_medium=web2x&context=3
# Set-PSReadlineKeyHandler `
#     -Chord 'Enter' `
#     -BriefDescription 'UpdatePromptAndAccept' `
#     -LongDescription 'Update the prompt to display the current time then accept the line' `
#     -ScriptBlock {
#         [PSConsoleReadLine]::InvokePrompt()
#         [PSConsoleReadLine]::AcceptLine()
#     }
