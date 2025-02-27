return {
    {
        "nvim-lualine/lualine.nvim",
        event = "VeryLazy",
        cond = NotVSCode,
        dependencies = {
            "nvim-tree/nvim-web-devicons",
        },
        config = function()
            local function diff_source()
                local gitsigns = vim.b.gitsigns_status_dict
                if gitsigns then
                    return {
                        added = gitsigns.added,
                        modified = gitsigns.changed,
                        removed = gitsigns.removed,
                    }
                end
            end

            local function cwd()
                local full_cwd = vim.fn.getcwd()
                local cwd_table = Split(full_cwd, "/")
                return cwd_table[#cwd_table]
            end

            require("lualine").setup({
                options = {
                    theme = "auto",
                    globalstatus = true,
                    icons_enabled = true,
                    component_separators = { left = "  ", right = "  " },
                    section_separators = { left = "", right = "" },
                },
                extensions = {
                    "neo-tree",
                    "quickfix",
                    "fugitive",
                },
                sections = {
                    lualine_a = {
                        {
                            cwd,
                        },
                    },
                    lualine_b = {
                        {
                            -- "b:gitsigns_head",
                            "FugitiveHead",
                            icon = "",
                            draw_empty = true,
                        },
                    },
                    lualine_c = {
                        -- "mode",
                        { "filename" },
                        {
                            "diagnostics",
                            symbols = { error = "E", warn = "W", info = "I", hint = "H" },
                        },
                        {
                            "diff",
                            source = diff_source,
                        },
                    },
                    lualine_x = {
                        { require("capslock").status_string },
                        {
                            "buffers",
                            icons_enabled = false,
                            max_length = vim.o.columns,
                            max_length = vim.o.columns * 7 / 10,
                            show_filename_only = true,
                            buffers_color = {
                                active = "lualine_a_normal", -- Color for active buffer.
                            },
                            symbols = {
                                modified = "", -- Text to show when the buffer is modified
                                alternate_file = "", -- Text to show to identify the alternate file
                            },
                        },
                    },
                    lualine_y = {},
                    lualine_z = {},
                },
                -- sections = {},
            })
        end,
    },
}
