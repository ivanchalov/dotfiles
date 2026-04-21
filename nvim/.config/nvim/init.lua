-- Plugins to load
vim.pack.add {
  "https://github.com/catppuccin/nvim",
  "https://github.com/nvim-tree/nvim-web-devicons",
  "https://github.com/neovim/nvim-lspconfig",
  "https://github.com/nvim-mini/mini.nvim",
  "https://github.com/ibhagwan/fzf-lua",
  "https://github.com/lewis6991/gitsigns.nvim",
  "https://github.com/nvim-lualine/lualine.nvim",
  "https://github.com/romgrk/barbar.nvim",
  "https://github.com/christoomey/vim-tmux-navigator",
}
vim.cmd.packadd("nvim.undotree")

-- Set colorscheme
vim.cmd.colorscheme("catppuccin")

-- setup() calls
require("nvim-web-devicons").setup()
require("mini.files").setup()
require("mini.surround").setup()
require("mini.pairs").setup()
require("gitsigns").setup({
  signs = {
    add = { text = "+" },
    change = { text = "~" },
    delete = { text = "_" },
    topdelete = { text = "‾" },
    changedelete = { text = "~" },
  },
})
require("lualine").setup({
  sections = {
    lualine_c = {
      "diagnostics",
      { "filename", path = 1 },
    },
    lualine_x = { },
  },
})

-- Options
vim.opt.number = true               -- Print current line number
vim.opt.relativenumber = true       -- Enable relative line numbers for jumping
vim.opt.cursorline = true           -- Highlight line under the cursor
vim.opt.ignorecase = true           -- Ignore case when searching with "/"
vim.opt.smartcase = true            -- Unless search string has capital letters
vim.opt.clipboard = "unnamedplus"   -- Share OS and nvim clipboard
vim.opt.smoothscroll = true         -- Smoother scroll
vim.opt.mouse = "a"                 -- Enable mouse in all modes
vim.opt.mousemodel = "popup_setpos" -- Right-click moves cursor where clicked and opens popup menu
vim.opt.mousescroll = "ver:2,hor:3" -- Smoother mouse scroll
vim.opt.mousefocus = true           -- Can move window focus with mouse
vim.opt.cmdheight = 0               -- Hide cmd line unless active
vim.opt.expandtab = true            -- Replace tabs with 2 spaces, if python - with 4 spaces
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2
vim.api.nvim_create_autocmd("FileType", {
  pattern = "python",
  callback = function()
    vim.opt_local.expandtab = true
    vim.opt_local.tabstop = 4
    vim.opt_local.shiftwidth = 4
    vim.opt_local.softtabstop = 4
  end,
})
vim.opt.wrap = true                 -- Wrap lines at the end of the screen
vim.opt.linebreak = true            -- Break nicely rather than mid-word
vim.opt.breakindent = true          -- Keep indent after the break
vim.opt.undofile = true             -- Persist undo history even if nvim is closed
vim.opt.splitright = true           -- By default, split right when vertical
vim.opt.splitbelow = true           -- By default, split below when horizontal
vim.opt.list = true                 -- Show whitespace characters as on the next line
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }
vim.opt.inccommand = "split"        -- Preview replace commands
vim.opt.confirm = true              -- Ask for confirmation for an operation that would otherwise fail due to unsaved changes (e.g. ":q")

-- Keymaps
vim.g.mapleader = " "

vim.keymap.set("n", "-", "<Cmd>lua MiniFiles.open()<CR>", { desc = "Open file explorer" })

vim.keymap.set("n", "<leader>u", "<Cmd>Undotree<CR>", { desc = "Open undotree" })

vim.keymap.set("n", "<Esc>", "<Cmd>nohlsearch<CR>", { desc = "Clear search highlight on <Esc>" })

vim.keymap.set("i", "jj", "<Esc>", { desc = "Exit Insert mode" })

vim.keymap.set("n", "j", function()
  return vim.v.count == 0 and "gj" or "j"
end, { expr = true, desc = "Move down by screen line" })
vim.keymap.set("n", "k", function()
  return vim.v.count == 0 and "gk" or "k"
end, { expr = true, desc = "Move up by screen line" })

vim.keymap.set("n", "<D-j>", "gjzz", { desc = "Move down by screen line and center" })
vim.keymap.set("n", "<D-k>", "gkzz", { desc = "Move up by screen line and center" })

vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Half-page down and center" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Half-page up and center" })

vim.keymap.set("x", "J", ":m '>+1<CR>gv-gv", { silent = true, desc = "Move selected lines up" })
vim.keymap.set("x", "K", ":m '<-2<CR>gv-gv", { silent = true, desc = "Move selected lines down" })

vim.keymap.set("v", "<", "<gv", { desc = "Decrease indent and reselect" })
vim.keymap.set("v", ">", ">gv", { desc = "Increase indent and reselect" })

vim.keymap.set("n", "<CR>", "van", { remap = true, desc = "Start treesitter selection" })
vim.keymap.set("x", "<CR>", "an", { remap = true, desc = "Expand treesitter selection" })
vim.keymap.set("x", "<BS>", "in", { remap = true, desc = "Shrink treesitter selection" })

