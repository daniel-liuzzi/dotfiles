SetTitleMatchMode, RegEx

; ================================================================================
; Map Caps Lock to Alt-Tab
; http://superuser.com/a/7144
; https://autohotkey.com/board/topic/96714-alt-tab-binding-possible-autohotkey/?p=609135

; CapsLock::Send !{tab}
; Return

; ================================================================================
; Volume control
; https://www.reddit.com/r/MechanicalKeyboards/comments/42do4w/can_autohotkey_be_used_to_enable_volume_controls/czai5ct/

^#!PgUp::Send {Volume_Up}     ; Ctrl+Win+Alt+PgUp
^#!PgDn::Send {Volume_Down}   ; Ctrl+Win+Alt+PgDn
^#!End::Send {Volume_Mute}    ; Ctrl+Win+Alt+End

; ================================================================================
; Sublime-style shortcuts in Visual Studio, LINQPad, SSMS

#IfWinActive, ahk_exe (devenv|LINQPad|Ssms)\.exe

    ; Ctrl+/        Comment selection
    ^/::Send ^k^c

    ; Ctrl+Shift+/  Uncomment selection
    +^/::Send ^k^u

    ; Map Ctrl+W to Ctrl+F4 (http://forum.voidtools.com/viewtopic.php?f=4&t=315#p568)
    ^w::Send ^{f4}

#If

; ================================================================================
; Sublime-style shortcuts in Visual Studio

#IfWinActive, ahk_exe devenv\.exe
    ^,::return ; Disable Ctrl+, to get used to Ctrl+P
    ^p::^, ; Ctrl+P (Goto Anything) → Ctrl+, (Go to All)
    ^+p::^q ; Ctrl+Shift+P (Command Palette) → Ctrl+Q (Quick Launch)
#If

; ================================================================================
; macOS-style quit app

; Map Ctrl+Q to Alt+F4 (modified from https://autohotkey.com/board/topic/60675-osx-style-command-keys-in-windows/)
^q::Send !{f4}

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
; Map Ctrl+Win+Alt combos to miscellaneous characters (credit mine)
; Arrows are the same as those used by Google Keyboard

^#!Left::   Send {U+2190}   ; Ctrl+Win+Alt+Left     ← (LEFTWARDS ARROW)
^#!Up::     Send {U+2191}   ; Ctrl+Win+Alt+Up       ↑ (UPWARDS ARROW)
^#!Right::  Send {U+2192}   ; Ctrl+Win+Alt+Right    → (RIGHTWARDS ARROW)
^#!Down::   Send {U+2193}   ; Ctrl+Win+Alt+Down     ↓ (DOWNWARDS ARROW)
^#!=::      Send {U+2260}   ; Ctrl+Win+Alt+=        ≠ (NOT EQUAL TO)
+^#!=::     Send {U+2248}   ; Shift+Ctrl+Win+Alt+=  ≈ (ALMOST EQUAL TO)
^#!-::      Send {U+2013}   ; Ctrl+Win+Alt+-        – (EN DASH)
+^#!-::     Send {U+2014}   ; Shift+Ctrl+Win+Alt+-  — (EM DASH)

; 10 HTML Entity Crimes You Really Shouldn’t Commit
; http://line25.com/articles/10-html-entity-crimes-you-really-shouldnt-commit
^#!.::      Send {U+2026}   ; Ctrl+Win+Alt+.        … (HORIZONTAL ELLIPSIS)
^#!/::      Send {U+00F7}   ; Ctrl+Win+Alt+/        ÷ (DIVISION SIGN)
^#!c::      Send {U+00A9}   ; Ctrl+Win+Alt+c        © (COPYRIGHT SIGN)
^#!o::      Send {U+00B0}   ; Ctrl+Win+Alt+o        ° (DEGREE SIGN)
^#!t::      Send {U+2122}   ; Ctrl+Win+Alt+t        ™ (TRADE MARK SIGN)
^#!x::      Send {U+00D7}   ; Ctrl+Win+Alt+x        × (MULTIPLICATION SIGN)

; Eighths vulgar fractions
^#!1::      Send {U+215B}   ; Ctrl+Win+Alt+1        ⅛ (VULGAR FRACTION ONE EIGHTH)
^#!2::      Send {U+00BC}   ; Ctrl+Win+Alt+2        ¼ (VULGAR FRACTION THREE EIGHTHS)
^#!3::      Send {U+215C}   ; Ctrl+Win+Alt+3        ⅜ (VULGAR FRACTION ONE QUARTER)
^#!4::      Send {U+00BD}   ; Ctrl+Win+Alt+4        ½ (VULGAR FRACTION ONE HALF)
^#!5::      Send {U+215D}   ; Ctrl+Win+Alt+5        ⅝ (VULGAR FRACTION FIVE EIGHTHS)
^#!6::      Send {U+00BE}   ; Ctrl+Win+Alt+6        ¾ (VULGAR FRACTION THREE QUARTERS)
^#!7::      Send {U+215E}   ; Ctrl+Win+Alt+7        ⅞ (VULGAR FRACTION SEVEN EIGHTHS)

; Sixths vulgar fractions
+^#!1::     Send {U+2159}   ; Shift+Ctrl+Win+Alt+1  ⅙ (VULGAR FRACTION ONE SIXTH)
+^#!2::     Send {U+2153}   ; Shift+Ctrl+Win+Alt+2  ⅓ (VULGAR FRACTION ONE THIRD)
+^#!3::     Send {U+00BD}   ; Shift+Ctrl+Win+Alt+3  ½ (VULGAR FRACTION ONE HALF)
+^#!4::     Send {U+2154}   ; Shift+Ctrl+Win+Alt+4  ⅔ (VULGAR FRACTION TWO THIRDS)
+^#!5::     Send {U+215A}   ; Shift+Ctrl+Win+Alt+5  ⅚ (VULGAR FRACTION FIVE SIXTHS)

; Text expansions
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

:*:now.iso:: ; current date in ISO 8601 format
FormatTime, CurrentDateTime, %A_NowUTC%, yyyy-MM-ddTHH:mm:ssZ
SendInput %CurrentDateTime%
return

:*:now.ts:: ; current date in timestamp format
FormatTime, CurrentDateTime, %A_NowUTC%, yyyyMMddHHmmss
SendInput %CurrentDateTime%
return

; SQL
:O:sel::USE Crs;`r`rSELECT TOP 100 *`rFROM dbo.`rORDER BY 1 DESC;`r{Up}{Up}{End}

; Misc.
:O:lorem::Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.

#Include %A_ScriptDir%\AutoHotkeyU64.custom.ahk
