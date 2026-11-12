#Requires AutoHotkey v2.0
#SingleInstance Force

; F15 is sent by QMK.
F15::
{
    messenger := "ahk_exe ms-teams.exe"

    ; Check whether the messenger is running.
    hwnd := WinExist(messenger)

    if (!hwnd)
    {
        ; Start the messenger, or show it if it is hidden in the tray.
        Run("msteams:")

        ; Wait up to 10 seconds for its window.
        if (!WinWait(messenger, , 10))
        {
            MsgBox("Could not start the messenger.")
            return
        }

        hwnd := WinExist(messenger)
    }

    ; Restore if minimized.
    if (WinGetMinMax("ahk_id " hwnd) = -1)
        WinRestore("ahk_id " hwnd)

    ; Activate the messenger.
    WinActivate("ahk_id " hwnd)

    ; Wait until the messenger is active.
    if (!WinWaitActive("ahk_id " hwnd, , 3))
        return

    ; Maximize only if not already maximized.
    if (WinGetMinMax("ahk_id " hwnd) != 1)
        WinMaximize("ahk_id " hwnd)
}
