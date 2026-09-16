; ^ = Ctrl; + = Shift; ! = Alt; # = Win; < = LMod; > = RMod
; https://www.autohotkey.com/docs/Hotkeys.htm#Symbols

#UseHook
SetTitleMatchMode("RegEx")

; Caps+K (Connected Devices, alla Windows 10's Win+K): kanata emits F24 for
; Caps+K, since it owns the physical CapsLock key and AHK can no longer
; detect it as held via GetKeyState.
F24:: Run "ms-settings:connecteddevices"

; Ctrl+Alt+K summons KeePassXC alla KeePass
^!k:: Run "keepassxc"

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
