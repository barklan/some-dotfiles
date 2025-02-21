vim.api.nvim_create_augroup("main", { clear = true })

vim.cmd([[
autocmd! InsertEnter * call feedkeys("\<Cmd>noh\<cr>" , 'n')
]])

vim.cmd([[
augroup highlight_yank
    autocmd!
    au TextYankPost * silent! lua vim.highlight.on_yank {higroup="IncSearch", timeout=200}
augroup END
]])

-- start git messages in insert mode
vim.api.nvim_create_augroup("bufcheck", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
    group = "bufcheck",
    pattern = { "gitcommit" },
    command = "startinsert | 1",
})

vim.cmd([[
augroup customfiletypedetect
    au!
    autocmd BufNewFile,BufRead *.dockerfile set filetype=dockerfile
    autocmd BufNewFile,BufRead *.pac set filetype=javascript
augroup END
]])
