return {
    {
        "nvim-telescope/telescope-fzf-native.nvim",
        lazy = true,
        build = "make",
    },
    {
        "nvim-telescope/telescope-file-browser.nvim",
        lazy = true,
        dependencies = {
            "nvim-lua/plenary.nvim",
        },
    },
    {
        "crispgm/telescope-heading.nvim",
        lazy = true,
    },
    {
        "edolphin-ydf/goimpl.nvim",
        lazy = true,
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-lua/popup.nvim",
            "nvim-telescope/telescope.nvim",
            "nvim-treesitter/nvim-treesitter",
        },
    },
    {
        "danielfalk/smart-open.nvim",
        lazy = true,
        branch = "0.2.x",
        dependencies = {
            "kkharji/sqlite.lua",
            { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
        },
    },
    {
        "nvim-telescope/telescope.nvim",
        lazy = true,
        cond = NotVSCode,
        cmd = "Telescope",
        branch = "0.1.x",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-telescope/telescope-live-grep-args.nvim",
            "benfowler/telescope-luasnip.nvim",
            "nvim-telescope/telescope-fzf-native.nvim",
            "nvim-telescope/telescope-file-browser.nvim",
            "crispgm/telescope-heading.nvim",
            "edolphin-ydf/goimpl.nvim",
            "debugloop/telescope-undo.nvim",
            "danielfalk/smart-open.nvim",
        },
        config = function()
            local previewers = require("telescope.previewers")
            local lga_actions = require("telescope-live-grep-args.actions")

            local delta = previewers.new_termopen_previewer({
                get_command = function(entry)
                    if entry.status == "??" or "A " then
                        return { "git", "diff", entry.value }
                    end

                    return { "git", "diff", entry.value .. "^!" }
                end,
            })

            local actions = require("telescope.actions")
            require("telescope").setup({
                defaults = {
                    sorting_strategy = "ascending",
                    mappings = {
                        i = {
                            ["<C-l>"] = actions.close,
                            ["<esc>"] = actions.close,
                            ["<C-[>"] = actions.close,
                            ["<C-t>"] = false,
                            ["<C-v>"] = false,
                            ["<C-u>"] = false,
                            ["<C-BS>"] = false,
                            ["<C-h>"] = "which_key",
                            ["<Tab>"] = actions.move_selection_next,
                            ["<S-Tab>"] = actions.move_selection_previous,
                            -- ["<C-BS>"] = "<C-W>",
                        },
                        n = {
                            ["<C-l>"] = actions.close,
                            ["l"] = actions.select_default,
                            ["<Tab>"] = actions.move_selection_next,
                            ["<S-Tab>"] = actions.move_selection_previous,
                        },
                    },
                    layout_strategy = "horizontal",
                    layout_config = {
                        horizontal = {
                            anchor = "N",
                            width = 0.85,
                            height = 0.98,
                            -- height = vim.o.lines,
                            -- width = vim.o.columns,
                            prompt_position = "top",
                            preview_width = 0.55,
                        },
                    },
                },
                pickers = {
                    lsp_document_symbols = {
                        ignore_symbols = { "field" },
                        symbol_width = 60,
                    },
                    lsp_references = {
                        show_line = false,
                    },
                    find_files = {
                        find_command = {
                            "fd",
                            "--hidden",
                            "--no-ignore",
                            "--type",
                            "f",
                            "--color",
                            "never",
                            "--strip-cwd-prefix",
                            -- "--size",
                            -- "-10mi",
                            "--exclude",
                            ".venv",
                            "--exclude",
                            ".mypy_cache",
                            "--exclude",
                            "node_modules",
                        },
                    },
                    current_buffer_fuzzy_find = {
                        skip_empty_lines = true,
                    },
                    git_status = {
                        mappings = {
                            i = {
                                ["<C-a>"] = actions.git_staging_toggle,
                                ["<Tab>"] = actions.move_selection_next,
                                ["<S-Tab>"] = actions.move_selection_previous,
                            },
                            n = {
                                ["<Tab>"] = actions.move_selection_next,
                                ["<S-Tab>"] = actions.move_selection_previous,
                            },
                        },
                    },
                    buffers = {
                        ignore_current_buffer = true,
                        sort_mru = true,
                    },
                },
                extensions = {
                    smart_open = {
                        cwd_only = true,
                        match_algorithm = "fzf",
                    },
                    fzf = {
                        fuzzy = true,
                        override_generic_sorter = true,
                        override_file_sorter = true,
                        case_mode = "smart_case", -- or "ignore_case" or "respect_case"
                    },
                    file_browser = {
                        grouped = true,
                    },
                    repo = {
                        list = {
                            tail_path = true,
                        },
                    },
                    media_files = {},
                    heading = {
                        treesitter = true,
                    },
                    live_grep_args = {
                        auto_quoting = true,
                        mappings = {
                            i = {
                                ["<C-k>"] = lga_actions.quote_prompt(),
                                -- ["<M-w>"] = lga_actions.quote_prompt({ postfix = " -w" }),
                                ["<C-t>"] = lga_actions.quote_prompt({ postfix = " -t " }),
                            },
                        },
                    },
                },
            })
            require("telescope").load_extension("fzf")
            require("telescope").load_extension("file_browser")
            require("telescope").load_extension("luasnip")
            -- require("telescope").load_extension("git_worktree")
            require("telescope").load_extension("notify")
            require("telescope").load_extension("live_grep_args")
            require("telescope").load_extension("heading")
            require("telescope").load_extension("goimpl")
            require("telescope").load_extension("undo")
            require("telescope").load_extension("smart_open")
        end,
    },
}
