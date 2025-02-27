return {
    {
        -- TODO: https://github.com/ThePrimeagen/harpoon/tree/harpoon2
        enabled = false,
        "ThePrimeagen/harpoon",
        lazy = true,
        event = "VeryLazy",
        cond = NotVSCode,
        dependencies = {
            "nvim-lua/plenary.nvim",
        },
    },
}
