local function telescope_ctrll_run(prompt_bufnr)
    local actions = require("telescope.actions")
    local action_state = require("telescope.actions.state")
    local action_set = require("telescope.actions.set")
    actions.select_default:replace(function()
        local selection = action_state.get_selected_entry()
        if selection == nil then
            vim.notify("Nothing selected.")
            return
        end
        local file = selection[1]
        local action_key = ChooseFileAction(file)
        if action_key == "edit" then
            action_set.select(prompt_bufnr, "default")
        elseif action_key == "open" then
            actions.close(prompt_bufnr)
            vim.cmd([[silent !fish -ic "xdg-open ]] .. file .. [[" &]])
        elseif action_key == "none" then
            actions.close(prompt_bufnr)
        else
            vim.notify("Unknown action key! FIX THIS BUG.")
        end
    end)
    return true
end

local telescope_ctrll = function()
    local opts = {
        attach_mappings = telescope_ctrll_run,
        layout_config = { width = 0.5, height = 0.6, preview_width = 0 },
        find_command = {
            "fd",
            "--color",
            "never",
            "--type",
            "f",
            "--strip-cwd-prefix",
            "--hidden",
            "--no-ignore",
            "--owner",
            "1000",
            "-E",
            ".git",
            "-E",
            ".venv",
        },
    }
    require("telescope.builtin").find_files(opts)
end

vim.keymap.set("n", "<C-M-l>", telescope_ctrll, { silent = true, desc = "Find files" })

-- local function fzflua()
--     require("fzf-lua").files({
--         cmd = "fd --color=never --type f --hidden --no-ignore --exclude .git",
--     })
-- end
-- vim.keymap.set("n", "<C-l>", fzflua, { silent = true, desc = "File picker" })
