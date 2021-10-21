function Stop-SqlServer {
    sudo Invoke-Expression '
        net stop SQLSERVERAGENT
        net stop MSSQLSERVER
    '
}

function Start-SqlServer {
    sudo Invoke-Expression '
        net start MSSQLSERVER
        net start SQLSERVERAGENT
    '
}

function Restart-SqlServer {
    sudo Invoke-Expression '
        net stop SQLSERVERAGENT
        net stop MSSQLSERVER
        net start MSSQLSERVER
        net start SQLSERVERAGENT
    '
}
