return {
    {
        "nvim-tree/nvim-web-devicons",
        lazy = true,
        enabled = true,
        opts = {
            color_icons = false,
            strict = true,
            default = true,
        },
    },
    -- {
    --     "stevearc/dressing.nvim",
    --     event = "VeryLazy",
    --     cond = NotVSCode,
    -- },
    {
        "rcarriga/nvim-notify",
        event = "VeryLazy",
        config = function()
            require("notify").setup({
                fps = 60,
                render = "simple",
                -- stages = "fade",
                stages = "static",
            })
            vim.notify = require("notify")
        end,
    },
    {
        "folke/which-key.nvim",
        event = "VeryLazy",
        cond = NotVSCode,
        init = function()
            vim.o.timeout = true
            vim.o.timeoutlen = 500
        end,
        opts = {},
    },
    {
        "kevinhwang91/nvim-bqf",
        cond = NotVSCode,
        ft = "qf",
        opts = {
            auto_enable = true,
        },
    },
    -- {
    --     "yorickpeterse/nvim-pqf",
    --     cond = NotVSCode,
    --     ft = "qf",
    --     config = true,
    -- },
    {
        "dstein64/nvim-scrollview",
        event = "VeryLazy",
        cond = NotVSCode,
        opts = {
            excluded_filetypes = { "neo-tree" },
            diagnostics_severities = { vim.diagnostic.severity.ERROR },
        },
    },
    {
        "lukas-reineke/headlines.nvim",
        cond = NotVSCode,
        ft = "markdown",
        dependencies = {
            "nvim-treesitter/nvim-treesitter",
        },
        config = function()
            require("headlines").setup({
                markdown = {
                    fat_headlines = false,
                    codeblock_highlight = false,
                    quote_highlight = false,
                    bullets = {},
                },
            })
        end,
    },
    -- {
    --     "NvChad/nvim-colorizer.lua",
    --     event = "VeryLazy",
    --     cond = NotVSCode,
    --     config = function()
    --         require("colorizer").setup({
    --             filetypes = {
    --                 "css",
    --                 "javascript",
    --                 "html",
    --             },
    --         })
    --     end,
    -- },
    {
        "RRethy/vim-illuminate",
        event = "VeryLazy",
        cond = NotVSCode,
        config = function()
            require("illuminate").configure({
                -- under_cursor = false,
                -- delay = 100,
            })
        end,
    },
}
