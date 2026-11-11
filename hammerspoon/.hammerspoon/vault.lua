local focusApp = require("app_launcher")

-- Vault launcher / focus / maximize
hs.hotkey.bind({}, "F16", function()
    focusApp("org.keepassxc.keepassxc", "KeePassXC")
end)
