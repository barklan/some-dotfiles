vim.api.nvim_create_augroup("mynvim", {})

vim.api.nvim_create_autocmd({ "FileType" }, {
    group = "main",
    pattern = { "gitcommit", "markdown", "text" },
    callback = function()
        vim.opt_local.spell = false
        -- vim.cmd(":TSContextDisable")
    end,
})

vim.api.nvim_create_autocmd({ "ModeChanged" }, {
    group = "main",
    pattern = { "*:no*" },
    -- command = "set relativenumber",
    callback = function()
        vim.opt.relativenumber = true
    end,
})

vim.api.nvim_create_autocmd({ "ModeChanged" }, {
    group = "main",
    pattern = { "no*:*" },
    callback = function()
        vim.opt.relativenumber = false
    end,
})

vim.api.nvim_create_autocmd({ "FocusGained", "WinLeave" }, {
    group = "mynvim",
    pattern = "*",
    command = "checktime",
})

-- INFO: Main enter logic
vim.api.nvim_create_autocmd({ "VimEnter" }, {
    group = "main",
    pattern = "*",
    callback = function()
        vim.defer_fn(function()
            GitFetchMainBranch()
        end, 700)
    end,
})

vim.api.nvim_create_augroup("neotree_autoopen", { clear = true })
vim.api.nvim_create_autocmd("VimEnter", { -- Changed from BufReadPre
    desc = "Open neo-tree on enter",
    group = "neotree_autoopen",
    once = true,
    callback = function()
        local num_args = vim.fn.argc()
        if num_args == 0 and IsScrollbackPager() == false then
            if not vim.g.neotree_opened then
                vim.defer_fn(function()
                    vim.cmd("Neotree show")
                    vim.g.neotree_opened = true
                end, 0)
            end
        end
    end,
})

vim.api.nvim_create_autocmd({ "BufWritePost" }, {
    group = "main",
    pattern = "COMMIT_EDITMSG",
    callback = function()
        vim.defer_fn(function()
            vim.defer_fn(GitPushAsyncNotify, 0)
            vim.cmd(':execute "normal `A"')
            vim.cmd(":Neotree close")
            vim.cmd(":Neotree show")
        end, 200)
    end,
})

local git_notify_behind = function()
    require("plenary.job")
        :new({
            command = "git",
            args = { "notify-behind" },
            cwd = vim.fn.getcwd(),
            on_exit = function(j, return_val)
                if return_val ~= 0 then
                    vim.notify("Failed fetching default branch!", "warn")
                end
            end,
        })
        :start()
end

vim.api.nvim_create_autocmd({ "BufWinEnter" }, {
    group = "main",
    pattern = "COMMIT_EDITMSG",
    callback = function()
        vim.defer_fn(function()
            git_notify_behind()
        end, 50)
        if IsGitEditor() == false then
            vim.cmd(":Neotree close")
            vim.cmd("only")
            vim.cmd(":Neotree git_status show left reveal=true")
        end
    end,
})

-- TODO: this messes up quickfix
-- vim.api.nvim_create_autocmd({ "BufReadPost" }, {
--     group = "main",
--     pattern = "*",
--     callback = function()
--         if vim.bo.filetype ~= nil and vim.bo.filetype ~= "neo-tree" then
--             vim.defer_fn(function()
--                 require("close_buffers").delete({ type = "nameless", force = true })
--             end, 50)
--         end
--     end,
-- })

-- NOTE: customize vimbones theme.
vim.api.nvim_create_autocmd({ "ColorScheme" }, {
    group = "main",
    pattern = "vimbones",
    callback = function()
        VimBonesPatch()
    end,
})

