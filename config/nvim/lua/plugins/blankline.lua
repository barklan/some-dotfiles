return {
    {
        "lukas-reineke/indent-blankline.nvim",
        -- NOTE: Too much rendering overhead.
        main = "ibl",
        enabled = false,
        cond = NotVSCode,
        event = "VeryLazy",
        init = function()
            vim.g.indent_blankline_use_treesitter = true
            vim.g.indent_blankline_show_first_indent_level = false
            vim.g.indent_blankline_show_trailing_blankline_indent = false
            vim.g.indent_blankline_use_treesitter_scope = false
        end,
        config = function()
            require("ibl").setup({
                -- show_current_context = true,
                -- show_current_context_start = false,
            })
        end,
    },
}
