﻿; ^ = Ctrl; + = Shift; ! = Alt; # = Win; < = LMod; > = RMod
; https://www.autohotkey.com/docs/Hotkeys.htm#Symbols

#UseHook
SetTitleMatchMode("RegEx")
SetCapsLockState("AlwaysOff")

#HotIf GetKeyState("CapsLock", "P")

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

    ; Connected Devices (alla Windows 10's Win+K)
    k::Run "ms-settings:connecteddevices"

    ; Caps + L = Turn monitor off and lock PC
    ; https://gist.github.com/davejamesmiller/1965854
    l::
    {
        Run("rundll32.exe user32.dll,LockWorkStation")
        Sleep(1000)
        SendMessage(0x112, 0xF170, 2,, "Program Manager")
    }

    ; Misc.
    `::         Esc
    Esc::       `
    BackSpace:: Delete
    b::         vk13 ; Pause
    ^b::        CtrlBreak
    c::         CapsLock
    i::         Insert
    n::         NumLock
    p::         PrintScreen
    q::         SendInput "!{F4}" ; Alt+F4
    s::         ScrollLock
    w::         SendInput "^{F4}" ; Ctrl+F4

#HotIf

; Ctrl+Alt+K summons KeePassXC alla KeePass
^!k:: Run "keepassxc"

; Alt+= -> Autosize listview columns
!=::            SendInput "^{NumpadAdd}"

; VSCode-style shortcuts in Visual Studio
; (for the rest, go to Tools > Options > Environment > Keyboard and select 'Visual Studio Code')
#HotIf WinActive("ahk_exe devenv\.exe")
    !LButton::  SendInput "^!{LButton}" ; Insert cursor
#HotIf

; VSCode-style shortcuts in SQL Server Management Studio
#HotIf WinActive("ahk_exe Ssms\.exe")
    ^/::        SendInput "^k^c"        ; Comment selection
    ^+/::       SendInput "^k^u"        ; Uncomment selection
#HotIf

; VSCode-style shortcuts in LINQPad
#HotIf WinActive("ahk_exe LINQPad.*\.exe")
    ^,::        SendInput "!en"         ; User Settings
    ^p::        SendInput "^,"          ; Quick Open, Go to File...
    +!f::       SendInput "^ed"         ; Format document
#HotIf

; VSCode-style shortcuts in Oracle SQL Developer
#HotIf WinActive("ahk_exe sqldeveloper64W\.exe")
    +!f::       SendInput "^{F7}"       ; Format document
    !LButton::  SendInput "^+{LButton}" ; Insert cursor
    ^n::        SendInput "!{F10}"      ; New connection
#HotIf

; Common special chars with AltGr
>!!::¡
>!?::¿
>!<!a::à
>!<!A::À
>!<!e::è
>!<!E::È
>!<!i::ì
>!<!I::Ì
>!<!o::ò
>!<!O::Ò
>!<!u::ù
>!<!U::Ù
>!a::á
>!A::Á
>!c::ç
>!C::Ç
>!e::é
>!E::É
>!i::í
>!I::Í
>!n::ñ
>!N::Ñ
>!o::ó
>!O::Ó
>!u::ú
>!U::Ú
