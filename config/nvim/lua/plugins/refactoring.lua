return {
    {
        "ThePrimeagen/refactoring.nvim",
        event = "VeryLazy",
        -- keys = {
        --     { "<leader>r", mode = { "n", "v" } },
        -- },
        dependencies = {
            { "nvim-lua/plenary.nvim" },
            { "nvim-treesitter/nvim-treesitter" },
            { "nvim-telescope/telescope.nvim" },
        },
        config = function()
            require("refactoring").setup({})
            require("telescope").load_extension("refactoring")
            local nse = { noremap = true, silent = true, expr = false }
            vim.keymap.set("x", "<leader>re", function()
                require("refactoring").refactor("Extract Variable")
            end, { desc = "Extract variable" })
            vim.api.nvim_set_keymap(
                "v",
                "<leader>rr",
                "<Esc><cmd>lua require('telescope').extensions.refactoring.refactors()<CR>",
                { noremap = true, desc = "Telescope refactors" }
            )
            vim.keymap.set("n", "<leader>rp", function()
                require("refactoring").debug.printf({ below = false })
            end, { desc = "Print statement" })
            vim.keymap.set({ "x", "n" }, "<leader>rv", function()
                require("refactoring").debug.print_var()
            end, { desc = "Print variable" })
            vim.api.nvim_set_keymap(
                "n",
                "<leader>rb",
                [[ <Cmd>lua require('refactoring').refactor('Extract Block')<CR>]],
                { noremap = true, silent = true, expr = false, desc = "Extract block" }
            )
            vim.api.nvim_set_keymap(
                "n",
                "<leader>ri",
                [[ <Cmd>lua require('refactoring').refactor('Inline Variable')<CR>]],
                { noremap = true, silent = true, expr = false, desc = "Inline variable" }
            )
            vim.api.nvim_set_keymap("n", "<leader>rc", ":lua require('refactoring').debug.cleanup({})<CR>", {
                noremap = true,
                desc = "cleanup",
            })
            --- TODO move to neogen
            vim.keymap.set("n", "<leader>rn", ":Neogen<cr>")
        end,
    },
}