-- vim.keymap.set("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus left" })
-- vim.keymap.set("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus down" })
-- vim.keymap.set("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus up" })
-- vim.keymap.set("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus right" })
vim.keymap.set("n", "<C-h>", "<Cmd>TmuxNavigateLeft<CR>", { desc = "Move focus left" })
vim.keymap.set("n", "<C-j>", "<Cmd>TmuxNavigateDown<CR>", { desc = "Move focus down" })
vim.keymap.set("n", "<C-k>", "<Cmd>TmuxNavigateUp<CR>", { desc = "Move focus up" })
vim.keymap.set("n", "<C-l>", "<Cmd>TmuxNavigateRight<CR>", { desc = "Move focus right" })

vim.keymap.set("n", "[b", "<Cmd>BufferPrevious<CR>", { desc = "Previous buffer" })
vim.keymap.set("n", "]b", "<Cmd>BufferNext<CR>", { desc = "Next buffer" })
vim.keymap.set("n", "<leader>b,", "<Cmd>BufferPrevious<CR>", { desc = "Previous buffer" })
vim.keymap.set("n", "<leader>b.", "<Cmd>BufferNext<CR>", { desc = "Next buffer" })
vim.keymap.set("n", "<leader>b<", "<Cmd>BufferMovePrevious<CR>", { desc = "Re-order buffer to previous" })
vim.keymap.set("n", "<leader>b>", "<Cmd>BufferMoveNext<CR>", { desc = "Re-order buffer to next" })
vim.keymap.set("n", "<leader>1", "<Cmd>BufferGoto 1<CR>", { desc = "Go to buffer #1" })
vim.keymap.set("n", "<leader>2", "<Cmd>BufferGoto 2<CR>", { desc = "Go to buffer #2" })
vim.keymap.set("n", "<leader>3", "<Cmd>BufferGoto 3<CR>", { desc = "Go to buffer #3" })
vim.keymap.set("n", "<leader>4", "<Cmd>BufferGoto 4<CR>", { desc = "Go to buffer #4" })
vim.keymap.set("n", "<leader>5", "<Cmd>BufferGoto 5<CR>", { desc = "Go to buffer #5" })
vim.keymap.set("n", "<leader>6", "<Cmd>BufferGoto 6<CR>", { desc = "Go to buffer #6" })
vim.keymap.set("n", "<leader>bp", "<Cmd>BufferPick<CR>", { desc = "Magic pick buffer" })
vim.keymap.set("n", "<leader>bc", "<Cmd>BufferClose<CR>", { desc = "Close current buffer" })  -- Use for tabs
vim.keymap.set("n", "<leader>bd", "<Cmd>bdelete<CR>", { desc = "Delete current buffer" })     -- Use for other buffers, e.g. undotree, help, diagnostics, etc

vim.keymap.set("n", "<leader>ff", "<Cmd>FzfLua files<CR>", { desc = "Find files" })
vim.keymap.set("n", "<leader>fg", "<Cmd>FzfLua grep_project<CR>", { desc = "Grep project" })
vim.keymap.set("n", "<leader>/", "<Cmd>FzfLua blines<CR>", { desc = "Fuzzy search current buffer" })
vim.keymap.set("n", "<leader>fr", "<Cmd>FzfLua resume<CR>", { desc = "Resume last fzf picker" })

-- A bit more heavy and elaborative keymap for JSON pretty print and compact via jq CLI
local function jq_range(compact, l1, l2)
  local r = vim.system(compact and { "jq", "-c", "." } or { "jq", "." }, {
    stdin = table.concat(vim.api.nvim_buf_get_lines(0, l1 - 1, l2, false), "\n"),
    text = true,
  }):wait()
  if r.code ~= 0 then return vim.notify(r.stderr:gsub("%s+$", ""), vim.log.levels.ERROR) end
  vim.api.nvim_buf_set_lines(0, l1 - 1, l2, false, vim.split(r.stdout:gsub("\n$", ""), "\n", { plain = true }))
end

vim.api.nvim_create_user_command("JsonPretty",  function(o) jq_range(false, o.line1, o.line2) end, { range = true })
vim.api.nvim_create_user_command("JsonCompact", function(o) jq_range(true,  o.line1, o.line2) end, { range = true })

vim.keymap.set("n", "<leader>jqp", "<Cmd>%JsonPretty<CR>", { desc = "JSON pretty print whole buffer" })
vim.keymap.set("x", "<leader>jqp", ":JsonPretty<CR>", { desc = "JSON pretty print visual selection" })
vim.keymap.set("n", "<leader>jqc", "<Cmd>%JsonCompact<CR>", { desc = "JSON compact whole buffer" })
vim.keymap.set("x", "<leader>jqc", ":JsonCompact<CR>", { desc = "JSON compact visual selection" })

-- A simple tabout implementation
local closers = {
  [")"] = true,
  ["]"] = true,
  ["}"] = true,
  ['"'] = true,
  ["'"] = true,
  ["`"] = true,
}

local function tabout()
  local _, col = unpack(vim.api.nvim_win_get_cursor(0))
  local ws, ch = vim.api.nvim_get_current_line():sub(col + 1):match("^([ \t]*)(.)")
  return ch and closers[ch] and string.rep("<Right>", #ws + 1) or "<Tab>"
end

vim.keymap.set("i", "<Tab>", tabout, { expr = true, desc = "Tab out" })

-- Autocommands
vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function() vim.highlight.on_yank() end,
})
