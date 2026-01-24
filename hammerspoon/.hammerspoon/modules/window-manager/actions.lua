local helpers = require("modules.window-manager.helpers")
local grid = require("modules.window-manager.grid")
local options = require("config.options")

local gap = options.gap

local function leftHalf()
	local win = hs.window.focusedWindow()
	if not win then
		return
	end
	local target = grid.gridFrameWithGap(win:screen(), 2, 1, 0, 0, 1, 1, gap)
	helpers.setWindowFrame(win, target)
end

local function rightHalf()
	local win = hs.window.focusedWindow()
	if not win then
		return
	end
	local target = grid.gridFrameWithGap(win:screen(), 2, 1, 1, 0, 1, 1, gap)
	helpers.setWindowFrame(win, target)
end

local function centerHalf()
	local win = hs.window.focusedWindow()
	if not win then
		return
	end
	local target = grid.gridFrameWithGap(win:screen(), 4, 1, 1, 0, 2, 1, gap)
	helpers.setWindowFrame(win, target)
end

local function almostMaximise()
	local win = hs.window.focusedWindow()
	if not win then
		return
	end
	local target = grid.gridFrameWithGap(win:screen(), 1, 1, 0, 0, 1, 1, gap)
	helpers.setWindowFrame(win, target)
end

local function leftThird()
	local win = hs.window.focusedWindow()
	if not win then
		return
	end
	local target = grid.gridFrameWithGap(win:screen(), 3, 1, 0, 0, 1, 1, gap)
	helpers.setWindowFrame(win, target)
end

local function rightThird()
	local win = hs.window.focusedWindow()
	if not win then
		return
	end
	local target = grid.gridFrameWithGap(win:screen(), 3, 1, 2, 0, 1, 1, gap)
	helpers.setWindowFrame(win, target)
end

local function leftTwoThirds()
	local win = hs.window.focusedWindow()
	if not win then
		return
	end
	local target = grid.gridFrameWithGap(win:screen(), 3, 1, 0, 0, 2, 1, gap)
	helpers.setWindowFrame(win, target)
end

local function rightTwoThirds()
	local win = hs.window.focusedWindow()
	if not win then
		return
	end
	local target = grid.gridFrameWithGap(win:screen(), 3, 1, 1, 0, 2, 1, gap)
	helpers.setWindowFrame(win, target)
end

local function centerThird()
	local win = hs.window.focusedWindow()
	if not win then
		return
	end
	local target = grid.gridFrameWithGap(win:screen(), 3, 1, 1, 0, 1, 1, gap)
	helpers.setWindowFrame(win, target)
end

local function centerTwoThirds()
	local win = hs.window.focusedWindow()
	if not win then
		return
	end
	local target = grid.gridFrameWithGap(win:screen(), 6, 1, 1, 0, 4, 1, gap)
	helpers.setWindowFrame(win, target)
end

