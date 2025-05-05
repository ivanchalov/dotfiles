return {
    -- You can easily change to a different colorscheme.
    -- Change the name of the colorscheme plugin below, and then
    -- change the command in the config to whatever the name of that colorscheme is.
    --
    -- If you want to see what colorschemes are already installed, you can use `:Telescope colorscheme`.
    --
    -- NOTE: tokyonight
    {
        "folke/tokyonight.nvim",
        priority = 1000, -- Make sure to load this before all the other start plugins.
        config = function()
            ---@diagnostic disable-next-line: missing-fields
            require("tokyonight").setup {
                styles = {
                    comments = { italic = false }, -- Disable italics in comments
                },
            }

            -- Uncomment to load the colorscheme here.
            -- Like many other themes, this one has different styles, and you could load
            -- any other, such as 'tokyonight-storm', 'tokyonight-moon', or 'tokyonight-day'.
            -- vim.cmd.colorscheme("tokyonight-night")
        end,
    },
    -- NOTE: kanagawa
    {
        "rebelot/kanagawa.nvim",
        priority = 1000, -- Make sure to load this before all the other start plugins
        config = function()
            require("kanagawa").setup {
                -- Enable transparent background
                transparent = true,
                -- Override coloring of markdown to match VSCode
                -- Otherwise markdown is not parsed / colored nicely with treesitter
                overrides = function(colors)
                    return {
                        ["@markup.link.url.markdown_inline"] = { link = "Special" }, -- (url)
                        ["@markup.link.label.markdown_inline"] = { link = "WarningMsg" }, -- [label]
                        ["@markup.italic.markdown_inline"] = { link = "Exception" }, -- *italic*
                        ["@markup.raw.markdown_inline"] = { link = "String" }, -- `code`
                        ["@markup.list.markdown"] = { link = "Function" }, -- + list
                        ["@markup.quote.markdown"] = { link = "Error" }, -- > blockcode
                    }
                end,
            }

            -- setup must be called before loading
            vim.cmd.colorscheme("kanagawa")
        end,
    },
}
