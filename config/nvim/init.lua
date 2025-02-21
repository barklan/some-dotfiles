vim.g.loaded_python3_provider = 0

Split = function(s, delimiter)
    local result = {}
    for match in (s .. delimiter):gmatch("(.-)" .. delimiter) do
        table.insert(result, match)
    end
    return result
end

Contains = function(tab, val)
    for _, value in ipairs(tab) do
        if value == val then
            return true
        end
    end
    return false
end

GetFileExt = function(filename)
    local ext, _ = string.gsub(filename, ".*%.", "")
    return ext
end

InVSCode = function()
    return vim.g.vscode ~= nil
end

NotVSCode = function()
    return vim.g.vscode == nil
end

CMPEnable = function()
    if InVSCode == true then
        return false
    end
    return true
end

IsGitEditor = function()
    local num_args = vim.fn.argc()
    local first_arg = vim.fn.argv()[1]
    local f = ""
    if num_args >= 1 then
        local split = Split(first_arg, "/")
        f = split[#split]
    end
    if f == "COMMIT_EDITMSG" or f == "TAG_EDITMSG" or f == "git-rebase-todo" then
        return true
    end
    return false
end

IsCMDLineEditor = function()
    local num_args = vim.fn.argc()
    local first_arg = vim.fn.argv()[1]
    local f = ""
    if num_args >= 1 then
        if string.find(first_arg, "/tmp/tmp") then
            return true
        end
    end
    return false
end

IsScrollbackPager = function ()
    if os.getenv("NVIM_SCROLLBACK") == "true" then
        return true
    end

    return false
end

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable",
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

vim.g.mapleader = " "
require("lazy").setup("plugins", {
    checker = {
        -- automatically check for plugin updates
        enabled = false,
        concurrency = nil, ---@type number? set to 1 to check for updates very slowly
        notify = true, -- get a notification when new updates are found
        frequency = 3600, -- check for updates every hour
        check_pinned = false, -- check for pinned packages that can't be updated
    },
    change_detection = {
        -- automatically check for config file changes and reload the ui
        enabled = false,
        notify = true, -- get a notification when changes are found
    },
    performance = {
        rtp = {
            disabled_plugins = {
                "gzip",
                "netrwPlugin",
                "rplugin",
                "tarPlugin",
                "tohtml",
                "tutor",
                "zipPlugin",
            },
        },
    },
})

require("config.options_shared")
require("config.keymaps_shared")
require("config.autocmds_shared")

if InVSCode() == true then
    require("config.options_vscode")
    require("config.keymaps_vscode")
else
    require("config.globals")
    require("config.options_nvim")
    require("config.autocmds_nvim")
    require("config.lsp_shim").setup()

    -- NOTE: This is for terminal emulators only.
    vim.keymap.set("i", "<C-H>", "<C-W>", { silent = true })

    require("config.keymaps_nvim")
end
