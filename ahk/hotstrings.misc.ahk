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

; UTC date & time (sortable)
:X:date::SendInput(FormatTime(A_NowUTC, "yyyy-MM-dd"))              ; Date
:X:time::SendInput(FormatTime(A_NowUTC, "HH:mm"))                   ; Time
:X:now::SendInput(FormatTime(A_NowUTC, "yyyy-MM-dd HH:mm"))         ; Date & time
:X:nowz::SendInput(FormatTime(A_NowUTC, "yyyy-MM-ddTHH:mm:ssZ"))    ; Date & time, ISO 8601

; Other
::constr::trusted_connection=true;
::lorem::Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.
::cl::console.log();{Left 2}
::ct::console.table();{Left 2}
::cw::Console.WriteLine();{Left 2}
::json::System.Text.Json.JsonSerializer.Serialize(obj, new System.Text.Json.JsonSerializerOptions {{} WriteIndented = true {}}){Left 70}+{Left 3}
