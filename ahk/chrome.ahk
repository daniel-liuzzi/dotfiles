#Requires AutoHotkey v2.0
#SingleInstance Force

global gSwitching := false
global gTabDownLock := false
global gPendingCommit := false

#HotIf WinActive("ahk_exe chrome.exe")
~$*Tab Up::
{
    global gTabDownLock, gPendingCommit, gSwitching
    gTabDownLock := false

    if gPendingCommit && gSwitching && !GetKeyState("Ctrl", "P") {
        gPendingCommit := false
        ChromeMruCommit()
    }
}
#HotIf

#HotIf WinActive("ahk_exe chrome.exe") && gSwitching
$*Ctrl Up::
{
    global gPendingCommit

    if GetKeyState("Tab", "P") {
        gPendingCommit := true
        return
    }

    ChromeMruCommit()
}

$*Esc:: ChromeMruCancel()
#HotIf

#HotIf WinActive("ahk_exe chrome.exe") && GetKeyState("Ctrl", "P")
$*Tab::
{
    global gSwitching, gTabDownLock, gPendingCommit

    if gTabDownLock
        return
    gTabDownLock := true
    gPendingCommit := false

    if !gSwitching {
        gSwitching := true
        SendInput "^+a"
        Sleep 80
        return
    }

    if !GetKeyState("Shift", "P")
        SendInput "{Down}"
    else
        SendInput "{Up}"
}
#HotIf

ChromeMruCommit() {
    global gSwitching

    if !gSwitching
        return

    if !WinActive("ahk_exe chrome.exe") {
        ChromeMruReset()
        return
    }

    hadShift := GetKeyState("Shift", "P")
    if hadShift
        SendEvent "{Shift up}"

    Sleep 20
    SendEvent "{Enter}"

    if hadShift && GetKeyState("Shift", "P")
        SendEvent "{Shift down}"

    ChromeMruReset()
}

ChromeMruCancel() {
    global gSwitching

    SendInput "{Esc}"
    if gSwitching
        ChromeMruReset()
}

ChromeMruReset() {
    global gSwitching, gTabDownLock, gPendingCommit

    gSwitching := false
    gTabDownLock := false
    gPendingCommit := false
}
