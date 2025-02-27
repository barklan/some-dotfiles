return {
    {
        "rebelot/kanagawa.nvim",
        compile = false,
        enabled = true,
        lazy = false,
        priority = 1000,
        cond = NotVSCode,
        config = function()
            require("kanagawa").setup({
                -- transparent = true,
                compile = false,
                dimInactive = false,
                globalStatus = true,
                theme = "wave", -- wave
                colors = {
                    theme = {
                        all = {
                            ui = {
                                bg_gutter = "none",
                            },
                        },
                    },
                },
                overrides = function(_)
                    return {
                        Comment = { fg = "#FFB6C1" },
                        TSComment = { fg = "#FFB6C1" },
                        CursorLine = { bg = "#2A2A37" },
                        TelescopeBorder = { fg = "#DCD7BA" },
                        NeoTreeWinSeparator = { fg = "#54546D" },
                        HlSearchNear = { bg = "#2D4F67" },
                        HlSearchLens = { bg = "#2D4F67" },
                        HlSearchLensNear = { bg = "#2D4F67" },
                        ScrollView = {bg = "#54546D"},
                        Headline = {bg = "#333543"},
                        -- TODO: more subtle highlight bg color
                        IlluminatedWordText = {bg = "#333543"},
                        IlluminatedWordRead = {bg = "#333543"},
                        IlluminatedWordWrite = {bg = "#333543"},
                    }
                end,
            })
        end,
    },
    {
        "mcchrish/zenbones.nvim",
        enabled = true,
        lazy = false,
        priority = 1000,
        cond = NotVSCode,
        dependencies = {
            "rktjmp/lush.nvim",
        },
        config = function()
            vim.g.zenwritten_lightness = "bright"
            vim.g.zenwritten_darkness = "stark"
            vim.g.vimbones_darkness = "stark"
            vim.g.zenwritten_lighten_comments = 50
            vim.g.zenwritten_darken_comments = 50
            vim.g.vimbones_darken_comments = 50
        end,
    },
    {
        "folke/tokyonight.nvim",
        enabled = true,
        lazy = false,
        priority = 1000,
        cond = NotVSCode,
        config = function()
            require("tokyonight").setup({
                day_brightness = 0.15,
                -- lualine_bold = true,
                on_highlights = function(hl, _)
                    hl.TSComment = {
                        fg = "#FFB6C1",
                    }
                    hl.Comment = {
                        fg = "#FFB6C1",
                    }
                    -- NOTE: this is used for terminal
                    hl.Normal = { bg = "none"}
                    hl.NormalNC = { bg = "none"}
                    hl.SignColumn = { bg = "none"}
                end,
            })
        end,
    },
}
