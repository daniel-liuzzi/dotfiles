#SingleInstance, Ignore
#UseHook
SetTitleMatchMode, RegEx

; ================================================================================
; Map Caps Lock to Alt-Tab
; http://superuser.com/a/7144
; https://autohotkey.com/board/topic/96714-alt-tab-binding-possible-autohotkey/?p=609135

; CapsLock::SendInput !{tab}
; Return

; ================================================================================
; Better shortcuts (^ = Ctrl; + = Shift; ! = Alt; # = Win)

; VSCode-style shortcuts in Visual Studio
; (for the rest, go to Tools > Options > Environment > Keyboard and select 'Visual Studio Code')
#IfWinActive, ahk_exe devenv\.exe
    ^w::        SendInput ^{F4}         ; Close window/tab
    ^/::        SendInput ^k^c^k^c      ; Comment selection (SA1005-style comments)
    ^+/::       SendInput ^k^u^k^u      ; Uncomment selection
    ^+l::       SendInput !+;           ; Select all occurrences of current selection
    !LButton::  SendInput ^!{LButton}   ; Insert cursor
#If

; VSCode-style shortcuts in SQL Server Management Studio
#IfWinActive, ahk_exe Ssms\.exe
    ^w::        SendInput ^{F4}         ; Close window/tab
    ^/::        SendInput ^k^c^k^c      ; Comment selection
    ^+/::       SendInput ^k^u^k^u      ; Uncomment selection
#If

; VSCode-style shortcuts in LINQPad
#IfWinActive, ahk_exe LINQPad\d*\.exe
    ^/::        SendInput ^k^c^k^c      ; Comment selection
    ^+/::       SendInput ^k^u^k^u      ; Uncomment selection
    ^,::        SendInput !en           ; User Settings
    ^p::        SendInput ^,            ; Quick Open, Go to File...
    +!f::       SendInput ^ed           ; Format document
#If

; macOS-style shortcuts
^q::            SendInput !{F4}         ; Quit app

; Volume control
^#!PgUp::       SendInput {Volume_Up}   ; Increase volume
^#!PgDn::       SendInput {Volume_Down} ; Decrease volume
^#!End::        SendInput {Volume_Mute} ; Toggle mute

; Ctrl+Shift+V paste without formatting on any app
; How to Paste Text Without the Extra Formatting
; https://www.howtogeek.com/186723/ask-htg-how-can-i-paste-text-without-the-formatting/
#IfWinNotActive, ahk_exe CiscoCollabHost\.exe
    $^+v::
        ClipSaved := ClipboardAll ; save original clipboard contents
        Clipboard = %Clipboard% ; remove formatting
        Send ^v ; send the Ctrl+V command
        Clipboard := ClipSaved ; restore the original clipboard contents
        ClipSaved = ; clear the variable
        return
#If

; ================================================================================
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
::...::…  ; HORIZONTAL ELLIPSIS
::----::― ; HORIZONTAL BAR
::---::—  ; EM DASH
::--::–   ; EN DASH

; Fractions - Halves, Fourths, and Eights
::1/8::⅛  ; VULGAR FRACTION ONE EIGHTH
::1/4::¼  ; VULGAR FRACTION ONE QUARTER
::3/8::⅜  ; VULGAR FRACTION ONE QUARTER
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
::(c)::©  ; COPYRIGHT SIGN
::(r)::®  ; REGISTERED SIGN
::tm::™   ; TRADE MARK SIGN
::deg::°  ; DEGREE SIGN

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

; Superscript digits
::0::⁰    ; SUPERSCRIPT ZERO
::1::¹    ; SUPERSCRIPT ONE
::2::²    ; SUPERSCRIPT TWO
::3::³    ; SUPERSCRIPT THREE
::4::⁴    ; SUPERSCRIPT FOUR
::5::⁵    ; SUPERSCRIPT FIVE
::6::⁶    ; SUPERSCRIPT SIX
::7::⁷    ; SUPERSCRIPT SEVEN
::8::⁸    ; SUPERSCRIPT EIGHT
::9::⁹    ; SUPERSCRIPT NINE

; Hotstrings below don't trigger when inside another word
#Hotstring ?0

; Development
:R0:merge::
(
+{Home}MERGE INTO target t
+{Home}USING source s ON t.key = s.key
+{Home}WHEN MATCHED THEN
+{Home}    UPDATE SET
+{Home}        col1 = s.col1,
+{Home}        col2 = s.col2
+{Home}WHEN NOT MATCHED THEN
+{Home}    INSERT (col1, col2)
+{Home}    VALUES (s.col1, s.col2);
+{Home}{Delete}{Up 9}{End}{Left 2}+^{Left}
)
:R0:select::
(
SELECT *
FROM
ORDER BY 1 DESC
OFFSET 0 ROWS
FETCH NEXT 100 ROWS ONLY;
{Up 4}{End}{Space}^{Space}
)
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

; ================================================================================
; Misc.
+^space::SendInput {U+00A0} ; Shift+Ctrl+Space -> Word-style nonbreaking space
!=::SendInput ^{NumpadAdd}  ; Alt+= -> Size all columns to fit in listview controls

#Include %A_ScriptDir%\AutoHotkeyU64.custom.ahk
