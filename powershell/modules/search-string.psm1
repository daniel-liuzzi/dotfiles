# https://stackoverflow.com/a/7785226/88709
filter Search-String {
    [Alias("ss")]
    [OutputType([System.IO.FileInfo])]
    param([string[]] $Patterns)
    foreach ($Pattern in $Patterns) {
        if (-not ($_ | Select-String -Pattern $Pattern)) {
            return
        }
    }

    $_
}
