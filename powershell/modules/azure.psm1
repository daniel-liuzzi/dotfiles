$AzureCli = Get-Command 'az'

function Invoke-AzureCli { & $AzureCli @args | jq -C }

Set-Alias -Name 'az' -Value 'Invoke-AzureCli'
