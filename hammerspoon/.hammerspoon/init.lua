-- Reload config automatically when files change
hs.pathwatcher
	.new(os.getenv("HOME") .. "/.hammerspoon/", function()
		hs.reload()
	end)
	:start()

hs.window.animationDuration = 0

hs.alert.show("Hammerspoon config loaded")

-- Load modules
require("config.keymaps")
