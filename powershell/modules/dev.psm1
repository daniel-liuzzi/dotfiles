Import-Module $ProfileDir/modules/base
Import-Module $ProfileDir/modules/git

function Get-ReferenceGraph {
    # TODO: Parse SLN
    'digraph {'
    Get-ChildItem -Filter *.csproj -Recurse |
    ForEach-Object {
        $projectFile = $_ | Select-Object -ExpandProperty FullName
        $projectName = $_ | Select-Object -ExpandProperty BaseName
        $projectXml = [xml](Get-Content $projectFile)

        $projectReferences = $projectXml |
        Select-Xml '/Project/ItemGroup/ProjectReference' |
        Select-Object -ExpandProperty Node |
        Select-Object -ExpandProperty Include |
        ForEach-Object { ([IO.FileInfo]$_).BaseName }

        "    ""$projectName"";"
        $projectReferences | ForEach-Object {
            "    ""$projectName"" -> ""$_"";"
        }
    }
    '}'
}

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
        mkdir $Path | Out-Null
    }
    elseif (Get-ChildItem $Path -Force) {
        throw 'Error: Directory not empty'
    }

    Push-Location $Path

    git init
    git commit --allow-empty --allow-empty-message --no-edit

    dotnet new gitignore
    git add --all
    git commit --message="dotnet new gitignore"

    dotnet new console
    git add --all
    git commit --message="dotnet new console"

    edit . ./Program.cs

    Pop-Location
}

<#
.SYNOPSIS
    Creates a new dotnet solution with Core, CLI, and API projects, and opens it
    in the text editor.
#>
function New-Solution {
    param (
        [string]
        $Path = '.'
    )

    if (-not (Test-Path $Path)) {
        mkdir $Path | Out-Null
    }
    elseif (Get-ChildItem $Path -Force) {
        throw 'Error: Directory not empty'
    }

    Push-Location $Path
    dotnet new gitignore
    dotnet new sln

    $Name = Split-Path . -Leaf

    mkdir "$Name.Core" | Push-Location
    dotnet new classlib @args
    dotnet sln .. add .
    Pop-Location

    mkdir "$Name.Cli" | Push-Location
    dotnet new console @args
    dotnet add reference "../$Name.Core"
    dotnet sln .. add .
    Pop-Location

    mkdir "$Name.Api" | Push-Location
    dotnet new webapi --no-https @args
    dotnet add reference "../$Name.Core"
    dotnet sln .. add .
    Pop-Location

    mkdir "$Name.Api.Tests" | Push-Location
    dotnet new xunit @args
    dotnet add reference "../$Name.Api"
    dotnet sln .. add .
    Pop-Location

    edit .

    Pop-Location
}

# dotnet
function dn { run dotnet @args }
function dna { dn add @args }
function dnap { dna package @args }
function dnar { dna reference @args }
function dnb { dn build @args }
function dnc { dn clean @args }
function dnf { dn format @args }
function dnl { dn list @args }
function dnlp { dnl package @args }
function dnlr { dnl reference @args }
function dnn { dn new @args }
function dnr { dn run @args }
function dnrm { dn remove @args }
function dnrmp { dnrm package @args }
function dnrmr { dnrm reference @args }
function dns { dn search @args }
function dnt { dn test @args }
function dnw { dn watch @args }
function dnwr { dnw run @args }

# misc.

function dob { Get-ChildItem bin, obj -Directory -Recurse | Remove-Item -Force -Recurse }

# PowerShell parameter completion shim for the dotnet CLI
Register-ArgumentCompleter -Native -CommandName dotnet -ScriptBlock {
    param($commandName, $wordToComplete, $cursorPosition)
    dotnet complete --position $cursorPosition "$wordToComplete" | ForEach-Object {
        [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterValue', $_)
    }
}

function Start-File($Filter) {
    $Path = `
        Get-ChildItem -Filter $Filter -Recurse -Depth 1 -File | `
        Select-Object -First 1 | `
        Resolve-Path -Relative

    if (!$Path) { return Write-Error "No $Filter files found" }
    run start $Path
}

function Start-Project { Start-File *.*proj }

function Start-Solution { Start-File *.sln }

Set-Alias -Name 'console' -Value 'New-ConsoleApp'
Set-Alias -Name 'e' -Value 'edit'
Set-Alias -Name 'edit' -Value 'code'
Set-Alias -Name 'proj' -Value 'Start-Project'
Set-Alias -Name 'sln' -Value 'Start-Solution'
Set-Alias -Name 'wm' -Value 'winmergeu'
