local M = {}

M.setup = function()
    local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
    M.augroup = augroup

    -- if CMPEnable() == true then
    --     M.capabilities = require("cmp_nvim_lsp").default_capabilities()
    -- else
    --     local coq = require("coq")
    --     M.capabilities = coq.lsp_ensure_capabilities
    -- end
end

M.on_attach = function(client, bufnr)
    local function buf_set_keymap(...)
        vim.api.nvim_buf_set_keymap(bufnr, ...)
    end

    -- Format on save
    if client.supports_method("textDocument/formatting") then
        vim.api.nvim_clear_autocmds({ group = M.augroup, buffer = bufnr })
        vim.api.nvim_buf_create_user_command(bufnr, "LspFormat", function()
            local bufname = vim.api.nvim_buf_get_name(bufnr)
            local bufname_split = Split(bufname, ".")
            local ext = bufname_split[#bufname_split]

            if ext == "go" then
                require("go.format").goimport()
                return
            end

            vim.lsp.buf.format({
                filter = function(server)
                    return server.name ~= "lua_ls"
                end,
                bufnr = bufnr,
            })
        end, {})
    end

    -- Mappings.
    local opts = { noremap = true, silent = true }

    -- INFO: Defined using Telescope
    -- buf_set_keymap("n", "gd", "<Cmd>lua vim.lsp.buf.definition()<CR>", opts)
    -- buf_set_keymap("n", "gi", "<Cmd>lua vim.lsp.buf.definition()<CR>", opts)

    buf_set_keymap("n", "gl", "<cmd>lua vim.diagnostic.goto_next()<CR>", opts)
    buf_set_keymap("n", "gD", "<Cmd>lua vim.lsp.buf.declaration()<CR>", opts)
    buf_set_keymap("n", "gh", "<Cmd>lua vim.lsp.buf.hover()<CR>", opts)
    buf_set_keymap("n", "<F2>", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)
    buf_set_keymap("n", "<leader>do", "<cmd>lua vim.diagnostic.open_float()<CR>", opts)
    buf_set_keymap("n", "<leader>di", "<cmd>lua vim.lsp.buf.code_action()<CR>", opts)
    buf_set_keymap("n", "<leader>df", "<cmd>lua vim.lsp.buf.format()<CR>", opts)
end

return M
