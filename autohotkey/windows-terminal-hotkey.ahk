#Requires AutoHotkey v2.0
#SingleInstance Force

; F14 is sent by QMK.
F14::
{
    terminal := "ahk_exe WindowsTerminal.exe"

    ; Check whether the terminal is running.
    hwnd := WinExist(terminal)

    if (!hwnd)
    {
        ; Start the terminal.
        Run("wt.exe")

        ; Wait up to 10 seconds for its window.
        if (!WinWait(terminal, , 10))
        {
            MsgBox("Could not start the terminal.")
            return
        }

        hwnd := WinExist(terminal)
    }

    ; Restore if minimized.
    if (WinGetMinMax("ahk_id " hwnd) = -1)
        WinRestore("ahk_id " hwnd)

    ; Activate the terminal.
    WinActivate("ahk_id " hwnd)

    ; Wait until the terminal is active.
    if (!WinWaitActive("ahk_id " hwnd, , 3))
        return

    ; Maximize only if not already maximized.
    if (WinGetMinMax("ahk_id " hwnd) != 1)
        WinMaximize("ahk_id " hwnd)
}
