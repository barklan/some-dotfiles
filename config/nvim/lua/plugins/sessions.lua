return {
    {
        "rmagatti/auto-session",
        cond = function()
            if NotVSCode() == false then
                return false
            end
            if IsGitEditor() == true then
                return false
            end
            if IsCMDLineEditor() == true then
                return false
            end
            if IsScrollbackPager() == true then
                return false
            end
            return true
        end,
        lazy = false,
        priority = 999, -- Load after theme.
        init = function()
            vim.o.sessionoptions = "buffers,curdir,tabpages,winsize,winpos"
        end,
        opts = {
            log_level = "error",
            auto_session_suppress_dirs = { "~/dev" },
            auto_save_enabled = true,
            auto_restore_enabled = true,
            session_lens = {
                load_on_setup = false,
            },
            post_restore_cmds = {
                function()
                    DeleteBuffersWithoutFile()
                end,
            },
        },
    },
    {
        "ahmedkhalf/project.nvim",
        cond = NotVSCode,
        event = "VeryLazy",
        -- lazy = false,
        config = function()
            require("project_nvim").setup({
                detection_methods = { "pattern" },
                silent_chdir = true,
                exclude_dirs = { "~/.local/*", "~/.config/*", "/usr/*" },
            })
        end,
    },
}
