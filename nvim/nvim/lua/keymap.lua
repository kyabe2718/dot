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
vim.keymap.set('n', 'gh', 'gT')


