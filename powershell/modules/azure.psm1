$AzureCli = Get-Command 'az'

function Invoke-AzureCli {
    & $AzureCli @args | jq @(
        if ($MyInvocation.PipelinePosition -eq $MyInvocation.PipelineLength) { '-C' }
    )
}

Set-Alias -Name 'az' -Value 'Invoke-AzureCli'
