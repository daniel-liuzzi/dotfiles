function Stop-SqlServer {
    sudo pwsh -Command 'net stop SQLSERVERAGENT; net stop MSSQLSERVER'
}

function Start-SqlServer {
    sudo pwsh -Command 'net start MSSQLSERVER; net start SQLSERVERAGENT'
}

function Restart-SqlServer {
    sudo pwsh -Command 'Stop-SqlServer; Start-SqlServer'
}
