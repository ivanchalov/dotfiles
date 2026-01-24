local wm = require("modules.window-manager")
local launcher = require("modules.app-launcher")

local opt_mod = { "alt" }
local ctrl_opt_mod = { "ctrl", "alt" }

hs.hotkey.bind(opt_mod, "h", wm.leftHalf)
hs.hotkey.bind(opt_mod, "l", wm.rightHalf)
hs.hotkey.bind(opt_mod, "j", wm.centerHalf)
hs.hotkey.bind(opt_mod, "k", wm.almostMaximise)
hs.hotkey.bind(ctrl_opt_mod, "h", wm.leftThird)
hs.hotkey.bind(ctrl_opt_mod, "l", wm.rightThird)
hs.hotkey.bind(ctrl_opt_mod, "g", wm.leftTwoThirds)
hs.hotkey.bind(ctrl_opt_mod, ";", wm.rightTwoThirds)
hs.hotkey.bind(ctrl_opt_mod, "j", wm.centerThird)
hs.hotkey.bind(ctrl_opt_mod, "k", wm.centerTwoThirds)

hs.hotkey.bind(opt_mod, "a", wm.arrangeWindows)
hs.hotkey.bind(opt_mod, "r", wm.rotateWindows)

hs.hotkey.bind(opt_mod, "x", wm.focusNextWindow)
hs.hotkey.bind(opt_mod, "z", wm.focusNextScreen)

hs.hotkey.bind(opt_mod, "p", wm.appendWindowToNextScreenArrange)
hs.hotkey.bind(ctrl_opt_mod, "p", wm.appendWindowToNextScreenNoArrange)

hs.hotkey.bind(opt_mod, "t", launcher.launchTerminal)
hs.hotkey.bind(opt_mod, "n", launcher.launchNotes)
hs.hotkey.bind(opt_mod, "e", launcher.launchTextEditor)
hs.hotkey.bind(opt_mod, "f", launcher.launchFinder)
hs.hotkey.bind(opt_mod, "b", launcher.launchBrowser)
hs.hotkey.bind(opt_mod, "m", launcher.launchMail)
hs.hotkey.bind(opt_mod, "c", launcher.launchCalendar)
hs.hotkey.bind(opt_mod, "u", launcher.launchMusicPlayer)
hs.hotkey.bind(opt_mod, "s", launcher.launchSlack)
hs.hotkey.bind(opt_mod, "d", launcher.launchDiscord)
hs.hotkey.bind(opt_mod, "g", launcher.launchTelegram)
hs.hotkey.bind(opt_mod, "w", launcher.launchWhatsApp)
hs.hotkey.bind(opt_mod, "i", launcher.launchAI)
