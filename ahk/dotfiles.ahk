#Requires AutoHotkey >=2 <3

#SingleInstance Ignore

#Include hotkeys.ahk

#Hotstring EndChars \ ; Only the backslash (\) triggers hotstring expansions
#Hotstring O ; Omit ending character

#Hotstring ? ; Trigger inside words
#Include hotstrings.chars.ahk
#Include hotstrings.flags.ahk

#Hotstring ?0 ; Don't trigger inside words
#Include hotstrings.custom.ahk
#Include hotstrings.graphviz.ahk
#Include hotstrings.misc.ahk
#Include hotstrings.sql.ansi.ahk
#Include hotstrings.sql.mssql.ahk
#Include hotstrings.sql.oracle.ahk
