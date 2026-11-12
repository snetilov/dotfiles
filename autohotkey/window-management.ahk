#Requires AutoHotkey v2.0
#SingleInstance Force

; Frames saved before snapping to a half, keyed by "hwnd:direction".
previousHalfFrames := Map()
; Frames saved before maximizing, keyed by hwnd.
maximizedFrames := Map()

!h::MoveToHalf("left")
!j::MoveToHalf("bottom")
!k::MoveToHalf("top")
!l::MoveToHalf("right")
!m::ToggleMaximize()

ShowAlert(message)
{
    ToolTip(message)
    SetTimer(() => ToolTip(), -1000)
}

UsePhysicalPixels()
{
    ; Per-monitor DPI awareness keeps coordinates right on monitors with different scaling.
    DllCall("SetThreadDpiAwarenessContext", "Ptr", -4, "Ptr")
}

FocusedWindow()
{
    hwnd := WinExist("A")

    ; Ignore the desktop, the taskbar and minimized windows.
    if (hwnd)
    {
        winClass := WinGetClass("ahk_id " hwnd)
        if (winClass ~= "^(Progman|WorkerW|Shell_TrayWnd|Shell_SecondaryTrayWnd)$"
            || WinGetMinMax("ahk_id " hwnd) = -1)
            hwnd := 0
    }

    if (!hwnd)
        ShowAlert("No focused window")

    return hwnd
}

WorkArea(hwnd)
{
    ; MONITOR_DEFAULTTONEAREST = 2
    monitor := DllCall("MonitorFromWindow", "Ptr", hwnd, "UInt", 2, "Ptr")

    info := Buffer(40, 0)
    NumPut("UInt", info.Size, info)
    DllCall("GetMonitorInfoW", "Ptr", monitor, "Ptr", info)

    left := NumGet(info, 20, "Int")
    top := NumGet(info, 24, "Int")
    right := NumGet(info, 28, "Int")
    bottom := NumGet(info, 32, "Int")

    return {x: left, y: top, w: right - left, h: bottom - top}
}

InvisibleBorder(hwnd)
{
    WinGetPos(&x, &y, &w, &h, "ahk_id " hwnd)

    ; DWMWA_EXTENDED_FRAME_BOUNDS = 9 is the visible part of the window.
    rect := Buffer(16, 0)
    if (DllCall("dwmapi\DwmGetWindowAttribute", "Ptr", hwnd, "UInt", 9, "Ptr", rect, "UInt", rect.Size) != 0)
        return {left: 0, top: 0, right: 0, bottom: 0}

    left := NumGet(rect, 0, "Int") - x
    top := NumGet(rect, 4, "Int") - y
    right := x + w - NumGet(rect, 8, "Int")
    bottom := y + h - NumGet(rect, 12, "Int")

    return {left: left, top: top, right: right, bottom: bottom}
}

SaveFrame(hwnd)
{
    WinGetPos(&x, &y, &w, &h, "ahk_id " hwnd)
    return {x: x, y: y, w: w, h: h, maximized: WinGetMinMax("ahk_id " hwnd) = 1}
}

RestoreFrame(hwnd, frame)
{
    if (frame.maximized)
    {
        WinMaximize("ahk_id " hwnd)
        return
    }

    if (WinGetMinMax("ahk_id " hwnd) != 0)
        WinRestore("ahk_id " hwnd)

    WinMove(frame.x, frame.y, frame.w, frame.h, "ahk_id " hwnd)
}

SetFrame(hwnd, target)
{
    if (WinGetMinMax("ahk_id " hwnd) != 0)
        WinRestore("ahk_id " hwnd)

    ; Windows 10/11 add invisible resize borders, so grow the window by them
    ; to make its visible part fill the target exactly.
    border := InvisibleBorder(hwnd)
    x := target.x - border.left
    y := target.y - border.top
    w := target.w + border.left + border.right
    h := target.h + border.top + border.bottom

    WinMove(x, y, w, h, "ahk_id " hwnd)
}

MoveToHalf(direction)
{
    global previousHalfFrames

    UsePhysicalPixels()

    hwnd := FocusedWindow()
    if (!hwnd)
        return

    key := hwnd ":" direction
    if (previousHalfFrames.Has(key))
    {
        RestoreFrame(hwnd, previousHalfFrames[key])
        previousHalfFrames.Delete(key)
        return
    }

    previousHalfFrames[key] := SaveFrame(hwnd)

    area := WorkArea(hwnd)
    halfWidth := area.w // 2
    halfHeight := area.h // 2
    target := {x: area.x, y: area.y, w: area.w, h: area.h}

    if (direction = "left")
    {
        target.w := halfWidth
    }
    else if (direction = "right")
    {
        target.x := area.x + halfWidth
        target.w := area.w - halfWidth
    }
    else if (direction = "top")
    {
        target.h := halfHeight
    }
    else
    {
        target.y := area.y + halfHeight
        target.h := area.h - halfHeight
    }

    SetFrame(hwnd, target)
}

ToggleMaximize()
{
    global maximizedFrames

    UsePhysicalPixels()

    hwnd := FocusedWindow()
    if (!hwnd)
        return

    if (maximizedFrames.Has(hwnd))
    {
        RestoreFrame(hwnd, maximizedFrames[hwnd])
        maximizedFrames.Delete(hwnd)
        return
    }

    maximizedFrames[hwnd] := SaveFrame(hwnd)
    WinMaximize("ahk_id " hwnd)
}
