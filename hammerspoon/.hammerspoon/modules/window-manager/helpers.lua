local windowUtils = require("modules.window-utils")

local M = {}

function M.normalizeFrame(frame)
	-- Use integers to avoid sub-pixel drift between frame reads/writes.
	return {
		x = math.floor(frame.x),
		y = math.floor(frame.y),
		w = math.floor(frame.w),
		h = math.floor(frame.h),
	}
end

function M.isPortrait(screen)
	-- Treat portrait screens as top-to-bottom for layout logic.
	if not screen then
		return false
	end
	local frame = screen:frame()
	return frame.h > frame.w
end

function M.setWindowFrame(win, frame)
	-- Fast path without animation; fallback to workarounds only if needed.
	local desired = M.normalizeFrame(frame)
	local prevCorrectness = hs.window.setFrameCorrectness
	hs.window.setFrameCorrectness = false
	win:setFrame(desired, 0)
	hs.window.setFrameCorrectness = prevCorrectness

	local actual = M.normalizeFrame(win:frame())
	local tolerance = 1
	if
		math.abs(actual.x - desired.x) > tolerance
		or math.abs(actual.y - desired.y) > tolerance
		or math.abs(actual.w - desired.w) > tolerance
		or math.abs(actual.h - desired.h) > tolerance
	then
		if win.setFrameWithWorkarounds then
			win:setFrameWithWorkarounds(desired, 0)
		end
	end
end

function M.focusWindow(win)
	-- Some apps resist focus; retry briefly to make it stick.
	if not win then
		return
	end
	local targetId = win:id()
	if not targetId then
		return
	end
	local delays = { 0, 0.05, 0.15, 0.3 }
	local function attempt(index)
		local focused = hs.window.focusedWindow()
		if focused and focused:id() == targetId then
			return
		end
		win:becomeMain()
		win:raise()
		win:focus()
		if index < #delays then
			hs.timer.doAfter(delays[index + 1], function()
				attempt(index + 1)
			end)
		end
	end

	attempt(1)
end

function M.activeScreen()
	-- Delegate to shared screen logic (focused space or mouse screen).
	return windowUtils.activeScreen()
end

local function windowIntersectsScreen(win, screenFrame)
	-- Avoid ghost windows that report the screen but are off-screen.
	local wf = win:frame()
	local overlap = wf:intersect(screenFrame)
	return overlap.w > 1 and overlap.h > 1
end

function M.windowsOnScreen(screen)
	-- Filter to visible, standard windows on the active space.
	if not screen then
		return nil, nil, {}
	end
	local screenFrame = screen:frame()
	local activeSpaceId = windowUtils.activeSpaceForScreen(screen)

	local windows = {}
	for _, win in ipairs(hs.window.visibleWindows()) do
		if win:isStandard() and win:screen() == screen and windowIntersectsScreen(win, screenFrame) then
			if windowUtils.windowInSpace(win, activeSpaceId, true) then
				table.insert(windows, win)
			end
		end
	end

	local portrait = M.isPortrait(screen)
	table.sort(windows, function(a, b)
		-- Sort along the primary axis (x for landscape, y for portrait).
		local af = a:frame()
		local bf = b:frame()
		if portrait then
			if af.y == bf.y then
				if af.x == bf.x then
					return (a:id() or 0) < (b:id() or 0)
				end
				return af.x < bf.x
			end
			return af.y < bf.y
		end
		if af.x == bf.x then
			if af.y == bf.y then
				return (a:id() or 0) < (b:id() or 0)
			end
			return af.y < bf.y
		end
		return af.x < bf.x
	end)

	return screen, screenFrame, windows
end

function M.activeScreenWindows()
	return M.windowsOnScreen(M.activeScreen())
end

function M.screenSortKey(screen)
	-- Stable ordering across launches to make screen cycling predictable.
	local uuid = screen:getUUID()
	if uuid then
		return uuid
	end
	return tostring(screen:id())
end

function M.orderedScreens()
	-- Deterministic ordering for cycling across screens.
	local screens = hs.screen.allScreens()
	table.sort(screens, function(a, b)
		return M.screenSortKey(a) < M.screenSortKey(b)
	end)
	return screens
end

function M.focusScreen(screen)
	-- Click to move focus to a screen even if it has no windows.
	if not screen then
		return
	end
	local currentPos = hs.mouse.absolutePosition()
	local currentScreen = hs.mouse.getCurrentScreen()
	if currentScreen and currentScreen:getUUID() == screen:getUUID() then
		hs.eventtap.leftClick(currentPos)
		return
	end

	local frame = screen:frame()
	-- Click in the bottom-right corner to minimize visual disruption.
	local point = {
		x = frame.x + frame.w - 1,
		y = frame.y + frame.h - 1,
	}
	hs.eventtap.leftClick(point)
	hs.timer.doAfter(0, function()
		hs.mouse.absolutePosition(currentPos)
	end)
end

return M
