local maximizedFrames = {}
local previousHalfFrames = {}

local function focusedWindow()
    local win = hs.window.focusedWindow()
    if not win then
        hs.alert.show("No focused window")
    end
    return win
end

local function moveToHalf(direction)
    local win = focusedWindow()
    if not win then
        return
    end

    local screen = win:screen()
    if not screen then
        hs.alert.show("Focused window has no screen")
        return
    end

    local windowID = win:id()
    local key = windowID .. ":" .. direction
    local previousFrame = previousHalfFrames[key]

    if previousFrame then
        win:setFrame(previousFrame)
        previousHalfFrames[key] = nil
        return
    end

    previousHalfFrames[key] = win:frame()

    local frame = screen:frame()
    local halfWidth = frame.w / 2
    local halfHeight = frame.h / 2
    local target = {
        x = frame.x,
        y = frame.y,
        w = frame.w,
        h = frame.h,
    }

    if direction == "left" then
        target.w = halfWidth
    elseif direction == "right" then
        target.x = frame.x + halfWidth
        target.w = halfWidth
    elseif direction == "top" then
        target.h = halfHeight
    else
        target.y = frame.y + halfHeight
        target.h = halfHeight
    end

    win:setFrame(target)
end

local function toggleMaximize()
    local win = focusedWindow()
    if not win then
        return
    end

    local screen = win:screen()
    if not screen then
        hs.alert.show("Focused window has no screen")
        return
    end

    local windowID = win:id()
    local previousFrame = maximizedFrames[windowID]
    if previousFrame then
        win:setFrame(previousFrame)
        maximizedFrames[windowID] = nil
        return
    end

    maximizedFrames[windowID] = win:frame()
    win:setFrame(screen:frame())
end

hs.hotkey.bind({ "alt" }, "h", function()
    moveToHalf("left")
end)

hs.hotkey.bind({ "alt" }, "j", function()
    moveToHalf("bottom")
end)

hs.hotkey.bind({ "alt" }, "k", function()
    moveToHalf("top")
end)

hs.hotkey.bind({ "alt" }, "l", function()
    moveToHalf("right")
end)

hs.hotkey.bind({ "alt" }, "m", toggleMaximize)
