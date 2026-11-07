-- Firefox launcher / focus / maximize
local function focusFirefox()
    local bundleID = "org.mozilla.firefox"

    -- Launch Firefox if necessary, or activate it if already running.
    local launched = hs.application.launchOrFocusByBundleID(bundleID)

    if not launched then
        hs.alert.show("Could not launch or focus Firefox")
        return
    end

    -- Give Firefox a moment to create or activate its window.
    hs.timer.doAfter(0.5, function()
        local firefox = hs.application.get(bundleID)

        if not firefox then
            hs.alert.show("Firefox is not available")
            return
        end

        firefox:unhide()
        firefox:activate()

        -- Get the currently focused Firefox window.
        local win = firefox:focusedWindow()

        if not win then
            -- Fall back to the first available window.
            local windows = firefox:visibleWindows()
            win = windows[1]
        end

        if win then
            -- Maximize the window to the available screen area.
            win:maximize()
        end
    end)
end

-- Intercept the F13 key sent by QMK.
hs.hotkey.bind({}, "F13", function()
    focusFirefox()
end)
