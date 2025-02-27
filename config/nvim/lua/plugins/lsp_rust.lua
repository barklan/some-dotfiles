return {
    {
        "simrat39/rust-tools.nvim",
        lazy = true,
        cond = NotVSCode,
        ft = { "rust" },
        dependencies = {
            "hrsh7th/cmp-nvim-lsp"
        },
        config = function()
            local shared = require("config.lsp_shim")
            local capabilities = require("cmp_nvim_lsp").default_capabilities()

            require("rust-tools").setup({
                tools = {
                    autoSetHints = true,
                    inlay_hints = {
                        show_parameter_hints = false,
                        parameter_hints_prefix = "",
                        other_hints_prefix = "",
                    },
                },

                -- all the opts to send to nvim-lspconfig
                -- these override the defaults set by rust-tools.nvim
                -- see https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#rust_analyzer
                server = {
                    capabilities = capabilities,
                    on_attach = shared.on_attach,
                    settings = {
                        -- to enable rust-analyzer settings visit:
                        -- https://github.com/rust-analyzer/rust-analyzer/blob/master/docs/user/generated_config.adoc
                        ["rust-analyzer"] = {
                            checkOnSave = {
                                command = "clippy",
                            },
                        },
                    },
                },
            })
        end,
    },
    {
        "saecki/crates.nvim",
        lazy = true,
        cond = NotVSCode,
        event = "BufRead Cargo.toml",
        dependencies = {
            "nvim-lua/plenary.nvim",
        },
        config = function()
            require("crates").setup({
                null_ls = {
                    enabled = true,
                    name = "crates.nvim",
                },
            })
        end,
    },
}
