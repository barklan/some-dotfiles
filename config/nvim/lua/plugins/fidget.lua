return {
    {
        "j-hui/fidget.nvim",
        cond = NotVSCode,
        event = "VeryLazy",
        opts = {
            progress = {
                poll_rate = 1,
                ignore_done_already = true,
                suppress_on_insert = true,
                ignore_empty_message = true,
                ignore = {
                    "null-ls",
                },
                display = {
                    done_ttl = 0,
                },
            },
        },
    },
}
