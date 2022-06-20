; ^ = Ctrl; + = Shift; ! = Alt; # = Win; < = LMod; > = RMod
; https://www.autohotkey.com/docs/Hotkeys.htm#Symbols

#UseHook
SetTitleMatchMode, RegEx

; Better navigation
<^Up::          SendInput {PgUp}
<^Down::        SendInput {PgDn}
<+^Up::         SendInput +{PgUp}
<+^Down::       SendInput +{PgDn}
#If, !GetKeyState("Shift")
    CapsLock & Up::     SendInput ^{Home}
    CapsLock & Down::   SendInput ^{End}
    CapsLock & Left::   SendInput {Home}
    CapsLock & Right::  SendInput {End}
#If, GetKeyState("Shift")
    CapsLock & Up::     SendInput +^{Home}
    CapsLock & Down::   SendInput +^{End}
    CapsLock & Left::   SendInput +{Home}
    CapsLock & Right::  SendInput +{End}
#If

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
