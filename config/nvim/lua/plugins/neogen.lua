return {
    {
        "danymat/neogen",
        lazy = true,
        cmd = "Neogen",
        cond = NotVSCode,
        opts = {
            snippet_engine = "luasnip",
        },
        dependencies = {
            "nvim-treesitter/nvim-treesitter",
            "L3MON4D3/LuaSnip",
        }
    },
}
