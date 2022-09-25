Import-Module $ProfileDir/modules/base
Import-Module $ProfileDir/modules/git

function Get-SlnReferences($Path = $PWD.ProviderPath) {
    $Sln = Get-Item $Path
    $SlnPath = if ($Sln.DirectoryName) { $Sln.DirectoryName } else { $Sln.FullName }

    dotnet sln $Path list | Select-String 'proj$' | Sort-Object | ForEach-Object {
        $Project = Join-Path $SlnPath $_ | Get-Item
        [PSCustomObject][ordered]@{
            Project    = $Project.BaseName
            References = dotnet list $Project reference | Select-String 'proj$' | Sort-Object | ForEach-Object {
                $Reference = Join-Path $Project.Directory $_ | Get-Item
                $Reference.BaseName
            }
        }
    }
}

function Get-SlnReferencesGraph($Path = $PWD.ProviderPath) {
    $Projects = Get-SlnReferences $Path
    $Graph = @(
        'digraph {'
        $Projects | ForEach-Object { '    "{0}";' -f $_.Project }
        $Projects | ForEach-Object {
            if (!$_.References) { return }
            $Project = $_.Project
            $_.References | ForEach-Object {
                '    "{0}" -> "{1}";' -f $Project, $_
            }
        }
        '}'
    )

    $TempFile = "$(New-TemporaryFile).svg"
    $Graph | dot -T svg -o $TempFile # scoop install graphviz
    Start-Process $TempFile -Wait
    Remove-Item $TempFile
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
    dotnet new sln
    dotnet new editorconfig

    Set-Content Directory.Build.props @(
        '<Project>'
        '    <PropertyGroup>'
        '        <AssemblyName>$(SolutionName).$(MSBuildProjectName)</AssemblyName>'
        '        <RootNamespace>$(AssemblyName.Replace(" ", "_"))</RootNamespace>'
        '        <Deterministic>true</Deterministic>'
        '    </PropertyGroup>'
        '</Project>'
    )

    mkdir Core | Push-Location
    dotnet new classlib @args
    Remove-Item *.cs
    dotnet sln .. add .
    Pop-Location

    mkdir Cli | Push-Location
    dotnet new console @args
    dotnet add reference ../Core
    dotnet sln .. add .
    Pop-Location

    mkdir Api | Push-Location
    dotnet new webapi --no-https @args
    dotnet add reference ../Core
    dotnet sln .. add .
    Pop-Location

    mkdir Api.Tests | Push-Location
    dotnet new xunit @args
    dotnet add reference ../Api
    dotnet sln .. add .
    Pop-Location

    dotnet new gitignore
    git init
    git commit --no-edit --allow-empty --allow-empty-message
    git add --all
    git commit --message Initial

    edit . ./Api/Controllers/WeatherForecastController.cs

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

function dob { Get-ChildItem -Include bin, obj -Recurse -Directory | Remove-Item -Recurse -Force }

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

function Start-Project {
    # TODO: check if project already open, if so, focus window (alla vscode)
    Start-File *.*proj
}

function Start-Solution {
    # TODO: check if solution already open, if so, focus window (alla vscode)
    Start-File *.sln
}

Set-Alias -Name 'console' -Value 'New-ConsoleApp'
Set-Alias -Name 'e' -Value 'edit'
Set-Alias -Name 'edit' -Value 'code'

Set-Alias -Name 'msbuild' -Value (
    # scoop install vswhere
    # https://github.com/microsoft/vswhere/wiki/Find-MSBuild#powershell
    vswhere -latest -requires Microsoft.Component.MSBuild -find MSBuild\**\Bin\MSBuild.exe |
    select-object -first 1
)

Set-Alias -Name 'proj' -Value 'Start-Project'
Set-Alias -Name 'sln' -Value 'Start-Solution'
Set-Alias -Name 'wm' -Value 'winmergeu'
