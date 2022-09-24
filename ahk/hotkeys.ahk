; ^ = Ctrl; + = Shift; ! = Alt; # = Win; < = LMod; > = RMod
; https://www.autohotkey.com/docs/Hotkeys.htm#Symbols

#UseHook
SetTitleMatchMode, RegEx
SetCapsLockState, AlwaysOff

#If GetKeyState("CapsLock", "P")

    ; Function row
    1::F1
    2::F2
    3::F3
    4::F4
    5::F5
    6::F6
    7::F7
    8::F8
    9::F9
    0::F10
    -::F11
    =::F12

    ; MacBook-style navigation keys
    Left::      Home
    Right::     End
    Up::        PgUp
    Down::      PgDn

    ; Media controls
    [::         Volume_Down
    ]::         Volume_Up
    \::         Volume_Mute
    ,::         Media_Prev
    .::         Media_Next
    Space::     Media_Play_Pause

    ; Caps + L = Turn monitor off and lock PC
    ; https://gist.github.com/davejamesmiller/1965854
    l::
        Run rundll32.exe user32.dll`,LockWorkStation
        Sleep 1000
        SendMessage 0x112, 0xF170, 2,, Program Manager
        return

    ; Misc.
    `::         Esc
    Esc::       `
    BackSpace:: Delete
    i::         Insert
    p::         PrintScreen

#If

; CapsLock -> Alt+Tab
;;CapsLock::      SendInput !{Tab} ; Temporarily disabled (interferes with the above)

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
