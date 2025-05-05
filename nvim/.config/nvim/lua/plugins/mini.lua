-- Library of 40+ independent Lua modules improving overall Neovim (version 0.9 and higher) experience with minimal effort. They all share same configuration approaches and general design principles.
-- Think about this project as "Swiss Army knife" among Neovim plugins: it has many different independent tools (modules) suitable for most common tasks. Each module can be used separately without any startup and usage overhead.
-- If you want to help this project grow but don't know where to start, check out contributing guides or leave a Github star for 'mini.nvim' project and/or any its standalone Git repositories.
-- https://github.com/echasnovski/mini.nvim

return {
    -- Collection of various small independent plugins/modules
    "echasnovski/mini.nvim",
    config = function()
        -- Better Around/Inside textobjects
        --
        -- Examples:
        --  - va)  - [V]isually select [A]round [)]paren
        --  - yinq - [Y]ank [I]nside [N]ext [Q]uote
        --  - ci'  - [C]hange [I]nside [']quote
        require("mini.ai").setup { n_lines = 500 }

        -- Add/delete/replace surroundings (brackets, quotes, etc.)
        --
        -- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
        -- - sd'   - [S]urround [D]elete [']quotes
        -- - sr)'  - [S]urround [R]eplace [)] [']
        require("mini.surround").setup()

        -- Better commenting functionality
        require("mini.comment").setup()

        -- Highlight white trailspace
        require("mini.trailspace").setup()

        -- Split / Join arguments
        require("mini.splitjoin").setup {
            mappings = {
                toggle = "", -- Disable default mapping
                split = "sk", -- Split agruments
                join = "sj", -- Join arguments
            },
        }

        -- Simple and easy statusline.
        --  You could remove this setup call if you don't like it,
        --  and try some other statusline plugin
        local statusline = require("mini.statusline")
        -- set use_icons to true if you have a Nerd Font
        statusline.setup { use_icons = vim.g.have_nerd_font }

        -- You can configure sections in the statusline by overriding their
        -- default behavior. For example, here we set the section for
        -- cursor location to LINE:COLUMN
        ---@diagnostic disable-next-line: duplicate-set-field
        statusline.section_location = function() return "%2l:%-2v" end

        -- ... and there is more!
        --  Check out: https://github.com/echasnovski/mini.nvim
    end,
}
