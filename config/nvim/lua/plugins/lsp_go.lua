return {
    {
        "ray-x/go.nvim",
        ft = { "go", "gomod" },
        -- lazy = false,
        event = "VeryLazy",
        cond = NotVSCode,
        dependencies = {
            "nvim-treesitter/nvim-treesitter",
            "neovim/nvim-lspconfig",
            "ray-x/guihua.lua",
            "hrsh7th/cmp-nvim-lsp",
        },
        config = function()
            local shared = require("config.lsp_shim")
            local capabilities = require("cmp_nvim_lsp").default_capabilities()

            require("go").setup({
                -- gopls_cmd = { "gopls", "-remote=auto", "-remote.listen.timeout=20m" },
                gopls_cmd = { "gopls" },
                goimports = "gopls",
                gofmt = "gopls",
                -- gofmt = 'gofumpt',
                lsp_gofumpt = true,
                lsp_document_formatting = true,
                tag_options = "",
                verbose_tests = true,
                tag_transform = "camelcase",
                -- tag_transform = "snakecase",
                lsp_cfg = {
                    capabilities = capabilities,
                    on_attach = shared.on_attach,
                    --                     settings = {
                    --                         gopls = {
                    --                             hints = vim.json.decode([[
                    --     {
                    --       "assignVariableTypes": true,
                    --       "compositeLiteralFields": true,
                    --       "compositeLiteralTypes": true,
                    --       "constantValues": true,
                    --       "functionTypeParameters": true,
                    --       "parameterNames": true,
                    --       "rangeVariableTypes": true
                    --     }
                    -- ]]),
                    --                         },
                    -- },
                },
                diagnostic = { -- set diagnostic to false to disable vim.diagnostic setup
                    hdlr = false, -- hook lsp diag handler and send diag to quickfix
                    underline = false,
                    -- virtual text setup
                    -- virtual_text = { spacing = 0, prefix = "■" },
                    signs = false,
                    update_in_insert = false,
                },
                -- TODO: enable with nvim 0.10.x
                -- rn with nightly they disappear after save, see
                -- https://github.com/ray-x/go.nvim/issues/416
                lsp_inlay_hints = {
                    enable = false,
                    --     style = "inlay",
                },
            })
        end,
    },
}
