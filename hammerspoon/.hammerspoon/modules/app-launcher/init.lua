local options = require("config.options")
local windowUtils = require("modules.window-utils")

local function focusStandardWindow(app)
	-- Prefer focused/main windows before scanning all windows.
	if not app then
		return false
	end

	local win = app:focusedWindow()
	if win and win:isStandard() then
		win:raise()
		win:focus()
		return true
	end

	win = app:mainWindow()
	if win and win:isStandard() then
		win:raise()
		win:focus()
		return true
	end

	for _, candidate in ipairs(app:allWindows() or {}) do
		if candidate:isStandard() then
			candidate:raise()
			candidate:focus()
			return true
		end
	end

	return false
end

local function retryFocus(appName, attempts, delay)
	-- Focus retries help when apps are slow to present a window.
	local function attempt(index)
		local app = hs.application.get(appName)
		if app and focusStandardWindow(app) then
			return
		end
		if index < attempts then
			hs.timer.doAfter(delay, function()
				attempt(index + 1)
			end)
		end
	end

	attempt(1)
end

local function launchOrFocus(appName)
	-- Spotlight-like behavior: launch or reopen a standard window.
	if not appName or appName == "" then
		return
	end

	local app = hs.application.get(appName)
	if not app then
		hs.application.launchOrFocus(appName)
		return
	end

	if focusStandardWindow(app) then
		return
	end

	app:unhide()
	app:activate(true)
	local escaped = appName:gsub('"', '\\"')
	-- Some apps only show a window after an explicit reopen.
	hs.osascript.applescript('tell application "' .. escaped .. '" to reopen')
	retryFocus(appName, 10, 0.1)
end

local function focusWindowInSpace(app, spaceId)
	-- Focus the first standard window that belongs to the target space.
	if not app or not spaceId then
		return false
	end
	for _, win in ipairs(app:allWindows() or {}) do
		if win:isStandard() and windowUtils.windowInSpace(win, spaceId) then
			win:raise()
			win:focus()
			return true
		end
	end
	return false
end

local function appWindows(appName)
	-- Capture all windows for an app by name across spaces.
	local windows = {}
	for _, win in ipairs(hs.window.allWindows()) do
		local app = win:application()
		if app and app:name() == appName then
			table.insert(windows, win)
		end
	end
	return windows
end

local function windowIdSet(appName)
	-- Used to detect the new window after creating one.
	local ids = {}
	for _, win in ipairs(appWindows(appName)) do
		local winId = win:id()
		if winId then
			ids[winId] = true
		end
	end
	return ids
end

local function findNewWindow(appName, existingIds)
	-- Find a standard window not present in the previous snapshot.
	for _, win in ipairs(appWindows(appName)) do
		local winId = win:id()
		if winId and not existingIds[winId] and win:isStandard() then
			return win
		end
	end
	return nil
end

local function moveWindowToTarget(win, targetSpace, targetScreen)
	-- Move to the desired screen first, then ensure the correct space.
	if targetScreen and win:screen() ~= targetScreen then
		win:moveToScreen(targetScreen, nil, true, 0)
	end
	if targetSpace and not windowUtils.windowInSpace(win, targetSpace) then
		windowUtils.moveWindowToSpace(win, targetSpace)
	end
	win:raise()
	win:focus()
end

local function createBrowserWindow(appName)
	-- Create a new window without stealing focus from other apps.
	local escaped = appName:gsub('"', '\\"')
	hs.osascript.applescript('tell application "' .. escaped .. '" to make new window')
end

local function launchBrowser()
	-- If Chrome has a window on the active space, focus it; else create one.
	local appName = options.apps.browser
	if not appName or appName == "" then
		return
	end

	local screen = windowUtils.activeScreen()
	local targetSpace = windowUtils.activeSpaceForScreen(screen)
	local app = hs.application.get(appName)
	if app and targetSpace and focusWindowInSpace(app, targetSpace) then
		return
	end

	-- Snapshot existing windows so we can identify the new one.
	local existingIds = windowIdSet(appName)
	if app then
		createBrowserWindow(appName)
	else
		hs.application.launchOrFocus(appName)
	end

	-- Poll until the new window appears, then move it into place.
	local attempts = 10
	local delay = 0.1
	local function attempt(index)
		local win = findNewWindow(appName, existingIds)
		if win then
			moveWindowToTarget(win, targetSpace, screen)
			return
		end
		if index < attempts then
			hs.timer.doAfter(delay, function()
				attempt(index + 1)
			end)
		end
	end
	attempt(1)
end

local function launchTerminal()
	launchOrFocus(options.apps.terminal)
end

local function launchNotes()
	launchOrFocus(options.apps.notes)
end

local function launchTextEditor()
	launchOrFocus(options.apps.textEditor)
end

local function launchFinder()
	launchOrFocus(options.apps.finder)
end

local function launchMail()
	launchOrFocus(options.apps.mail)
end

local function launchCalendar()
	launchOrFocus(options.apps.calendar)
end

local function launchMusicPlayer()
	launchOrFocus(options.apps.musicPlayer)
end

local function launchSlack()
	launchOrFocus(options.apps.slack)
end

local function launchDiscord()
	launchOrFocus(options.apps.discord)
end

local function launchTelegram()
	launchOrFocus(options.apps.telegram)
end

local function launchWhatsApp()
	launchOrFocus(options.apps.whatsApp)
end

local function launchAI()
	launchOrFocus(options.apps.ai)
end

return {
	launchOrFocus = launchOrFocus,
	launchBrowser = launchBrowser,
	launchTerminal = launchTerminal,
	launchNotes = launchNotes,
	launchTextEditor = launchTextEditor,
	launchFinder = launchFinder,
	launchMail = launchMail,
	launchCalendar = launchCalendar,
	launchMusicPlayer = launchMusicPlayer,
	launchSlack = launchSlack,
	launchDiscord = launchDiscord,
	launchTelegram = launchTelegram,
	launchWhatsApp = launchWhatsApp,
	launchAI = launchAI,
}
