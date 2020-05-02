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
; Volume control
; https://www.reddit.com/r/MechanicalKeyboards/comments/42do4w/can_autohotkey_be_used_to_enable_volume_controls/czai5ct/

^#!PgUp::SendInput {Volume_Up}     ; Ctrl+Win+Alt+PgUp
^#!PgDn::SendInput {Volume_Down}   ; Ctrl+Win+Alt+PgDn
^#!End::SendInput {Volume_Mute}    ; Ctrl+Win+Alt+End

; ================================================================================
; Sublime-style shortcuts in Visual Studio, LINQPad, SSMS

#IfWinActive, ahk_exe (devenv|LINQPad.*|Ssms)\.exe

    ; Ctrl+/        Comment selection
    ^/::SendInput ^k^c

    ; Ctrl+Shift+/  Uncomment selection
    +^/::SendInput ^k^u

    ; Map Ctrl+W to Ctrl+F4 (http://forum.voidtools.com/viewtopic.php?f=4&t=315#p568)
    ^w::SendInput ^{f4}

#If

; ================================================================================
; Sublime-style shortcuts in Visual Studio

#IfWinActive, ahk_exe devenv\.exe
    ^,::return ; Disable Ctrl+, to get used to Ctrl+P
    ^p::^, ; Ctrl+P (Goto Anything) -> Ctrl+, (Go to All)
    ^+p::SendInput ^q ; Ctrl+Shift+P (Command Palette) -> Ctrl+Q (Quick Launch)
#If

; ================================================================================
; macOS-style quit app

; Map Ctrl+Q to Alt+F4 (modified from https://autohotkey.com/board/topic/60675-osx-style-command-keys-in-windows/)
^q::SendInput !{f4}

; ================================================================================
; Turn monitor off with a keyboard shortcut
; Source: https://gist.github.com/davejamesmiller/1965854

; Win+\
#\::
    Sleep 1000
    SendMessage 0x112, 0xF140, 0, , Program Manager  ; Start screensaver
    SendMessage 0x112, 0xF170, 2, , Program Manager  ; Monitor off
    Return

; Win+Shift+\
#+\::
    Run rundll32.exe user32.dll`,LockWorkStation     ; Lock PC
    Sleep 1000
    SendMessage 0x112, 0xF170, 2, , Program Manager  ; Monitor off
    Return

; ================================================================================
; Text expansions
; http://line25.com/articles/10-html-entity-crimes-you-really-shouldnt-commit
; http://plaintext-productivity.net/4-04-autocorrection-and-text-expansion-with-autohotkey.html
; http://unicode-search.net/unicode-namesearch.pl?term=vulgar+fraction

; :*:--::–  ; Interferes with bash-style command switches (ie. git --help)
:*:->::→
::0/3::↉
::1/10::⅒
::1/2::½
::1/3::⅓
::1/4::¼
::1/5::⅕
::1/6::⅙
::1/7::⅐
::1/8::⅛
::1/9::⅑
::2/3::⅔
::2/5::⅖
::3/4::¾
::3/5::⅗
::3/8::⅜
::4/5::⅘
::5/6::⅚
::5/8::⅝
::7/8::⅞
:*:<-::←
:*:~=::≈
:*?:(c)::©
:*?:(r)::®
; :*?:...::…  ; Interferes with git diff (ie. git diff master...some-branch)
:?:...::…
:*?:=/=::≠
::TM::™

; Hotstrings
; https://autohotkey.com/docs/Hotstrings.htm
; https://medium.com/@zholmquist/textexpander-abbreviations-b8e094526bfd#.b9fwif36q
; https://smilesoftware.com/textexpander/entry/12-great-ways-to-choose-textexpander-abbreviations

::;nws::
(
This is a multi-line snippet.
It is inserted when I type ;nws and hit the tab key.
try it!
)

#Hotstring EndChars `t ; Only Tab triggers hotstring expansions

; Punctuation
:O?:...::…  ; HORIZONTAL ELLIPSIS
:O?:---::—  ; EM DASH
:O?:--::–   ; EN DASH

; Arrows
:O:^|::↑   ; UPWARDS ARROW
:O:->::→   ; RIGHTWARDS ARROW
:O:|v::↓   ; DOWNWARDS ARROW
:O:<-::←   ; LEFTWARDS ARROW

; Algebra
:O:x::×    ; MULTIPLICATION SIGN
:O:/::÷    ; DIVISION SIGN
:O:~=::≈   ; ALMOST EQUAL TO
:O:=/=::≠  ; NOT EQUAL TO

; Fractions - Halves, Fourths, and Eights
:O:1/8::⅛  ; VULGAR FRACTION ONE EIGHTH
:O:1/4::¼  ; VULGAR FRACTION ONE QUARTER
:O:3/8::⅜  ; VULGAR FRACTION ONE QUARTER
:O:1/2::½  ; VULGAR FRACTION ONE HALF
:O:5/8::⅝  ; VULGAR FRACTION FIVE EIGHTHS
:O:3/4::¾  ; VULGAR FRACTION THREE QUARTERS
:O:7/8::⅞  ; VULGAR FRACTION SEVEN EIGHTHS

; Fractions - Thirds and Sixths
:O:0/3::↉  ; VULGAR FRACTION ZERO THIRDS
:O:1/6::⅙  ; VULGAR FRACTION ONE SIXTH
:O:1/3::⅓  ; VULGAR FRACTION ONE THIRD
:O:2/3::⅔  ; VULGAR FRACTION TWO THIRDS
:O:5/6::⅚  ; VULGAR FRACTION FIVE SIXTHS

; Fractions - Fifths
:O:1/5::⅕  ; VULGAR FRACTION ONE FIFTH
:O:2/5::⅖  ; VULGAR FRACTION TWO FIFTHS
:O:3/5::⅗  ; VULGAR FRACTION THREE FIFTHS
:O:4/5::⅘  ; VULGAR FRACTION FOUR FIFTHS

; Fractions - Other
:O:1/7::⅐  ; VULGAR FRACTION ONE SEVENTH
:O:1/9::⅑  ; VULGAR FRACTION ONE NINTH
:O:1/10::⅒ ; VULGAR FRACTION ONE TENTH

; Legal / Other
:O?:(c)::© ; COPYRIGHT SIGN
:O?:(r)::® ; REGISTERED SIGN
:O?:TM::™  ; TRADE MARK SIGN
; :O?:o::°    ; DEGREE SIGN ; o<tab> is too common and triggered too many false positives

; Development
:O:constr::trusted_connection=true;
:O:lorem::Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.
:OR0:select::
(
SELECT *

ORDER BY 1 DESC
OFFSET 0 ROWS
FETCH NEXT 100 ROWS ONLY;
{Up}{Up}{Up}{Up}FROM{Space}
)

; Timestamp - ISO 8601 format
:O:now.iso::
FormatTime, CurrentDateTime, %A_NowUTC%, yyyy-MM-ddTHH:mm:ssZ
SendInput %CurrentDateTime%
return

; Timestamp - yyyyMMddHHmmss format
:O:now.ts::
FormatTime, CurrentDateTime, %A_NowUTC%, yyyyMMddHHmmss
SendInput %CurrentDateTime%
return

; ================================================================================
; Misc.
+^space::SendInput {U+00A0} ; Shift+Ctrl+Space -> Word-style nonbreaking space

#Include %A_ScriptDir%\AutoHotkeyU64.custom.ahk
