return {
    {
        "xiyaowong/accelerated-jk.nvim",
        lazy = true,
        keys = {
            { "j", silent = true },
            { "k", silent = true },
        },
        opts = {
            acceleration_limit = 35,
            acceleration_table = { 1, 3, 5, 7, 9 },
        },
    },
    {
        "tummetott/unimpaired.nvim",
        event = "VeryLazy",
        opts = {},
    },
    {
        "wellle/targets.vim",
        event = "VeryLazy",
    },
    {
        "Julian/vim-textobj-variable-segment",
        event = "VeryLazy",
        dependencies = {
            "kana/vim-textobj-user",
        },
    },
    {
        "gbprod/cutlass.nvim",
        -- NOTE: need not lazy, otherwise flaky
        lazy = false,
        keys = { "c", "C", "d", "D", "x", "X" },
        opts = {
            cut_key = "x",
            override_del = nil,
            exclude = { "ns", "nS" },
        },
    },
    {
        "Wansmer/treesj",
        lazy = true,
        keys = { "<space>m" },
        dependencies = { "nvim-treesitter/nvim-treesitter" },
        config = function()
            require("treesj").setup({
                use_default_keymaps = true,
            })
            vim.keymap.set("n", "<leader>m", require("treesj").toggle, { desc = "treesj toggle" })
        end,
    },
    {
        "haya14busa/vim-asterisk",
        lazy = true,
        keys = {
            { "*", [[<Plug>(asterisk-z*)]], mode = { "n", "x" } },
            { "#", [[<Plug>(asterisk-z#)]], mode = { "n", "x" } },
            { "g*", [[<Plug>(asterisk-gz*)]], mode = { "n", "x" } },
            { "g#", [[<Plug>(asterisk-gz#)]], mode = { "n", "x" } },
        },
    },
    {
        "ggandor/leap.nvim",
        lazy = true,
        keys = {
            { "s", mode = { "n", "v", "o" } },
            { "S", mode = { "n", "v", "o" } },
        },
        config = function()
            -- TODO: not enabled, mini surround has s keymap
            -- require("leap").set_default_keymaps()
            require("leap").setup({
                case_insensitive = true,
            })
        end,
    },
    {
        "ggandor/flit.nvim",
        lazy = true,
        keys = {
            { "f", mode = { "n", "v", "o" } },
            { "F", mode = { "n", "v", "o" } },
            { "t", mode = { "n", "v", "o" } },
            { "T", mode = { "n", "v", "o" } },
        },
        config = true,
        dependencies = {
            "ggandor/leap.nvim",
        },
    },
    {
        "phaazon/hop.nvim",
        branch = "v2",
        lazy = true,
        keys = {
            { "<leader><tab>", "<cmd> lua require'hop'.hint_words()<cr>", mode = { "n", "v" } },
        },
        opts = {
            quit_key = "<Space>",
            uppercase_labels = true,
            keys = 'jfkdls;a',
        },
    },
    {
        "gbprod/substitute.nvim",
        lazy = true,
        keys = {
            { ",", "<cmd>lua require('substitute').operator()<cr>", mode = { "n" } },
            { ",", "<cmd>lua require('substitute').visual()<cr>", mode = { "x" } },
        },
        opts = {},
    },
    {
        "monaqa/dial.nvim",
        lazy = true,
        cond = NotVSCode,
        keys = {
            { "<C-a>", mode = { "n" } },
            { "<C-a>", mode = { "v" } },
            { "<C-x>", mode = { "n" } },
            { "<C-x>", mode = { "v" } },
        },
        config = function()
            local augend = require("dial.augend")
            require("dial.config").augends:register_group({
                -- default augends used when no group name is specified
                default = {
                    augend.integer.alias.decimal, -- nonnegative decimal number (0, 1, 2, 3, ...)
                    augend.hexcolor.new({
                        case = "lower",
                    }),
                    augend.constant.alias.bool, -- boolean value (true <-> false)
                    augend.date.alias["%Y-%m-%d"],
                    augend.constant.new({
                        elements = { "and", "or" },
                        word = true, -- if false, "sand" is incremented into "sor", "doctor" into "doctand", etc.
                        cyclic = true,
                    }),
                    augend.constant.new({
                        elements = { "&&", "||" },
                        word = false,
                        cyclic = true,
                    }),
                    augend.constant.new({
                        elements = { "==", "!=" },
                        word = false,
                        cyclic = true,
                    }),
                    augend.constant.new({
                        elements = { "True", "False" },
                        word = false,
                        cyclic = true,
                    }),
                },
            })
            vim.keymap.set("n", "<C-a>", require("dial.map").inc_normal(), { noremap = true })
            vim.keymap.set("n", "<C-x>", require("dial.map").dec_normal(), { noremap = true })
            vim.keymap.set("v", "<C-a>", require("dial.map").inc_visual(), { noremap = true })
            vim.keymap.set("v", "<C-x>", require("dial.map").dec_visual(), { noremap = true })
        end,
    },
    {
        "barklan/readline.nvim",
        lazy = false,
        -- cond = NotVSCode,
        config = function()
            local readline = require("readline")
            vim.keymap.set("!", "<M-f>", readline.forward_word)
            vim.keymap.set("!", "<M-b>", readline.backward_word)
            vim.keymap.set("!", "<C-a>", readline.beginning_of_line)
            vim.keymap.set("!", "<C-M-e>", readline.end_of_line)
            vim.keymap.set("!", "<M-d>", readline.kill_word)
            vim.keymap.set("!", "<C-k>", readline.kill_line)
            vim.keymap.set("!", "<C-u>", readline.backward_kill_line)
            vim.keymap.set("!", "<C-f>", "<Right>")
            vim.keymap.set("!", "<C-b>", "<Left>")
        end,
    },
    {
        "barklan/capslock.nvim",
        lazy = true,
        cond = NotVSCode,
        keys = {
            { "<C-l>", "<Plug>CapsLockToggle", mode = { "i" } },
            { "<C-g>c", "<Plug>CapsLockToggle", mode = { "n" } },
        },
        opts = {},
    },
    {
        "saifulapm/chartoggle.nvim",
        lazy = true,
        keys = {
            "<leader>,",
            "<leader>;",
        },
        config = function()
            require("chartoggle").setup({
                leader = "<leader>",
                keys = { ",", ";" },
            })
        end,
    },
}
