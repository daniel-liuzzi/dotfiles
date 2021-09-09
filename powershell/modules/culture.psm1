# ISO 8601 dates, times (this has no effect on PowerShell 5.1)
$Culture = [cultureinfo]::InvariantCulture.Clone()
$Culture.DateTimeFormat.ShortDatePattern = 'yyyy-MM-dd'
[System.Threading.Thread]::CurrentThread.CurrentCulture = $Culture
