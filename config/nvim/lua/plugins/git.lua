return {
    {
        "tpope/vim-fugitive",
        event = "VeryLazy",  -- NOTE: used for lualine display
        cond = NotVSCode,
    },
    {
        "rhysd/git-messenger.vim",
        cond = NotVSCode,
        keys = {
            { "<C-g>i", "<Plug>(git-messenger)", mode = { "n" } },
        },
        init = function()
            vim.g.git_messenger_no_default_mappings = true
            vim.g.git_messenger_include_diff = "current"
            vim.g.git_messenger_max_popup_height = 30
        end,
    },
    {
        "lewis6991/gitsigns.nvim",
        event = "VeryLazy",
        cond = NotVSCode,
        opts = {
            current_line_blame_opts = {
                delay = 200,
            },
            on_attach = function(bufnr)
                local gs = package.loaded.gitsigns

                local function map(mode, l, r, opts)
                    opts = opts or {}
                    opts.buffer = bufnr
                    vim.keymap.set(mode, l, r, opts)
                end

                -- Navigation
                map("n", "]c", function()
                    if vim.wo.diff then
                        return "]c"
                    end
                    vim.schedule(function()
                        gs.next_hunk()
                    end)
                    return "<Ignore>"
                end, { expr = true, desc = "next_hunk" })

                map("n", "[c", function()
                    if vim.wo.diff then
                        return "[c"
                    end
                    vim.schedule(function()
                        gs.prev_hunk()
                    end)
                    return "<Ignore>"
                end, { expr = true, desc = "prev_hunk" })

                -- Actions
                map({ "n", "v" }, "<C-g>ha", ":Gitsigns stage_hunk<CR>")
                map({ "n", "v" }, "<C-g>hr", ":Gitsigns reset_hunk<CR>")
                map("n", "<C-g>hu", gs.undo_stage_hunk, { desc = "stage_hunk" })
                map("n", "<C-g>hR", gs.reset_buffer, { desc = "reset_buffer" })
                map("n", "<C-g>hp", gs.preview_hunk, { desc = "preview__hunk" })
                map("n", "<C-g>hb", function()
                    gs.blame_line({ full = true })
                end, { desc = "blame_line" })
                map("n", "<C-g>tb", gs.toggle_current_line_blame, { desc = "toggle_current_line_blame" })
                map("n", "<C-g>hd", gs.diffthis, { desc = "diffthis" })
                map("n", "<C-g>hD", function()
                    gs.diffthis("~")
                end, { desc = "diffthis(~)" })
                map("n", "<C-g>td", gs.toggle_deleted, { desc = "toggle_deleted" })

                -- Text object
                map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>")
            end,
        },
    },
}
