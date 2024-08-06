; ^ = Ctrl; + = Shift; ! = Alt; # = Win; < = LMod; > = RMod
; https://www.autohotkey.com/docs/Hotkeys.htm#Symbols

#UseHook
SetTitleMatchMode("RegEx")

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