vim.api.nvim_create_autocmd({ "ColorScheme" }, {
    group = "main",
    pattern = "zenwritten",
    callback = function()
        local lush = require("lush")
        if vim.o.background == "light" then
            local specs = lush.parse(function()
                return {
                    Comment({ fg = "#A94064", gui = "italic" }),
                    Constant({ fg = "#353535", gui = "normal" }),
                    Delimiter({ fg = "#353535", gui = "normal" }),
                    Conceal({ fg = "#353535", gui = "normal" }),
                    Identifier({ fg = "#353535", gui = "normal" }),
                    Type({ fg = "#353535", gui = "normal" }),
                    Special({ fg = "#353535", gui = "bold" }),
                    TreesitterContext({ bg = "#e1e1e1" }),
                }
            end)
            lush.apply(lush.compile(specs))
        else
            local specs = lush.parse(function()
                return {
                    -- Comment({ fg = "#FFB6C1", gui = "italic" }),
                    Constant({ fg = "#BBBBBB", gui = "normal" }), -- The same as Conceal
                    Delimiter({ fg = "#BBBBBB", gui = "normal" }),
                    Conceal({ fg = "#BBBBBB", gui = "normal" }),
                    Identifier({ fg = "#BBBBBB", gui = "normal" }),
                    Type({ fg = "#BBBBBB", gui = "normal" }),
                    Special({ fg = "#BBBBBB", gui = "bold" }),
                    TreesitterContext({ bg = "#262626" }),
                }
            end)
            lush.apply(lush.compile(specs))
        end
    end,
})

-- Disable diagnostics on .env files
local group = vim.api.nvim_create_augroup("__env", { clear = true })
vim.api.nvim_create_autocmd("BufEnter", {
    pattern = ".env",
    group = group,
    callback = function(args)
        vim.diagnostic.disable(args.buf)
    end,
})

local refresh_neotree_git_status = function()
    pcall(function()
        require("neo-tree.sources.git_status").refresh()
    end)
end

-- NOTE: uv requires nvim 0.10+
-- local timer = vim.uv.new_timer()
-- timer:start(
--     5000, -- initial delay
--     6000, -- interval
--     vim.schedule_wrap(function()
--         vim.notify("refresh")
--         refresh_neotree_git_status()
--     end)
-- )

local refresh_neotree_aug = vim.api.nvim_create_augroup("RefreshNeoTree", { clear = true })
vim.api.nvim_create_autocmd("BufWinEnter", {
    group = refresh_neotree_aug,
    pattern = "*",
    callback = function()
        vim.defer_fn(function()
            refresh_neotree_git_status()
        end, 1000)
    end,
})
vim.api.nvim_create_autocmd("FocusGained", {
    group = refresh_neotree_aug,
    pattern = "*",
    callback = refresh_neotree_git_status,
})


-- autosave below
-- local api = vim.api
-- local fn = vim.fn
--
-- local delay = 500 -- ms
--
-- local autosave = api.nvim_create_augroup("autosave", { clear = true })
-- -- Initialization
-- api.nvim_create_autocmd("BufRead", {
--     pattern = "*",
--     group = autosave,
--     callback = function(ctx)
--         api.nvim_buf_set_var(ctx.buf, "autosave_queued", false)
--         api.nvim_buf_set_var(ctx.buf, "autosave_block", false)
--     end,
-- })
--
-- api.nvim_create_autocmd({ "InsertLeave", "TextChanged" }, {
--     pattern = "*",
--     group = autosave,
--     callback = function(ctx)
--         -- conditions that donnot do autosave
--         local disabled_ft = { "acwrite", "oil" }
--         if
--             not vim.bo.modified
--             or fn.findfile(ctx.file, ".") == "" -- a new file
--             or ctx.file:match("wezterm.lua")
--             or vim.tbl_contains(disabled_ft, vim.bo[ctx.buf].ft)
--         then
--             return
--         end
--
--         local ok, queued = pcall(api.nvim_buf_get_var, ctx.buf, "autosave_queued")
--         if not ok then
--             return
--         end
--
--         if not queued then
--             vim.cmd("silent w")
--             api.nvim_buf_set_var(ctx.buf, "autosave_queued", true)
--             -- vim.notify("Saved at " .. os.date("%H:%M:%S"))
--         end
--
--         local block = api.nvim_buf_get_var(ctx.buf, "autosave_block")
--         if not block then
--             api.nvim_buf_set_var(ctx.buf, "autosave_block", true)
--             vim.defer_fn(function()
--                 if api.nvim_buf_is_valid(ctx.buf) then
--                     api.nvim_buf_set_var(ctx.buf, "autosave_queued", false)
--                     api.nvim_buf_set_var(ctx.buf, "autosave_block", false)
--                 end
--             end, delay)
--         end
--     end,
-- })
