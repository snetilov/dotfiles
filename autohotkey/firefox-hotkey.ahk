#Requires AutoHotkey v2.0
#SingleInstance Force

; F13 is sent by QMK when B is held.
F13::
{
    firefox := "ahk_exe firefox.exe"

    ; Check whether Firefox is running.
    hwnd := WinExist(firefox)

    if (!hwnd)
    {
        ; Start Firefox.
        Run("firefox.exe")

        ; Wait up to 10 seconds for its window.
        if (!WinWait(firefox, , 10))
        {
            MsgBox("Could not start Firefox.")
            return
        }

        hwnd := WinExist(firefox)
    }

    ; Restore if minimized.
    if (WinGetMinMax("ahk_id " hwnd) = -1)
        WinRestore("ahk_id " hwnd)

    ; Activate Firefox.
    WinActivate("ahk_id " hwnd)

    ; Wait until Firefox is active.
    if (!WinWaitActive("ahk_id " hwnd, , 3))
        return

    ; Maximize only if not already maximized.
    if (WinGetMinMax("ahk_id " hwnd) != 1)
        WinMaximize("ahk_id " hwnd)
}
