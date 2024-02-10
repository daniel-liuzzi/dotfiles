using namespace System.Web

$Global:Subcommands = @{
    one = @{
        oneA = @{
            oneA1 = 'https://www.google.com/search?q='
            oneA2 = 'https://www.google.com/search?q='
            oneA3 = 'https://www.google.com/search?q='
        }
        oneB = @{
            oneB1 = 'https://www.google.com/search?q='
            oneB2 = 'https://www.google.com/search?q='
            oneB3 = 'https://www.google.com/search?q='
        }
        oneC = @{
            oneC1 = 'https://www.google.com/search?q='
            oneC2 = 'https://www.google.com/search?q='
            oneC3 = 'https://www.google.com/search?q='
        }
    }
    two = @{
        twoA = @{
            twoA1 = 'https://www.google.com/search?q='
            twoA2 = 'https://www.google.com/search?q='
            twoA3 = 'https://www.google.com/search?q='
        }
        twoB = @{
            twoB1 = 'https://www.google.com/search?q='
            twoB2 = 'https://www.google.com/search?q='
            twoB3 = 'https://www.google.com/search?q='
        }
        twoC = @{
            twoC1 = 'https://www.google.com/search?q='
            twoC2 = 'https://www.google.com/search?q='
            twoC3 = 'https://www.google.com/search?q='
        }
    }
    three = @{
        threeA = @{
            threeA1 = 'https://www.google.com/search?q='
            threeA2 = 'https://www.google.com/search?q='
            threeA3 = 'https://www.google.com/search?q='
        }
        threeB = @{
            threeB1 = 'https://www.google.com/search?q='
            threeB2 = 'https://www.google.com/search?q='
            threeB3 = 'https://www.google.com/search?q='
        }
        threeC = @{
            threeC1 = 'https://www.google.com/search?q='
            threeC2 = 'https://www.google.com/search?q='
            threeC3 = 'https://www.google.com/search?q='
        }
    }
}

function Get-Pepe($Path) {
    # $Path" >> "C:\Users\daniel\code\dotfiles\pepe.txt"
    $Value = $Global:Subcommands
    $Command = @()
    $Params = $Path
    foreach ($x in $Path) {
        # Write-Host $x -ForegroundColor Blue
        if ($Value.$x) {
            $Value = $Value.$x
            # $Command += $x
            # $Params = $Params | Select-Object -Skip 1
            $Command, $Params = $Params
        }
    }
    # Write-Host "@{
    #     Command = $Command
    #     Params = $Params
    #     Value = $Value
    # }" -ForegroundColor Yellow
    $Command, $Params, $Value
}

function Invoke-Subcommand {
    param(
        # [Parameter(Position = 0, ValueFromRemainingArguments = $true)]
        # [string[]]
        # $Keywords,

        [Parameter(Position = 0, ValueFromRemainingArguments = $true)]
        [ArgumentCompleter({
                param($Command, $Parameter, $WordToComplete, $CommandAst, $FakeBoundParams)
                $CommandName, $Arguments = $CommandAst.CommandElements
                $Path = $CommandAst.CommandElements.Value
                $Path = $Path | Select-Object -Skip 1 -First ($Path.Length - 2)
                [PSCustomObject][ordered]@{
                    Command = $Command
                    Parameter = $Parameter
                    WordToComplete = $WordToComplete
                    CommandAst = $CommandAst
                    FakeBoundParams = $FakeBoundParams
                    # Pepe = $CommandAst.Extent.ToString()
                    CommandName = $CommandName
                    Arguments = $Arguments
                    Path = $Path
                } >> "C:\Users\daniel\code\dotfiles\pepe.txt"
                $Command, $Params, $Options = Get-Pepe $Path
                $Options.GetEnumerator().Name | Where-Object { $_ -like "*$WordToComplete*" }
            })]
        # [ValidateScript({ $_ -in (Get-Pepe) })]
        [string[]]
        $Target
    )

    Write-Host $Target -ForegroundColor Green

    # if (!$Target) {
    #     throw 'No subcommand specified'
    # }

    # $Url = $Subcommands.$Target
    # if ($Url -is [Hashtable]) {
    #     Write-Host "Subcommands for '$Target':"
    #     $Url.GetEnumerator().Name | ForEach-Object { "  $_" }
    #     return
    # }
    # run start $Url

    $Command, $Params, $Value = Get-Pepe $Target
    [PSCustomObject][ordered]@{
        Command = $Command
        Params = $Params
        Value = $Value
    } | Format-List
    Write-Host $Value.GetType() -ForegroundColor Cyan
    if ($Value -is [Hashtable]) {
        Write-Host "$Command subcommands:"
        Write-Host
        $Value.GetEnumerator().Name | ForEach-Object { Write-Host "    $_" }
        Write-Host
        return
    }
    # run start $Value
}

Set-Alias -Name 'launch' -Value 'Invoke-Subcommand'
