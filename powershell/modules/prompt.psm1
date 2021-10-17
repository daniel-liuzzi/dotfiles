Import-Module cd-extras
Import-Module posh-git

# posh-git
$GitPromptSettings.DefaultPromptAbbreviateGitDirectory = $true
$GitPromptSettings.DefaultPromptAbbreviateHomeDirectory = $true

# Oh my Posh
$env:POSH_SESSION_DEFAULT_USER = $env:USERNAME # Hide default user@host
Set-PoshPrompt -Theme "$Root/oh-my-posh/daniel.omp.json"
function Set-PoshContext { $env:TITLE = Get-PromptPath }
