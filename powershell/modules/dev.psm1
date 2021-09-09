Import-Module $ProfileDir/modules/base
Import-Module $ProfileDir/modules/git

<#
.SYNOPSIS
    Creates a new dotnet console app and opens it in the text editor.
#>
function New-ConsoleApp {
    param (
        [string]
        $Path = '.'
    )

    if (-not (Test-Path $Path)) {
        mkdir $Path
    }
    elseif (Get-ChildItem $Path -Force) {
        throw 'Error: Directory not empty'
    }

    Set-Location $Path

    git init
    git commit --message="initial" --allow-empty

    dotnet new gitignore
    git add --all
    git commit --message="dotnet new gitignore"

    dotnet new console
    git add --all
    git commit --message="dotnet new console"

    edit . ./Program.cs
}

# dotnet
function dn { run dotnet @args }
function dna { dn add @args }
function dnap { dna package @args }
function dnar { dna reference @args }
function dnb { dn build @args }
function dnc { dn clean @args }
function dnl { dn list @args }
function dnlp { dnl package @args }
function dnlr { dnl reference @args }
function dnn { dn new @args }
function dnr { dn run @args }
function dnrm { dn remove @args }
function dnrmp { dnrm package @args }
function dnrmr { dnrm reference @args }
function dns { dn search @args }
function dnw { dn watch @args }
function dnwr { dnw run @args }

# misc.

function dob { Get-ChildItem bin, obj -Directory -Recurse | Remove-Item -Force -Recurse }

function sln {
    $Path = Get-ChildItem *.sln -Recurse -Depth 1 -File | Select-Object -First 1
    if ($Path) {
        Write-Output "Starting $Path"
        Start-Process $Path
    }
    else {
        Write-Error 'Solution file not found'
    }
}

# PowerShell parameter completion shim for the dotnet CLI
Register-ArgumentCompleter -Native -CommandName dotnet -ScriptBlock {
    param($commandName, $wordToComplete, $cursorPosition)
    dotnet complete --position $cursorPosition "$wordToComplete" | ForEach-Object {
        [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterValue', $_)
    }
}

Set-Alias -Name 'console' -Value 'New-ConsoleApp'
Set-Alias -Name 'e' -Value 'edit'
Set-Alias -Name 'edit' -Value 'code-insiders'
Set-Alias -Name 'wm' -Value 'winmergeu'
