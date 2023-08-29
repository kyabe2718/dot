-- keymaps
-- :help vim.keymap.set
-- vim.keymap.set(mode, lhs, rhs, options)

vim.keymap.set('n', '<Esc><Esc>', ':nohlsearch<CR><Esc>')

vim.keymap.set('n', 'S-Left',  '<C-w><<CR>')
vim.keymap.set('n', 'S-Right', '<C-w>><CR>')
vim.keymap.set('n', 'S-Up',    '<C-w>-<CR>')
vim.keymap.set('n', 'S-Down',  '<C-w>+<CR>')

vim.keymap.set('n', '<C-w><S-h>', '<C-w><<CR>')
vim.keymap.set('n', '<C-w><S-l>', '<C-w>><CR>')
vim.keymap.set('n', '<C-w><S-j>', '<C-w>-<CR>')
vim.keymap.set('n', '<C-w><S-k>', '<C-w>+<CR>')

vim.keymap.set('n', ';', ':')
vim.keymap.set('v', ';', ':')

vim.keymap.set('n', 'gl', 'gt')
vim.keymap.set('v', 'gh', 'gT')

-- lsp
vim.api.nvim_create_autocmd('LspAttach', {
    callback = function(args)
        -- print('LspAttach')
        vim.keymap.set('n', 'gd', '<cmd>vim.lsp.buf.definition()<CR>', {buffer = args.buf})
    end
})

