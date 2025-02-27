return {
    {
        "jrop/jq.nvim",
        lazy = true,
        event = "VeryLazy",
        cond = NotVSCode,
        cmd = "Jq",
    },
}
