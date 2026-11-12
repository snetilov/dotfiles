#Requires AutoHotkey v2.0
#SingleInstance Force

; F13 is sent by QMK when B is held.
F13::
{
    browser := "ahk_exe firefox.exe"

    ; Check whether the browser is running.
    hwnd := WinExist(browser)

    if (!hwnd)
    {
        ; Start the browser.
        Run("firefox.exe")

        ; Wait up to 10 seconds for its window.
        if (!WinWait(browser, , 10))
        {
            MsgBox("Could not start the browser.")
            return
        }

        hwnd := WinExist(browser)
    }

    ; Restore if minimized.
    if (WinGetMinMax("ahk_id " hwnd) = -1)
        WinRestore("ahk_id " hwnd)

    ; Activate the browser.
    WinActivate("ahk_id " hwnd)

    ; Wait until the browser is active.
    if (!WinWaitActive("ahk_id " hwnd, , 3))
        return

    ; Maximize only if not already maximized.
    if (WinGetMinMax("ahk_id " hwnd) != 1)
        WinMaximize("ahk_id " hwnd)
}
