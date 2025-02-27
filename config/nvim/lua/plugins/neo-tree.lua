return {
    {
        "s1n7ax/nvim-window-picker",
        version = "2.*",
        lazy = true,
        cond = NotVSCode,
        config = function()
            require("window-picker").setup({
                filter_rules = {
                    autoselect_one = true,
                    include_current_win = false,
                    bo = {
                        -- if the file type is one of following, the window will be ignored
                        filetype = { "neo-tree", "neo-tree-popup", "notify" },
                        -- if the buffer type is one of following, the window will be ignored
                        buftype = { "terminal", "quickfix" },
                    },
                },
            })
        end,
    },
    {
        "nvim-neo-tree/neo-tree.nvim",
        -- branch = "main",
        branch = "v3.x",
        lazy = false,
        event = "VeryLazy",
        cmd = "Neotree",
        cond = NotVSCode,
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-tree/nvim-web-devicons",
            "MunifTanjim/nui.nvim",
            -- "s1n7ax/nvim-window-picker",
            -- "mrbjarksen/neo-tree-diagnostics.nvim",
        },
        config = function()
            vim.cmd([[ let g:neo_tree_remove_legacy_commands = 1 ]])

            require("neo-tree").setup({
                auto_clean_after_session_restore = true,
                sources = {
                    "filesystem",
                    "buffers",
                    "git_status",
                    -- "diagnostics",
                },
                close_if_last_window = true,
                enable_git_status = true,
                hijack_netrw_behavior = "open_default",
                enable_diagnostics = true,
                window = {
                    width = 40,
                    mappings = {
                        ["l"] = "open",
                        ["h"] = "close_node",
                        ["t"] = "none",
                        ["Z"] = "expand_all_nodes",
                    },
                },
                default_component_configs = {
                    icon = {
                        folder_empty = "🗀",
                        default = "-",
                        folder_closed = ">",
                        folder_open = "v",
                    },
                    modified = {
                        symbol = "",
                    },
                    name = {
                        trailing_slash = false,
                    },
                    git_status = {
                        symbols = {
                            added = "NEW",
                            modified = "",
                            -- unstaged = "󰄱",
                            unstaged = "",
                            deleted = "DEL",
                            renamed = "RENAME",
                            conflict = "CONFLICT!",
                            ignored = "",
                            staged = "STAGED",
                        },
                    },
                },
                filesystem = {
                    window = {
                        mappings = {
                            ["o"] = "open_in_file_manager",
                            ["l"] = "edit_or_open",
                            ["<CR>"] = "edit_or_open",
                            ["<2-leftmouse>"] = "edit_or_open",
                            ["O"] = "system_open",
                            ["i"] = "run_command",
                        },
                    },
                    commands = {
                        open_in_file_manager = function(state)
                            local node = state.tree:get_node()
                            local file = node:get_id()
                            local file_slice = Split(file, "/")
                            table.remove(file_slice, #file_slice)
                            local file_dir = table.concat(file_slice, "/")
                            vim.cmd([[silent !xdg-open ]] .. file_dir .. [[ &>/dev/null 0<&- & disown;]])
                        end,
                        edit_or_open = function(state)
                            local node = state.tree:get_node()
                            if require("neo-tree.utils").is_expandable(node) then
                                state.commands["toggle_node"](state)
                            else
                                local file = node:get_id()
                                local action_key = ChooseFileAction(file)
                                if action_key == "edit" then
                                    state.commands["open"](state)
                                elseif action_key == "open" then
                                    vim.cmd([[silent !xdg-open ]] .. file .. [[" &]])
                                elseif action_key ~= "none" then
                                    vim.notify("Unknown action key! FIX THIS BUG.")
                                end
                            end
                        end,
                        system_open = function(state)
                            local node = state.tree:get_node()
                            local path = node:get_id()
                            vim.api.nvim_command("silent !xdg-open " .. path)
                        end,
                        run_command = function(state)
                            local node = state.tree:get_node()
                            local path = node:get_id()
                            vim.api.nvim_input(": " .. path .. "<Home>")
                        end,
                        delete = function(state)
                            local inputs = require("neo-tree.ui.inputs")
                            local node = state.tree:get_node()
                            local path = node.path
                            local msg = "trash " .. path
                            inputs.confirm(msg, function(confirmed)
                                if not confirmed then
                                    return
                                end
                                -- if require("neo-tree.utils").is_expandable(node) == false then
                                -- vim.notify(path)
                                -- end
                                vim.fn.system({ "trash", vim.fn.fnameescape(path) })

                                require("neo-tree.sources.manager").refresh(state.name)

                                vim.defer_fn(function()
                                    DeleteBuffersWithoutFile()
                                end, 50)
                            end)
                        end,

                        -- over write default 'delete_visual' command to 'trash' x n.
                        delete_visual = function(state, selected_nodes)
                            local inputs = require("neo-tree.ui.inputs")

                            local msg = "trash " .. #selected_nodes .. " files ?"
                            inputs.confirm(msg, function(confirmed)
                                if not confirmed then
                                    return
                                end
                                for _, node in ipairs(selected_nodes) do
                                    vim.fn.system({ "trash", vim.fn.fnameescape(node.path) })
                                end

                                require("neo-tree.sources.manager").refresh(state.name)

                                vim.defer_fn(function()
                                    DeleteBuffersWithoutFile()
                                end, 50)
                            end)
                        end,
                    },
                    filtered_items = {
                        hide_dotfiles = false,
                        hide_gitignored = false,
                        hide_hidden = false,
                        -- NOTE: This should be synced with global gitignore
                        -- to avoid accidental commits of these files.
                        hide_by_name = {
                            ".git",
                            "node_modules",
                            ".mypy_cache",
                            "__pycache__",
                            ".pytest_cache",
                        },
                    },
                    follow_current_file = {
                        enabled = true,
                    },
                    use_libuv_file_watcher = true,
                },
            })
        end,
    },
}
