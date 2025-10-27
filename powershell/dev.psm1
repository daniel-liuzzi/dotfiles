Import-Module $ProfileDir/base
Import-Module $ProfileDir/git

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
    Repeatedly executes a command and displays its output, similar to the Unix 'watch' command.
#>
function Invoke-Watch {
    param(
        [Parameter(Mandatory = $true, Position = 0)]
        [object]
        $Command,

        [int]
        $Interval = 1
    )

    while ($true) {
        Clear-Host
        Write-Host "$(Get-Date) - every ${Interval}s: $Command`r`n" -ForegroundColor Green

        if ($Command -is [scriptblock]) {
            & $Command
        } else {
            Invoke-Expression $Command
        }

        Start-Sleep -Seconds $Interval
    }
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
        "<Project>"
        "    <PropertyGroup>"
        "        <AssemblyName>$(Split-Path -Leaf .).`$(MSBuildProjectName)</AssemblyName>"
        "        <RootNamespace>`$(AssemblyName.Replace(`" `", `"_`"))</RootNamespace>"
        "        <Deterministic>true</Deterministic>"
        "    </PropertyGroup>"
        "</Project>"
    )

    mkdir Core | Push-Location
    dotnet new classlib @args
    Remove-Item Class1.cs
    dotnet sln .. add .
    Pop-Location

    mkdir Cli | Push-Location
    dotnet new console @args
    dotnet add reference ../Core
    dotnet sln .. add .
    Pop-Location

    mkdir Api | Push-Location
    dotnet new webapi --no-https --use-minimal-apis=false @args
    "`r`npublic partial class Program { }" >> Program.cs
    dotnet add reference ../Core
    dotnet sln .. add .
    Pop-Location

    mkdir Api.Tests | Push-Location
    dotnet new xunit @args
    Remove-Item UnitTest1.cs
@"
using System.Net.Http.Json;

using Microsoft.AspNetCore.Mvc.Testing;

namespace Api.Tests;

public class WeatherForecastControllerTests
{
    private readonly WebApplicationFactory<Program> _factory = new();

    [Fact]
    public async Task WeatherForecast_Ok()
    {
        // Arrange
        using var client = _factory.CreateClient();

        // Act
        var items = await client.GetFromJsonAsync<IEnumerable<WeatherForecast>>("/WeatherForecast");

        // Assert
        Assert.NotNull(items);
        Assert.Equal(5, items.Count());
        var superset = new[] { "Freezing", "Bracing", "Chilly", "Cool", "Mild", "Warm", "Balmy", "Hot", "Sweltering", "Scorching" }.ToHashSet();
        var actual = items.Select(i => i.Summary!).ToHashSet();
        Assert.Subset(superset, actual);
    }
}
"@ > WeatherForecastControllerTests.cs
    dotnet add package Microsoft.AspNetCore.Mvc.Testing
    dotnet add reference ../Api
    dotnet sln .. add .
    Pop-Location

    dotnet new gitignore
    git init
    git commit --no-edit --allow-empty --allow-empty-message
    git add --all
    git commit --message Initial

    edit . Api.Tests/WeatherForecastControllerTests.cs Api/Controllers/WeatherForecastController.cs

    Pop-Location
}

# dotnet
function dn { run dotnet @args }
function dna($path = '.') { dn add $path @args }
function dnap($path = '.') { dna $path package @args }
function dnar($path = '.') { dna $path reference @args }
function dnb($path = '.') { dn build $path @args }
function dnc($path = '.') { dn clean $path @args }
function dnf($path = '.') { dn format $path @args }
function dnl($path = '.') { dn list $path @args }
function dnlp($path = '.') { dnl $path package @args }
function dnlr($path = '.') { dnl $path reference @args }
function dnn { dn new @args }
function dnni { dnn install @args }
function dnnl { dnn list @args }
function dnns { dnn search @args }
function dnnu { dnn uninstall @args }
function dnp($path = '.') { dn pack $path @args }
function dnr { dn run @args }
function dnrm($path = '.') { dn remove $path @args }
function dnrmp($path = '.') { dnrm $path package @args }
function dnrmr($path = '.') { dnrm $path reference @args }
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
    run start (Find-File *.*proj)
}

function Start-Solution {
    # TODO: check if solution already open, if so, focus window (alla vscode)
    ##run start (Find-File *.sln)
    run start (Find-File *.slnx, *.sln)
}

function Find-File($Filter) {
    $Path = `
        Get-ChildItem -Path $Filter -Recurse -Depth 1 -File | `
        Select-Object -First 1 | `
        Resolve-Path -Relative

    if (!$Path) { return Write-Error "No $Filter files found" }
    return $Path
}

Set-Alias -Name 'console' -Value 'New-ConsoleApp'

# Editor
function e. { e . @args }
Set-Alias -Name 'e' -Value 'code'

# scoop install vswhere
# https://github.com/microsoft/vswhere/wiki/Find-MSBuild#powershell
vswhere -latest -requires Microsoft.Component.MSBuild -find MSBuild\**\Bin\MSBuild.exe |
select -first 1 |
foreach { Set-Alias -Name 'msbuild' -Value $_ }

Set-Alias -Name 'proj' -Value 'Start-Project'
Set-Alias -Name 'sln' -Value 'Start-Solution'
Set-Alias -Name 'watch' -Value 'Invoke-Watch'
Set-Alias -Name 'wm' -Value 'winmergeu'
