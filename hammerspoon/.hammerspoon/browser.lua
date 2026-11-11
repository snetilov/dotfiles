local focusApp = require("app_launcher")

-- Browser launcher / focus / maximize
hs.hotkey.bind({}, "F13", function()
    focusApp("org.mozilla.firefox", "Firefox")
end)
