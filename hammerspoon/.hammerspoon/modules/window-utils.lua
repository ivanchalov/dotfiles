-- Shared screen/space helpers for window-manager and app-launcher.
local M = {}

function M.activeScreen()
	-- Use the focused space display when possible; fallback to mouse screen.
	if hs.spaces and hs.spaces.focusedSpace and hs.spaces.spaceDisplay then
		local space = hs.spaces.focusedSpace()
		if space then
			local uuid = hs.spaces.spaceDisplay(space)
			if uuid then
				local screen = hs.screen.find(uuid)
				if screen then
					return screen
				end
			end
		end
	end
	return hs.mouse.getCurrentScreen()
end

function M.activeSpaceForScreen(screen)
	-- hs.spaces.activeSpaces() can return a single id or a table of ids.
	if not screen or not hs.spaces or not hs.spaces.activeSpaces then
		return nil
	end
	local activeSpaces = hs.spaces.activeSpaces()
	if not activeSpaces then
		return nil
	end
	local uuid = screen:getUUID()
	if not uuid then
		return nil
	end
	local spaces = activeSpaces[uuid]
	if type(spaces) == "table" then
		return spaces[1]
	end
	return spaces
end

function M.windowSpaces(win)
	-- Some APIs want a window id, others accept the window object.
	if not win or not hs.spaces or not hs.spaces.windowSpaces then
		return nil
	end
	local winId = win:id()
	local spaces = winId and hs.spaces.windowSpaces(winId) or nil
	if not spaces then
		spaces = hs.spaces.windowSpaces(win)
	end
	return spaces
end

function M.windowInSpace(win, spaceId, allowUnknown)
	-- Some windows don't report their spaces; allowUnknown keeps them visible.
	if not spaceId or not hs.spaces or not hs.spaces.windowSpaces then
		return true
	end
	local spaces = M.windowSpaces(win)
	if not spaces or #spaces == 0 then
		return allowUnknown == true
	end
	for _, id in ipairs(spaces) do
		if id == spaceId then
			return true
		end
	end
	return false
end

function M.moveWindowToSpace(win, spaceId)
	-- Call both variants to be resilient across window types/apps.
	if not spaceId or not hs.spaces or not hs.spaces.moveWindowToSpace then
		return
	end
	if M.windowInSpace(win, spaceId, false) then
		return
	end
	local winId = win:id()
	if winId then
		hs.spaces.moveWindowToSpace(winId, spaceId)
	end
	hs.spaces.moveWindowToSpace(win, spaceId)
end

return M
