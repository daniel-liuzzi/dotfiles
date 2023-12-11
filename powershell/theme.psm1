<#
  .SYNOPSIS
  Switch apps and system color themes.

  .DESCRIPTION
  Omitting both parameters will toggle between dark and light themes.
#>
function Set-Theme {
    [CmdletBinding(DefaultParameterSetName = 'toggle')]
    param (
        # Switch to dark color scheme.
        [parameter(ParameterSetName = 'dark')]
        [switch]
        $Dark,

        # Switch to light color scheme.
        [parameter(ParameterSetName = 'light')]
        [switch]
        $Light
    )

    $Key = 'HKCU:/SOFTWARE/Microsoft/Windows/CurrentVersion/Themes/Personalize'

    $OldIsLight = [bool](Get-ItemProperty -Path $Key).SystemUsesLightTheme
    $NewIsLight = if ($Dark -or $Light) { !$Dark } else { !$OldIsLight }
    if ($NewIsLight -eq $OldIsLight) { return }

    Set-ItemProperty -Path $Key -Name 'AppsUseLightTheme' -Value $NewIsLight
    Set-ItemProperty -Path $Key -Name 'SystemUsesLightTheme' -Value $NewIsLight
}

Set-Alias -Name 'theme' -Value 'Set-Theme'
