-- lazydev.nvim is a plugin that properly configures LuaLS for editing your Neovim config by lazily updating your workspace libraries.
-- https://github.com/folke/lazydev.nvim

return {
    -- `lazydev` configures Lua LSP for your Neovim config, runtime and plugins
    -- used for completion, annotations and signatures of Neovim apis
    "folke/lazydev.nvim",
    ft = "lua",
    opts = {
        library = {
            -- Load luvit types when the `vim.uv` word is found
            { path = "${3rd}/luv/library", words = { "vim%.uv" } },
        },
    },
}
