local focusApp = require("app_launcher")

-- Terminal launcher / focus / maximize
hs.hotkey.bind({}, "F14", function()
    focusApp("com.mitchellh.ghostty", "Ghostty")
end)
