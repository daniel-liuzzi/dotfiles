<#
  .SYNOPSIS
  Get public IP
#>
function Get-MyIp {
    Invoke-RestMethod 'https://ident.me/'
}

Set-Alias -Name 'ip' -Value 'Get-MyIp'
