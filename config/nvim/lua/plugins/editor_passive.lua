return {
    {
        "folke/todo-comments.nvim",
        event = "VeryLazy",
        cond = NotVSCode,
        dependencies = { "nvim-lua/plenary.nvim" },
        opts = {
            signs = false,
        },
    },
}
