local silent = { silent = true }

-- Unmap annoying stuff.
vim.keymap.set("n", "q", "<Nop>")
vim.keymap.set("n", "<C-]>", "<Nop>")
vim.keymap.set({ "n", "i", "x", "v" }, "<F1>", "<Nop>")
vim.keymap.set({ "n" }, "s", "<Nop>")
vim.keymap.set({ "n", "i" }, "<MiddleMouse>", "<Nop>")
vim.keymap.set({ "n", "i" }, "<2-MiddleMouse>", "<Nop>")
vim.keymap.set({ "n", "i" }, "<3-MiddleMouse>", "<Nop>")
vim.keymap.set({ "n", "i" }, "<4-MiddleMouse>", "<Nop>")

-- Make < > shifts keep selection.
vim.keymap.set("v", "<", "<gv")
vim.keymap.set("v", ">", ">gv")

-- Easier ~
vim.keymap.set("n", "<leader>`", "~l", { silent = true, desc = "~l" })

-- Make cursor stay at the end of selection after yanking.
vim.keymap.set("v", "y", "ygv<esc>")

-- Visual block mode to free C-v for pasting.
vim.keymap.set("n", "<leader>v", "<C-v>", { silent = true, desc = "Visual block mode" })

vim.keymap.set("i", "kj", "<esc>", silent)
vim.keymap.set("i", "jk", "<esc>", silent)

vim.keymap.set({ "n", "v" }, "H", "0^")
vim.keymap.set({ "n", "v" }, "L", "$")
vim.keymap.set({ "n", "v" }, "J", "6j")
vim.keymap.set({ "n", "v" }, "K", "6k")

-- Add coma to the end of current line
-- NOTE: managed by plugin
-- vim.keymap.set("n", "M", "mcA,<esc>`c")

-- Line without whitespace text-object
vim.keymap.set("x", "il", "g_o^o", silent)
vim.keymap.set("o", "il", ":<c-u>exe 'normal v' . v:count1 . 'il'<CR>", silent)

-- Large word text objects
vim.keymap.set({ "o", "v" }, "iv", "iW")
vim.keymap.set({ "o", "v" }, "av", "aW")

-- Look into treesitter objects
vim.keymap.set("n", "<M-CR>", "<Nop>")

---------------
-- Commands
---------------

-- [[:silent !konsole --separate --workdir $PWD -e fish -ic "run %; echo ''; read -P 'press any key to continue ...' -n1" &<cr>]]
vim.keymap.set("n", "<leader>e", function()
    local file = vim.api.nvim_buf_get_name(0)
    local workdir = vim.fn.getcwd()
    vim.cmd(
        [[silent !systemd-run --same-dir --collect --user fish -ic 'alacritty --working-directory ]]
            .. workdir
            .. [[ -e fish -ic "run ]]
            .. file
            .. [[; sleep inf"' &]]
    )
    -- vim.cmd(
    --     [[silent !systemd-run --slice=safe.slice --same-dir --collect --user fish -ic 'alacritty --working-directory ]]
    --         .. workdir
    --         .. [[ -e fish -ic "run ]]
    --         .. file
    --         .. [[; sleep inf"' &]]
    -- )
end, { silent = true, desc = "Execute file" })

-- vim.keymap.set("n", "<leader>e", function()
--     local file = vim.api.nvim_buf_get_name(0)
--     local workdir = vim.fn.getcwd()
--     vim.cmd([[!kitten @ launch --color background=black --copy-env --hold --cwd current fish -ic "run ]] .. file .. [["]])
-- end, { silent = true, desc = "Execute file" })

vim.keymap.set("n", "<leader>j", function()
    local workdir = vim.fn.getcwd()

    vim.cmd(
        -- [[silent !konsole --separate --workdir ]]
        [[silent !systemd-run --same-dir --collect --user fish -ic 'alacritty --working-directory ]]
            .. workdir
            .. [[ -e fish -ic "just; read -P continuek -n1"' &]]
    )
end, { silent = true, desc = "just test" })
