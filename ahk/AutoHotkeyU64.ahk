#SingleInstance, Ignore
#UseHook
SetTitleMatchMode, RegEx

#Include %A_ScriptDir%\AutoHotkeyU64.custom.ahk

; ^ = Ctrl; + = Shift; ! = Alt; # = Win; < = LMod; > = RMod
; https://www.autohotkey.com/docs/Hotkeys.htm#Symbols

; Better navigation
<^Up::          SendInput {PgUp}
<^Down::        SendInput {PgDn}
<#!Up::         SendInput ^{Home}
<#!Down::       SendInput ^{End}
<#!Left::       SendInput {Home}
<#!Right::      SendInput {End}

; CapsLock -> Alt+Tab
CapsLock::      SendInput !{Tab}

; Alt+= -> Autosize listview columns
!=::            SendInput ^{NumpadAdd}

; VSCode-style shortcuts in Visual Studio
; (for the rest, go to Tools > Options > Environment > Keyboard and select 'Visual Studio Code')
#IfWinActive, ahk_exe devenv\.exe
    ^w::        SendInput ^{F4}         ; Close window/tab
    ^/::        SendInput ^k^c          ; Comment selection (SA1005-style comments)
    ^+/::       SendInput ^k^u          ; Uncomment selection
    ^+l::       SendInput !+;           ; Select all occurrences of current selection
    !LButton::  SendInput ^!{LButton}   ; Insert cursor
#If

; VSCode-style shortcuts in SQL Server Management Studio
#IfWinActive, ahk_exe Ssms\.exe
    ^w::        SendInput ^{F4}         ; Close window/tab
    ^/::        SendInput ^k^c          ; Comment selection
    ^+/::       SendInput ^k^u          ; Uncomment selection
#If

; VSCode-style shortcuts in LINQPad
#IfWinActive, ahk_exe LINQPad.*\.exe
    ^/::        SendInput ^k^c          ; Comment selection
    ^+/::       SendInput ^k^u          ; Uncomment selection
    ^,::        SendInput !en           ; User Settings
    ^p::        SendInput ^,            ; Quick Open, Go to File...
    +!f::       SendInput ^ed           ; Format document
#If

; VSCode-style shortcuts in Oracle SQL Developer
#IfWinActive, ahk_exe sqldeveloper64W\.exe
    +!f::       SendInput ^{F7}         ; Format document
    !LButton::  SendInput ^+{LButton}   ; Insert cursor
    ^n::        SendInput !{F10}        ; New connection
#If

; macOS-style shortcuts
^q::            SendInput !{F4}         ; Quit app

; Volume control
^#!=::          SendInput {Volume_Up}   ; Increase volume
^#!-::          SendInput {Volume_Down} ; Decrease volume
^#!0::          SendInput {Volume_Mute} ; Toggle mute

; Ctrl+Shift+V paste without formatting on any app
; How to Paste Text Without the Extra Formatting
; https://www.howtogeek.com/186723/ask-htg-how-can-i-paste-text-without-the-formatting/
#IfWinNotActive, ahk_exe (CiscoCollabHost)\.exe
    $^+v::
        ClipSaved := ClipboardAll ; save original clipboard contents
        Clipboard = %Clipboard% ; remove formatting
        Send ^v ; send the Ctrl+V command
        Clipboard := ClipSaved ; restore the original clipboard contents
        ClipSaved = ; clear the variable
        return
#If

; Turn monitor off with a keyboard shortcut
; Source: https://gist.github.com/davejamesmiller/1965854

; Win+\
#\::
    Sleep 1000
    SendMessage 0x112, 0xF140, 0,, Program Manager  ; Start screensaver
    SendMessage 0x112, 0xF170, 2,, Program Manager  ; Monitor off
    return

