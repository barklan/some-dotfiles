return {
    {
        "kazhala/close-buffers.nvim",
        lazy = true,
        opts = {},
    },
    {
        "famiu/bufdelete.nvim",
        lazy = true,
    },
    {
        "chrisgrieser/nvim-early-retirement",
        event = "VeryLazy",
        cond = NotVSCode,
        opts = {
            minimumBufferNum = 5,
            retirementAgeMins = 10,
        },
    },
    {
        "nvim-zh/auto-save.nvim",
        event = "VeryLazy",
        cond = NotVSCode,
        opts = {
            enabled = true,
            write_all_buffers = false,
            trigger_events = { "FocusLost", "CursorHold", "InsertLeave", "TextChanged" },
            condition = function(buf)
                local fn = vim.fn
                local utils = require("auto-save.utils.data")

                if fn.getbufvar(buf, "&modifiable") == 1 and utils.not_in(fn.getbufvar(buf, "&filetype"), {}) then
                    if vim.bo.filetype ~= "gitcommit" then
                        return true -- met condition(s), can save
                    end
                end
                return false -- can't save
            end,
            debounce_delay = 500,
            execution_message = {
                message = function() -- message to print on save
                    return ""
                end,
                dim = 0.18, -- dim the color of `message`
                cleaning_interval = 1250, -- (milliseconds) automatically clean MsgArea after displaying `message`. See :h MsgArea
            },
        },
    },
}
