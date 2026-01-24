local helpers = require("modules.window-manager.helpers")

local function orientGridSpec(screen, cols, rows, colIndex, rowIndex, colSpan, rowSpan)
	-- Swap axes for portrait screens so layouts feel top-to-bottom.
	local spanCols = colSpan or 1
	local spanRows = rowSpan or 1
	if not helpers.isPortrait(screen) then
		return cols, rows, colIndex, rowIndex, spanCols, spanRows
	end
	return rows, cols, rowIndex, colIndex, spanRows, spanCols
end

local function calculateGridFrame(screenFrame, cols, rows, colIndex, rowIndex, colSpan, rowSpan)
	local spanCols = colSpan or 1
	local spanRows = rowSpan or 1
	local cellW = screenFrame.w / cols
	local cellH = screenFrame.h / rows

	return helpers.normalizeFrame({
		x = screenFrame.x + (cellW * colIndex),
		y = screenFrame.y + (cellH * rowIndex),
		w = cellW * spanCols,
		h = cellH * spanRows,
	})
end

local function applyGap(frame, cols, rows, colIndex, rowIndex, colSpan, rowSpan, gapPx)
	-- Full gap at screen edge, half gap at shared borders.
	local spanCols = colSpan or 1
	local spanRows = rowSpan or 1
	local halfGap = gapPx / 2
	local leftInset = (colIndex == 0) and gapPx or halfGap
	local rightInset = ((colIndex + spanCols) == cols) and gapPx or halfGap
	local topInset = (rowIndex == 0) and gapPx or halfGap
	local bottomInset = ((rowIndex + spanRows) == rows) and gapPx or halfGap

	return helpers.normalizeFrame({
		x = frame.x + leftInset,
		y = frame.y + topInset,
		w = frame.w - leftInset - rightInset,
		h = frame.h - topInset - bottomInset,
	})
end

local M = {}

function M.gridFrameWithGap(screen, cols, rows, colIndex, rowIndex, colSpan, rowSpan, gapPx)
	-- Calculate frame in grid coordinates, then apply consistent gaps.
	local screenFrame = screen:frame()
	local gCols, gRows, gColIndex, gRowIndex, gColSpan, gRowSpan =
		orientGridSpec(screen, cols, rows, colIndex, rowIndex, colSpan, rowSpan)
	local base = calculateGridFrame(screenFrame, gCols, gRows, gColIndex, gRowIndex, gColSpan, gRowSpan)
	return applyGap(base, gCols, gRows, gColIndex, gRowIndex, gColSpan, gRowSpan, gapPx)
end

return M
