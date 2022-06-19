; EditorConfig
:R0:editorconfig::
(
root = true

[*]
charset = utf-8
indent_style = tab
insert_final_newline = true
trim_trailing_whitespace = true

)

; Timestamp - ISO 8601 format
::now.iso::
    FormatTime, CurrentDateTime, %A_NowUTC%, yyyy-MM-ddTHH:mm:ssZ
    SendInput %CurrentDateTime%
    return

; Timestamp - yyyyMMddHHmmss format
::now.ts::
    FormatTime, CurrentDateTime, %A_NowUTC%, yyyyMMddHHmmss
    SendInput %CurrentDateTime%
    return

; Current date
::date::
    FormatTime, CurrentDateTime, %A_NowUTC%, yyyy-MM-dd
    SendInput %CurrentDateTime%
    return

; Current time
::time::
    FormatTime, CurrentDateTime, %A_NowUTC%, HH:mm
    SendInput %CurrentDateTime%
    return

; Current date & time
::now::
    FormatTime, CurrentDateTime, %A_NowUTC%, yyyy-MM-dd HH:mm
    SendInput %CurrentDateTime%
    return

; Other
::constr::trusted_connection=true;
::lorem::Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.
::cl::console.log();{Left 2}
::ct::console.table();{Left 2}
::cw::Console.WriteLine();{Left 2}
