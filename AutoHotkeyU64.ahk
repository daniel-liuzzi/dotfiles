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
; Better shortcuts

; VSCode-style shortcuts (Visual Studio, LINQPad, SSMS)
#IfWinActive, ahk_exe (devenv|LINQPad.*|Ssms)\.exe
    ^/::SendInput ^k^c              ; Ctrl+/            -> Comment selection
    ^+/::SendInput ^k^u             ; Ctrl+Shift+/      -> Uncomment selection
    ^w::SendInput ^{f4}             ; Ctrl+W            -> Close editor (http://forum.voidtools.com/viewtopic.php?f=4&t=315#p568)
#If

; VSCode-style shortcuts (Visual Studio only)
#IfWinActive, ahk_exe devenv\.exe
    ^,::SendInput !to               ; Ctrl+,            -> User Settings
    ^p::SendInput ^,                ; Ctrl+P            -> Quick Open, Go to File...
    ^+p::SendInput ^q               ; Ctrl+Shift+P      -> Show Command Palette
    !Left::SendInput ^-             ; Alt+Left          -> Go back
    !Right::SendInput ^+-           ; Alt+Right         -> Go forward
    ^=::SendInput ^+.               ; Ctrl+=            -> Zoom in
    ^-::SendInput ^+,               ; Ctrl+-            -> Zoom out
    ^+l::SendInput !+;              ; Ctrl+Shift+L      -> Select all occurrences of current selection
    ^d::SendInput !+.               ; Ctrl+D            -> Add selection to next Find match
    +!Right::SendInput +!=          ; Shift+Alt+Right   -> Expand selection
    +!Left::SendInput +!-           ; Shift+Alt+Left    -> Shrink selection
    +!f::SendInput ^ed              ; Shift+Alt+F       -> Format document
    !LButton::SendInput ^!{LButton} ; Ctrl+Click        -> Insert cursor
#If

; macOS-style shortcuts
^q::SendInput !{f4}                 ; Ctrl+Q -> quit app (modified from https://autohotkey.com/board/topic/60675-osx-style-command-keys-in-windows/)

; ================================================================================
; Turn monitor off with a keyboard shortcut
; Source: https://gist.github.com/davejamesmiller/1965854

; Win+\
#\::
    Sleep 1000
    SendMessage 0x112, 0xF140, 0,, Program Manager  ; Start screensaver
    SendMessage 0x112, 0xF170, 2,, Program Manager  ; Monitor off
    Return

; Win+Shift+\
#+\::
    Run rundll32.exe user32.dll`,LockWorkStation    ; Lock PC
    Sleep 1000
    SendMessage 0x112, 0xF170, 2,, Program Manager  ; Monitor off
    Return

; ================================================================================
; Hotstrings, text expansions
; http://line25.com/articles/10-html-entity-crimes-you-really-shouldnt-commit
; http://plaintext-productivity.net/4-04-autocorrection-and-text-expansion-with-autohotkey.html
; http://unicode-search.net/unicode-namesearch.pl?term=vulgar+fraction
; https://autohotkey.com/docs/Hotstrings.htm
; https://medium.com/@zholmquist/textexpander-abbreviations-b8e094526bfd#.b9fwif36q
; https://smilesoftware.com/textexpander/entry/12-great-ways-to-choose-textexpander-abbreviations

#Hotstring EndChars \ ; Only the backslash (\) triggers hotstring expansions
#Hotstring O ? ; Omit the ending character, trigger even when inside another word

; Development
::constr::trusted_connection=true;
::lorem::Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.
:R0:select::
(
SELECT *

ORDER BY 1 DESC
OFFSET 0 ROWS
FETCH NEXT 100 ROWS ONLY;
{Up}{Up}{Up}{Up}FROM{Space}
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

; Punctuation
::...::…  ; HORIZONTAL ELLIPSIS
::---::—  ; EM DASH
::--::–   ; EN DASH

; Arrows
::^|::↑   ; UPWARDS ARROW
::->::→   ; RIGHTWARDS ARROW
::|v::↓   ; DOWNWARDS ARROW
::<-::←   ; LEFTWARDS ARROW

; Algebra
::x::×    ; MULTIPLICATION SIGN
::/::÷    ; DIVISION SIGN
::~=::≈   ; ALMOST EQUAL TO
::=/=::≠  ; NOT EQUAL TO

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

; Legal / Other
::(c)::©  ; COPYRIGHT SIGN
::(r)::®  ; REGISTERED SIGN
::TM::™   ; TRADE MARK SIGN
::o::°    ; DEGREE SIGN

; ================================================================================
; Misc.
+^space::SendInput {U+00A0} ; Shift+Ctrl+Space -> Word-style nonbreaking space

#Include %A_ScriptDir%\AutoHotkeyU64.custom.ahk
