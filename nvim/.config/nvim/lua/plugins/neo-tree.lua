-- Neo-tree is a Neovim plugin to browse the file system and other tree like structures in whatever style suits you, including sidebars, floating windows, netrw split style, or all of them at once!
-- https://github.com/nvim-neo-tree/neo-tree.nvim

return {
    "nvim-neo-tree/neo-tree.nvim",
    version = "*",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
        "MunifTanjim/nui.nvim",
    },
    cmd = "Neotree",
    keys = {
        { "\\", ":Neotree reveal<CR>", desc = "NeoTree reveal", silent = true },
    },
    opts = {
        filesystem = {
            -- show dot-files, git-ignored files, etc.
            filtered_items = {
                visible = true, -- when true, still use a dim highlight so you know they’re “hidden”
                hide_dotfiles = false, -- show files that start with “.”
                hide_gitignored = false, -- show files in .gitignore
                -- you can also fine-tune with `hide_by_name`, `hide_by_pattern`, `never_show`, etc.
            },

            window = {
                mappings = {
                    ["\\"] = "close_window",
                    -- optional: keep the live toggle if you want
                    ["H"] = "toggle_hidden",
                },
            },
        },
    },
}
