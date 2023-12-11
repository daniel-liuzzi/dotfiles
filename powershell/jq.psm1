$OldJq = Get-Command 'jq'

function Invoke-Jq {
    param(
        [parameter(ValueFromPipeline)] $InputObject,
        [Parameter(ValueFromRemainingArguments = $true)] [Object[]] $Rest
    )

    begin { $objects = @() }
    process { $objects += $InputObject }
    end {
        if ($MyInvocation.PipelinePosition -eq $MyInvocation.PipelineLength) {
            $Rest = @('-C') + $Rest
        }
        $objects | & $OldJq $Rest
    }
}

Set-Alias -Name 'jq' -Value 'Invoke-Jq'
