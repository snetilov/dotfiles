local focusApp = require("app_launcher")

-- Messenger launcher / focus / maximize
hs.hotkey.bind({}, "F15", function()
    focusApp("com.tinyspeck.slackmacgap", "Slack")
end)
