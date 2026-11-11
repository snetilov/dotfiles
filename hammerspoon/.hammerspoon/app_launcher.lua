return function(bundleID, appName)
    local launched = hs.application.launchOrFocusByBundleID(bundleID)

    if not launched then
        hs.alert.show("Could not launch or focus " .. appName)
        return
    end

    -- Give the app a moment to create or activate its window.
    hs.timer.doAfter(0.5, function()
        local app = hs.application.get(bundleID)

        if not app then
            hs.alert.show(appName .. " is not available")
            return
        end

        app:unhide()
        app:activate()

        local win = app:focusedWindow()

        if not win then
            -- Fall back to the first available window.
            local windows = app:visibleWindows()
            win = windows[1]
        end

        if win then
            win:maximize()
        end
    end)
end