; Win+Shift+\
#+\::
    Run rundll32.exe user32.dll`,LockWorkStation    ; Lock PC
    Sleep 1000
    SendMessage 0x112, 0xF170, 2,, Program Manager  ; Monitor off
    return

; ================================================================================
; Hotstrings, text expansions
; http://line25.com/articles/10-html-entity-crimes-you-really-shouldnt-commit
; http://plaintext-productivity.net/4-04-autocorrection-and-text-expansion-with-autohotkey.html
; http://unicode-search.net/unicode-namesearch.pl?term=vulgar+fraction
; https://autohotkey.com/docs/Hotstrings.htm
; https://medium.com/@zholmquist/textexpander-abbreviations-b8e094526bfd#.b9fwif36q
; https://smilesoftware.com/textexpander/entry/12-great-ways-to-choose-textexpander-abbreviations

#Hotstring EndChars \ ; Only the backslash (\) triggers hotstring expansions
#Hotstring O ; Omit the ending character

; Hotstrings below trigger even when inside another word
#Hotstring ?

; Punctuation
::?::¿    ; INVERTED QUESTION MARK
::!::¡    ; INVERTED EXCLAMATION MARK
::...::…  ; HORIZONTAL ELLIPSIS
::----::― ; HORIZONTAL BAR
::---::—  ; EM DASH
::--::–   ; EN DASH

; Fractions - Halves, Fourths, and Eights
::1/8::⅛  ; VULGAR FRACTION ONE EIGHTH
::1/4::¼  ; VULGAR FRACTION ONE QUARTER
::3/8::⅜  ; VULGAR FRACTION THREE EIGHTHS
::1/2::½  ; VULGAR FRACTION ONE HALF
::5/8::⅝  ; VULGAR FRACTION FIVE EIGHTHS
::3/4::¾  ; VULGAR FRACTION THREE QUARTERS
::7/8::⅞  ; VULGAR FRACTION SEVEN EIGHTHS

; Fractions - Thirds and Sixths
::0/3::↉  ; VULGAR FRACTION ZERO THIRDS
::1/6::⅙  ; VULGAR FRACTION ONE SIXTH
::1/3::⅓  ; VULGAR FRACTION ONE THIRD
::2/3::⅔  ; VULGAR FRACTION TWO THIRDS
::5/6::⅚  ; VULGAR FRACTION FIVE SIXTHS

; Fractions - Fifths
::1/5::⅕  ; VULGAR FRACTION ONE FIFTH
::2/5::⅖  ; VULGAR FRACTION TWO FIFTHS
::3/5::⅗  ; VULGAR FRACTION THREE FIFTHS
::4/5::⅘  ; VULGAR FRACTION FOUR FIFTHS

; Fractions - Other
::1/7::⅐  ; VULGAR FRACTION ONE SEVENTH
::1/9::⅑  ; VULGAR FRACTION ONE NINTH
::1/10::⅒ ; VULGAR FRACTION ONE TENTH

; Currency
::btc::₿    ; Bitcoin
::cny::¥    ; Chinese yuan
::eur::€    ; Euro
::gbp::£    ; Pound sterling
::inr::₹    ; Indian rupee
::jpy::¥    ; Japanese yen
::php::₱    ; Philippine peso
::rub::₽    ; Russian ruble

; Legal / Other
::(c)::©            ; COPYRIGHT SIGN
::(r)::®            ; REGISTERED SIGN
::tm::™             ; TRADE MARK SIGN
::deg::°            ; DEGREE SIGN
::nbsp::{U+00A0}    ; NO-BREAK SPACE
::nro::№            ; NUMERO SIGN
::ordf::ª           ; FEMININE ORDINAL INDICATOR
::ordm::º           ; MASCULINE ORDINAL INDICATOR

; International characters, based on Windows US International keyboard layout
; https://support.microsoft.com/en-us/help/306560/how-to-use-the-united-states-international-keyboard-layout-in-windows
::'a::á
::'A::Á
::'c::ç
::'C::Ç
::'e::é
::'E::É
::'i::í
::'I::Í
::'o::ó
::'O::Ó
::'u::ú
::'U::Ú
::'y::ý
::'Y::Ý
::"a::ä
::"A::Ä
::"e::ë
::"E::Ë
::"i::ï
::"I::Ï
::"o::ö
::"O::Ö
::"u::ü
::"U::Ü
::"y::ÿ
::"Y::Ÿ
::``a::à
::``A::À
::``e::è
::``E::È
::``i::ì
::``I::Ì
::``o::ò
::``O::Ò
::``u::ù
::``U::Ù
::^a::â
::^A::Â
::^e::ê
::^E::Ê
::^i::î
::^I::Î
::^o::ô
::^O::Ô
::^u::û
::^U::Û
::~a::ã
::~A::Ã
::~n::ñ
::~N::Ñ
::~o::õ
::~O::Õ

; Superscript symbols
::^-::⁻     ; SUPERSCRIPT MINUS
::^(::⁽     ; SUPERSCRIPT LEFT PARENTHESIS
::^)::⁾     ; SUPERSCRIPT RIGHT PARENTHESIS
::^+::⁺     ; SUPERSCRIPT PLUS SIGN
::^=::⁼     ; SUPERSCRIPT EQUALS SIGN
::^0::⁰     ; SUPERSCRIPT ZERO
::^1::¹     ; SUPERSCRIPT ONE
::^2::²     ; SUPERSCRIPT TWO
::^3::³     ; SUPERSCRIPT THREE
::^4::⁴     ; SUPERSCRIPT FOUR
::^5::⁵     ; SUPERSCRIPT FIVE
::^6::⁶     ; SUPERSCRIPT SIX
::^7::⁷     ; SUPERSCRIPT SEVEN
::^8::⁸     ; SUPERSCRIPT EIGHT
::^9::⁹     ; SUPERSCRIPT NINE
::^n::ⁿ     ; SUPERSCRIPT LATIN SMALL LETTER N

; Hotstrings below don't trigger when inside another word
#Hotstring ?0

; SQL

:R0:sel::
(
+{Home}select *
+{Home}from
+{Home}order by 1 desc;
+{Home}{Up 2}{End}{Space}^{Space}
)

:R0:sel100::
(
+{Home}select *
+{Home}from
+{Home}order by 1 desc
+{Home}offset 0 rows
+{Home}fetch next 100 rows only;
+{Home}{Up 4}{End}{Space}^{Space}
)

:R0:merge::
(
+{Home}merge into target t
+{Home}using source s on (t.id = s.id)
+{Home}when matched then
+{Home}    update set
+{Home}        col1 = s.col1,
+{Home}        col2 = s.col2
+{Home}when not matched then
+{Home}    insert (col1, col2)
+{Home}    values (s.col1, s.col2);
+{Home}{Delete}{Up 9}{End}{Left 2}+^{Left}
)

:R0:tbls::
(
+{Home}select *
+{Home}from information_schema.tables
+{Home}where
+{Home}    table_catalog like '%%' and
+{Home}    table_schema like '%%' and
+{Home}    table_name like '%%' and
+{Home}    table_type = 'base table'
+{Home}order by table_catalog, table_schema, table_name;
+{Home}{Up 3}{End}{Left 6}
)

:R0:views::
(
+{Home}select *
+{Home}from information_schema.tables
+{Home}where
+{Home}    table_catalog like '%%' and
+{Home}    table_schema like '%%' and
+{Home}    table_name like '%%' and
+{Home}    table_type = 'view'
+{Home}order by table_catalog, table_schema, table_name;
+{Home}{Up 3}{End}{Left 6}
)

:R0:cols::
(
+{Home}select *
+{Home}from information_schema.columns c
+{Home}inner join information_schema.tables t on
+{Home}    t.table_catalog = c.table_catalog and
+{Home}    t.table_schema = c.table_schema and
+{Home}    t.table_name = c.table_name
+{Home}where
+{Home}    t.table_type = 'base table' and
+{Home}    c.table_catalog like '%%' and
+{Home}    c.table_schema like '%%' and
+{Home}    c.table_name like '%%' and
+{Home}    c.column_name like '%%'
+{Home}order by c.table_catalog, c.table_schema, c.table_name, c.ordinal_position;
+{Home}{Up 3}{End}{Left 6}
)

; SQL - Oracle

; Switch current session to another schema
:R0:oschema::
(
+{Home}alter session set current_schema = ;{Left}
)

; Query tables
:R0:otbls::
(
+{Home}select table_name
+{Home}from user_tables
+{Home}where table_name like upper('%%')
+{Home}order by table_name;
+{Home}{Up 2}{End}{Left 3}
)

; Query tables (all users)
:R0:otblsa::
(
+{Home}select owner, table_name
+{Home}from all_tables
+{Home}where owner like upper('%%') and table_name like upper('%%')
+{Home}order by owner, table_name;
+{Home}{Up 2}{End}{Left 3}
)

; Query views
:R0:oviews::
(
+{Home}select view_name
+{Home}from user_views
+{Home}where view_name like upper('%%')
+{Home}order by view_name;
+{Home}{Up 2}{End}{Left 3}
)

; Query views (all users)
:R0:oviewsa::
(
+{Home}select owner, view_name
+{Home}from all_views
+{Home}where owner like upper('%%') and view_name like upper('%%')
+{Home}order by owner, view_name;
+{Home}{Up 2}{End}{Left 3}
)

; Query table columns
:R0:ocols::
(
+{Home}select
+{Home}    table_name,
+{Home}    column_name,
+{Home}    data_type,
+{Home}    case
+{Home}        when data_type in ('NUMBER') then
+{Home}            case
+{Home}                when data_precision is not null and data_scale is not null then
+{Home}                    '(' || data_precision || ',' || data_scale || ')'
+{Home}                when data_precision is not null then
+{Home}                    '(' || data_precision || ')'
+{Home}            end
+{Home}        when data_type in ('CHAR', 'VARCHAR2') then
+{Home}            '(' || char_length || case char_used when 'C' then ' CHAR' end || ')'
+{Home}        when data_type in ('NCHAR', 'NVARCHAR2') then
+{Home}            '(' || char_length || ')'
+{Home}        when data_type in ('RAW', 'UROWID') then
+{Home}            '(' || data_length || ')'
+{Home}    end data_size,
+{Home}    case nullable when 'N' then ' NOT NULL' end data_null
+{Home}from user_tab_columns
+{Home}where
+{Home}    table_name in (select table_name from user_tables) and
+{Home}    table_name like upper('%%') and
+{Home}    column_name like upper('%%')
+{Home}order by table_name, column_id;
+{Home}{Up 2}{End}{Left 3}
)

; Query table columns (all users)
:R0:ocolsa::
(
+{Home}select owner, table_name, column_id, column_name, data_type, data_length, data_precision, data_scale, nullable
+{Home}from all_tab_columns
+{Home}where
+{Home}    owner like upper('%%') and
+{Home}    table_name in (select table_name from all_tables) and
+{Home}    table_name like upper('%%') and
+{Home}    column_name like upper('%%')
+{Home}order by owner, table_name, column_id;
+{Home}{Up 2}{End}{Left 3}
)

; Query users
:R0:ousers::
(
+{Home}select *
+{Home}from user_users
+{Home}where username like upper('%%')
+{Home}order by username;
+{Home}{Up 2}{End}{Left 3}
)

; Query users (all users)
:R0:ousersa::
(
+{Home}select *
+{Home}from all_users
+{Home}where username like upper('%%')
+{Home}order by username;
+{Home}{Up 2}{End}{Left 3}
)

; Get DDL
:R0:oddl::
(
+{Home}select object_type, object_name, dbms_metadata.get_ddl(object_type, object_name, owner) ddl
+{Home}from all_objects
+{Home}where
+{Home}    owner = sys_context('userenv', 'current_schema') and
+{Home}    object_type not in ('JOB', 'LOB', 'TABLE PARTITION') and
+{Home}    object_name like upper('%%')
+{Home}order by object_type, object_name;
+{Home}{Up 2}{End}{Left 2}+{Left 2}
)

; Graphviz

; Digraph
:R0:digraph::
(
+{Home}digraph {{}+{End}
+{Home}    layout="circo"; {#} dot, neato, fdp, twopi, circo+{End}
+{Home}    edge [color="{#}999999"];+{End}
+{Home}    node [style="filled"; color="{#}333333"; fontcolor="{#}ffffff"];+{End}

+{Home}    "Observation" -> "Question";+{End}
+{Home}    "Question" -> "Hypothesis";+{End}
+{Home}    "Hypothesis" -> "Experiment";+{End}
+{Home}    "Experiment" -> "Analyze";+{End}
+{Home}    "Analyze" -> "Conclusion";+{End}
+{Home}    "Conclusion" -> "Observation";+{End}
+{Home}{}}+{End}
)

; Graph
:R0:graph::
(
+{Home}graph {{}+{End}
+{Home}    layout="circo"; {#} dot, neato, fdp, twopi, circo+{End}
+{Home}    edge [color="{#}999999"];+{End}
+{Home}    node [style="filled"; color="{#}333333"; fontcolor="{#}ffffff"];+{End}

+{Home}    "Observation" -- "Question";+{End}
+{Home}    "Question" -- "Hypothesis";+{End}
+{Home}    "Hypothesis" -- "Experiment";+{End}
+{Home}    "Experiment" -- "Analyze";+{End}
+{Home}    "Analyze" -- "Conclusion";+{End}
+{Home}    "Conclusion" -- "Observation";+{End}
+{Home}{}}+{End}
)

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

; Misc
::constr::trusted_connection=true;
::lorem::Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.
::cl::console.log();{Left 2}
::ct::console.table();{Left 2}
::cw::Console.WriteLine();{Left 2}

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

; Arrows
::^|::↑   ; UPWARDS ARROW
::->::→   ; RIGHTWARDS ARROW
::|v::↓   ; DOWNWARDS ARROW
::<-::←   ; LEFTWARDS ARROW

; Algebra
::+-::±   ; PLUS-MINUS SIGN
::-::−    ; MINUS SIGN
::*::×    ; MULTIPLICATION SIGN
::/::÷    ; DIVISION SIGN
::~=::≈   ; ALMOST EQUAL TO
::!=::≠   ; NOT EQUAL TO
::<<<::⋘   ; VERY MUCH LESS-THAN
::<<::≪   ; MUCH LESS-THAN
::<=::≤   ; LESS-THAN OR EQUAL TO
::>>>::⋙   ; VERY MUCH GREATER-THAN
::>>::≫   ; MUCH GREATER-THAN
::>=::≥   ; GREATER-THAN OR EQUAL TO