local function arrangeWindows()
	-- Evenly distribute visible windows across the active screen.
	local screen, _, windows = helpers.activeScreenWindows()
	if not screen or #windows == 0 then
		return
	end

	for index, win in ipairs(windows) do
		local colIndex = index - 1
		local target = grid.gridFrameWithGap(screen, #windows, 1, colIndex, 0, 1, 1, gap)
		helpers.setWindowFrame(win, target)
	end
end

local function rotateWindows()
	-- Rotate window positions without changing their sizes.
	local _, _, windows = helpers.activeScreenWindows()
	if #windows < 2 then
		return
	end

	local frames = {}
	for index, win in ipairs(windows) do
		frames[index] = helpers.normalizeFrame(win:frame())
	end

	local count = #windows
	for index, win in ipairs(windows) do
		local target = frames[(index % count) + 1]
		helpers.setWindowFrame(win, target)
	end
end

local function focusNextWindow()
	-- Cycle focus within the active screen/space.
	local screen = helpers.activeScreen()
	local _, _, windows = helpers.windowsOnScreen(screen)
	if #windows == 0 then
		return
	end

	local focusedId = nil
	local focused = hs.window.focusedWindow()
	if focused and focused:screen() == screen then
		focusedId = focused:id()
	end

	if not focusedId then
		helpers.focusWindow(windows[1])
		return
	end

	local focusedIndex = nil
	for index, win in ipairs(windows) do
		if win:id() == focusedId then
			focusedIndex = index
			break
		end
	end

	if not focusedIndex then
		helpers.focusWindow(windows[1])
		return
	end

	local nextIndex = (focusedIndex % #windows) + 1
	helpers.focusWindow(windows[nextIndex])
end

local function focusNextScreen()
	-- Move focus to the next screen, even if it has no windows.
	local screens = helpers.orderedScreens()
	if #screens < 2 then
		return
	end

	local current = helpers.activeScreen()
	if not current then
		return
	end

	local currentKey = helpers.screenSortKey(current)
	local currentIndex = nil
	for index, screen in ipairs(screens) do
		if helpers.screenSortKey(screen) == currentKey then
			currentIndex = index
			break
		end
	end

	if not currentIndex then
		return
	end

	local nextIndex = (currentIndex % #screens) + 1
	local nextScreen = screens[nextIndex]
	local _, _, windows = helpers.windowsOnScreen(nextScreen)
	if #windows == 0 then
		helpers.focusScreen(nextScreen)
		return
	end

	helpers.focusWindow(windows[1])
	-- Ensure focus actually moved; re-click the screen if it didn't.
	hs.timer.doAfter(0.05, function()
		local active = helpers.activeScreen()
		if active and helpers.screenSortKey(active) == helpers.screenSortKey(nextScreen) then
			return
		end
		helpers.focusScreen(nextScreen)
		hs.timer.doAfter(0, function()
			helpers.focusWindow(windows[1])
		end)
	end)
end

local function arrangeWindowsWithPreferredLast(screen, preferredWin)
	-- Arrange windows left-to-right (or top-to-bottom) with a chosen last.
	local _, _, windows = helpers.windowsOnScreen(screen)
	if #windows == 0 then
		return
	end

	local preferredIndex = nil
	if preferredWin then
		local preferredId = preferredWin:id()
		if preferredId then
			for index, win in ipairs(windows) do
				if win:id() == preferredId then
					preferredIndex = index
					break
				end
			end
		end
	end

	if preferredIndex then
		local preferred = table.remove(windows, preferredIndex)
		table.insert(windows, preferred)
	end

	for index, win in ipairs(windows) do
		local colIndex = index - 1
		local target = grid.gridFrameWithGap(screen, #windows, 1, colIndex, 0, 1, 1, gap)
		helpers.setWindowFrame(win, target)
	end
end

local function appendWindowToNextScreen(rearrange)
	-- Move the focused window to the next screen, optionally rearranging.
	local screens = helpers.orderedScreens()
	if #screens < 2 then
		return
	end

	local current = helpers.activeScreen()
	if not current then
		return
	end

	local focused = hs.window.focusedWindow()
	if not focused or focused:screen() ~= current then
		return
	end

	local currentKey = helpers.screenSortKey(current)
	local currentIndex = nil
	for index, screen in ipairs(screens) do
		if helpers.screenSortKey(screen) == currentKey then
			currentIndex = index
			break
		end
	end

	if not currentIndex then
		return
	end

	local nextIndex = (currentIndex % #screens) + 1
	local nextScreen = screens[nextIndex]

	focused:moveToScreen(nextScreen, nil, true, 0)

	if rearrange then
		arrangeWindowsWithPreferredLast(nextScreen, focused)
		helpers.focusWindow(focused)
		return
	end

	helpers.focusWindow(focused)
end

local function appendWindowToNextScreenArrange()
	appendWindowToNextScreen(true)
end

local function appendWindowToNextScreenNoArrange()
	appendWindowToNextScreen(false)
end

return {
	leftHalf = leftHalf,
	rightHalf = rightHalf,
	centerHalf = centerHalf,
	almostMaximise = almostMaximise,
	leftThird = leftThird,
	rightThird = rightThird,
	leftTwoThirds = leftTwoThirds,
	rightTwoThirds = rightTwoThirds,
	centerThird = centerThird,
	centerTwoThirds = centerTwoThirds,
	arrangeWindows = arrangeWindows,
	rotateWindows = rotateWindows,
	focusNextWindow = focusNextWindow,
	focusNextScreen = focusNextScreen,
	appendWindowToNextScreenArrange = appendWindowToNextScreenArrange,
	appendWindowToNextScreenNoArrange = appendWindowToNextScreenNoArrange,
}
