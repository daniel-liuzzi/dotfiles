function Register-RabbitMq { run rabbitmq-service install }

function Start-RabbitMq { run rabbitmq-service start }

function Stop-RabbitMq { run rabbitmq-service stop }

function Unregister-RabbitMq { run rabbitmq-service remove }

function Remove-RabbitMq { run Remove-Item HKLM:\SOFTWARE\Ericsson\Erlang\ErlSrv\1.1\RabbitMQ\ -Recurse -ErrorAction Ignore }

<#
  .SYNOPSIS
  (Re)registers RabbitMQ service. Useful when Erlang updates break it.
#>
function Repair-RabbitMq {
    Invoke-Expression "
        ${Function:Stop-RabbitMq}
        ${Function:Unregister-RabbitMq}
        ${Function:Remove-RabbitMq}
        ${Function:Register-RabbitMq}
        ${Function:Start-RabbitMq}
    "
}

function ra { run rabbitmqadmin @args }

function ral { ra list @args }

function ralq { ral queues @args }

<#
  .SYNOPSIS
  Purges all RabbitMQ queues, with optional filtering.
#>
function Clear-RabbitMqQueues([string] $Filter) {
    $PurgeQueue = {
        rabbitmqadmin purge queue name=$_ > $null
        '{0,-50} queue purged' -f $_
    }

    # PowerShell Core purges queues ~10x faster
    $Arguments = if ($PSVersionTable.PSEdition -eq 'Core') {
        @{ Parallel = $PurgeQueue; ThrottleLimit = 99 }
    }
    else {
        @{ Process = $PurgeQueue }
    }

    (rabbitmqadmin --format bash list queues).Split() `
        | Where-Object { $_ -match $Filter } `
        | ForEach-Object @Arguments
}

Set-Alias -Name 'rap' -Value 'Clear-RabbitMqQueues'
