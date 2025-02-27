return {
    {
        "cappyzawa/trim.nvim",
        opts = {
            trim_on_write = true,
            trim_trailing = false, -- Handled by editorconfig
            trim_last_line = true,
            trim_first_line = false,
            highlight = false,
            highlight_bg = "red",
        },
    },
    {
        "nvimtools/none-ls.nvim",
        name = "null_ls",
        cond = NotVSCode,
        event = "VeryLazy",
        dependencies = {
            "nvim-lua/plenary.nvim",
        },
        config = function()
            local shared = require("config.lsp_shim")
            local null_ls = require("null-ls")
            local sources = {
                -- null_ls.builtins.diagnostics.ansiblelint,
                null_ls.builtins.diagnostics.hadolint,
                null_ls.builtins.diagnostics.sqlfluff.with({
                    args = { "lint", "-f", "github-annotation", "-n", "--disable-progress-bar", "$FILENAME" },
                    extra_args = {
                        "--config",
                        os.getenv("HOME") .. "/dev/dotfiles/sqlfluff.toml",
                    },
                }),

                null_ls.builtins.diagnostics.dotenv_linter,
                null_ls.builtins.diagnostics.fish,
                null_ls.builtins.diagnostics.gitlint.with({
                    extra_args = {
                        "--contrib=contrib-title-conventional-commits",
                    },
                }),
                null_ls.builtins.diagnostics.yamllint.with({
                    method = null_ls.methods.DIAGNOSTICS_ON_SAVE,
                    args = {
                        "-c",
                        os.getenv("HOME") .. "/dev/dotfiles/yamllint.yml",
                        "--format",
                        "parsable",
                        "-",
                    },
                }),
                null_ls.builtins.diagnostics.markdownlint.with({
                    method = null_ls.methods.DIAGNOSTICS_ON_SAVE,
                    extra_args = {
                        "--disable=MD012",
                        "--disable=MD013",
                        "--disable=MD033",
                        "--disable=MD041",
                        "--disable=MD034",
                    },
                }),
                null_ls.builtins.formatting.markdownlint.with({
                    extra_args = {
                        "--disable=MD034",
                    },
                }),

                -- NOTE: run "vale sync"
                -- null_ls.builtins.diagnostics.vale.with({
                --     method = null_ls.methods.DIAGNOSTICS_ON_SAVE,
                -- }),

                -- NOTE: This is totally heavy.
                null_ls.builtins.diagnostics.golangci_lint.with({
                    method = null_ls.methods.DIAGNOSTICS_ON_SAVE,
                    -- NOTE staticcheck is provided by gopls
                    extra_args = {
                        "--no-config",
                        "--concurrency=4",
                        -- "--disable-all",
                        "--max-same-issues=0",
                        "--fast",
                        -- "--enable=errcheck",
                    },
                    timeout = 2000,
                }),

                -- NOTE: Messes with existings projects
                null_ls.builtins.formatting.golines.with({
                    extra_args = {
                        "--max-len=120",
                        "--base-formatter=gofumpt",
                    },
                }),
                null_ls.builtins.diagnostics.buf.with({
                    args = {
                        "lint",
                    },
                    extra_args = {
                        "--config=/home/barklan/sys/buf.yml",
                        --     "--ignore=FIELD_NAMES_SNAKE_CASE",
                    },
                }),
                null_ls.builtins.diagnostics.codespell.with({
                    method = null_ls.methods.DIAGNOSTICS_ON_SAVE,
                }),

                -- Formatting section
                null_ls.builtins.formatting.sqlfluff.with({
                    args = { "fix", "--disable-progress-bar", "-f", "-n", "-" },
                    extra_args = {
                        "--FIX-EVEN-UNPARSABLE",
                        "--config",
                        os.getenv("HOME") .. "/dev/dotfiles/sqlfluff_fix.toml",
                    },
                }),
                null_ls.builtins.formatting.shfmt,
                null_ls.builtins.formatting.just,

                -- NOTE: This fucks up some variables where you actually what them unquoted.
                -- null_ls.builtins.formatting.shellharden,

                null_ls.builtins.formatting.black,
                null_ls.builtins.formatting.isort.with({
                    extra_args = {
                        "--profile=black",
                    },
                }),
                null_ls.builtins.formatting.clang_format.with({
                    extra_args = {
                        -- [[--style="{BasedOnStyle: google, IndentWidth: 4}"]]
                        "--style=microsoft",
                    },
                }),
                null_ls.builtins.formatting.prettierd.with({
                    disabled_filetypes = { "json" },
                }),
                null_ls.builtins.formatting.fish_indent,

                null_ls.builtins.formatting.buf,
                null_ls.builtins.formatting.stylua,
            }

            null_ls.setup({
                sources = sources,
                on_attach = shared.on_attach,
            })
        end,
    },
}
