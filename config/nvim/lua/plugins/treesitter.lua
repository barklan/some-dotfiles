return {
    -- {"lewis6991/spellsitter.nvim"},
    {
        "nvim-treesitter/nvim-treesitter",
        lazy = true,
        event = "VeryLazy",
        build = ":TSUpdate",
        dependencies = {
            { "nvim-treesitter/nvim-treesitter-textobjects" },
            { "windwp/nvim-ts-autotag" },
            { "RRethy/nvim-treesitter-textsubjects" },
            { "RRethy/nvim-treesitter-endwise" },
            { "theHamsta/nvim-treesitter-pairs" },
            { "IndianBoy42/tree-sitter-just" },
        },
        config = function()
            local treesitter = require("nvim-treesitter.configs")

            treesitter.setup({
                ensure_installed = "all",
                ignore_install = { "hoon" },
                incremental_selection = {
                    enable = true,
                    keymaps = {
                        init_selection = "<CR>",
                        node_incremental = "<CR>",
                        scope_incremental = "grc",
                        node_decremental = "<M-CR>",
                    },
                },
                highlight = {
                    enable = true,
                    additional_vim_regex_highlighting = false,
                },
                autotag = {
                    enable = true,
                },
                indent = {
                    enable = true,
                },
                endwise = {
                    enable = true,
                },
                textsubjects = {
                    enable = true,
                    prev_selection = ",",
                    keymaps = {
                        ["."] = "textsubjects-smart",
                        ["a;"] = "textsubjects-container-outer",
                        ["i;"] = "textsubjects-container-inner",
                    },
                },

                pairs = {
                    enable = true,
                    disable = {},
                    highlight_pair_events = { "CursorMoved" }, -- e.g. {"CursorMoved"}, -- when to highlight the pairs, use {} to deactivate highlighting
                    highlight_self = false, -- whether to highlight also the part of the pair under cursor (or only the partner)
                    goto_right_end = true, -- whether to go to the end of the right partner or the beginning
                    fallback_cmd_normal = "call matchit#Match_wrapper('',1,'n')", -- What command to issue when we can't find a pair (e.g. "normal! %")
                    keymaps = {
                        goto_partner = "%",
                        -- delete_balanced = "<leader>;",
                    },
                    delete_balanced = {
                        only_on_first_char = false, -- whether to trigger balanced delete when on first character of a pair
                        fallback_cmd_normal = nil, -- fallback command when no pair found, can be nil
                        longest_partner = false, -- whether to delete the longest or the shortest pair when multiple found.
                        -- E.g. whether to delete the angle bracket or whole tag in  <pair> </pair>
                    },
                },
                textobjects = {
                    select = {
                        enable = true,
                        lookahead = true,
                        keymaps = {
                            ["af"] = "@function.outer",
                            ["if"] = "@function.inner",
                            -- ia and aa (a for argument) are already taken via welle/targets.vim
                            ["ix"] = "@parameter.inner",
                            ["ax"] = "@parameter.outer",
                            ["ak"] = "@comment.outer",
                        },
                    },
                    swap = {
                        enable = true,
                        swap_next = {
                            ["<leader>ra"] = "@parameter.inner",
                        },
                        swap_previous = {
                            ["<leader>rA"] = "@parameter.inner",
                        },
                    },
                    move = {
                        enable = true,
                        set_jumps = true,
                        goto_next_start = {
                            ["]m"] = "@function.outer",
                            ["]]"] = "@class.outer",
                        },
                        goto_next_end = {
                            ["]M"] = "@function.outer",
                            ["]["] = "@class.outer",
                        },
                        goto_previous_start = {
                            ["[m"] = "@function.outer",
                            ["[["] = "@class.outer",
                        },
                        goto_previous_end = {
                            ["[M"] = "@function.outer",
                            ["[]"] = "@class.outer",
                        },
                    },
                },
            })
            if vim.g.vscode ~= nil then
                vim.cmd("TSDisable highlight")
            end
        end,
    },
    {
        "nvim-treesitter/nvim-treesitter-context",
        event = "VeryLazy",
        cond = NotVSCode,
        opts = {
            -- mode = "topline",
            mode = "cursor",
            max_lines = 2,
        },
        dependencies = {
            "nvim-treesitter/nvim-treesitter",
        },
    },
    {
        "numToStr/Comment.nvim",
        event = "VeryLazy",
        cond = NotVSCode,
        dependencies = {
            "nvim-treesitter/nvim-treesitter",
        },
        config = function()
            require("Comment").setup({})
            local api = require("Comment.api")
            vim.keymap.set("n", "<leader>k", api.toggle.linewise.current, { desc = "Toggle line comment." })
            local esc = vim.api.nvim_replace_termcodes("<ESC>", true, false, true)
            vim.keymap.set("x", "<leader>k", function()
                vim.api.nvim_feedkeys(esc, "nx", false)
                api.toggle.linewise(vim.fn.visualmode())
            end)
            vim.keymap.set("n", "<leader>c", api.insert.linewise.eol, { desc = "Add comment at the end of line." })
        end,
    },
}
