return {
    "ibhagwan/fzf-lua",
    lazy = true,
    cond = NotVSCode,
    cmd = "FzfLua",
    dependencies = {
        "nvim-tree/nvim-web-devicons",
        "junegunn/fzf",
    },
    config = function()
        local actions = require("fzf-lua.actions")
        require("fzf-lua").setup({
            "telescope",
            fzf_opts = {
                ["--layout"] = "reverse",
                ["--marker"] = "+",
            },
            winopts = {
                height = 0.60, -- window height
                width = 0.45,
                row = 0.20,
                col = 0.42,
                preview = {
                    hidden = "hidden",
                    layout = "vertical", -- horizontal|vertical|flex
                    vertical = "down:45%", -- up|down:size
                    winopts = { -- builtin previewer window options
                        number = false,
                        relativenumber = false,
                        cursorline = false,
                        cursorcolumn = false,
                        signcolumn = "no",
                        list = false,
                    },
                },
                on_create = function()
                    -- creates a local buffer mapping translating <M-BS> to <C-u>
                    vim.keymap.set(
                        "t",
                        "<Tab>",
                        "<cmd>lua vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<C-n>', true, false, true), 'n', true)<CR>",
                        { nowait = true, buffer = true }
                    )
                    vim.keymap.set(
                        "t",
                        "<S-Tab>",
                        "<cmd>lua vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<C-p>', true, false, true), 'n', true)<CR>",
                        { nowait = true, buffer = true }
                    )
                    vim.keymap.set("t", "<C-l>", "<Esc>", { nowait = true, buffer = true })
                end,
            },
            grep = {
                rg_opts = "--column --line-number --no-heading --color=always --smart-case --max-columns=4096 -uu",
            },
            git = {
                status = {
                    actions = {
                        ["right"] = false,
                        ["left"] = false,
                        ["ctrl-x"] = false,
                        ["ctrl-s"] = { fn = actions.git_stage_unstage, reload = true },
                    },
                },
            },
        })
    end,
}
