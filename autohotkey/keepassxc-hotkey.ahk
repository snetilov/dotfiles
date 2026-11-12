#Requires AutoHotkey v2.0
#SingleInstance Force

; F16 is sent by QMK.
F16::
{
    vault := "ahk_exe KeePassXC.exe"

    ; Check whether the vault is running.
    hwnd := WinExist(vault)

    if (!hwnd)
    {
        ; Start the vault, or show it if it is hidden in the tray.
        Run(A_ProgramFiles "\KeePassXC\KeePassXC.exe")

        ; Wait up to 10 seconds for its window.
        if (!WinWait(vault, , 10))
        {
            MsgBox("Could not start the vault.")
            return
        }

        hwnd := WinExist(vault)
    }

    ; Restore if minimized.
    if (WinGetMinMax("ahk_id " hwnd) = -1)
        WinRestore("ahk_id " hwnd)

    ; Activate the vault.
    WinActivate("ahk_id " hwnd)

    ; Wait until the vault is active.
    if (!WinWaitActive("ahk_id " hwnd, , 3))
        return

    ; Maximize only if not already maximized.
    if (WinGetMinMax("ahk_id " hwnd) != 1)
        WinMaximize("ahk_id " hwnd)
}
