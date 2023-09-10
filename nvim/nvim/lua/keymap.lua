-- keymaps
-- :help vim.keymap.set
-- vim.keymap.set(mode, lhs, rhs, options)

vim.keymap.set('n', ';', ':')
vim.keymap.set('v', ';', ':')

vim.keymap.set('n', '<Esc><Esc>', ':nohlsearch<CR><Esc>')

vim.keymap.set('n', 'S-Left',  '<C-w><<CR>')
vim.keymap.set('n', 'S-Right', '<C-w>><CR>')
vim.keymap.set('n', 'S-Up',    '<C-w>-<CR>')
vim.keymap.set('n', 'S-Down',  '<C-w>+<CR>')

vim.keymap.set('n', '<C-w><S-h>', '<C-w><<CR>')
vim.keymap.set('n', '<C-w><S-l>', '<C-w>><CR>')
vim.keymap.set('n', '<C-w><S-j>', '<C-w>-<CR>')
vim.keymap.set('n', '<C-w><S-k>', '<C-w>+<CR>')

vim.keymap.set('n', 'gl', 'gt')
vim.keymap.set('n', 'gh', 'gT')

vim.keymap.set('n', '<A-Left>', '<C-o>')
vim.keymap.set('n', '<A-Right>', '<C-i>')

-- nvim-tree
vim.keymap.set('n', '<A-1>', '<cmd>:NvimTreeToggle<CR>')

-- telescope
local telescope_builtin = require('telescope.builtin')
vim.keymap.set('n', '<C-f>f', telescope_builtin.find_files, {})
vim.keymap.set('n', '<C-f>g', telescope_builtin.live_grep, {})
vim.keymap.set('n', '<C-f>b', telescope_builtin.buffers, {})

local getjumplist = function()
    print(vim.inspect(vim.fn.getjumplist(1, 1)))
    local jumplist = vim.fn.getjumplist()[1]
    -- reverse the list
    local sorted_jumplist = {}
    for i = #jumplist, 1, -1 do
        if vim.api.nvim_buf_is_valid(jumplist[i].bufnr) then
            jumplist[i].filename = vim.api.nvim_buf_get_name(jumplist[i].bufnr)
            table.insert(sorted_jumplist, jumplist[i])
      end
    end
    return sorted_jumplist
end

vim.api.nvim_create_user_command('JumpList', function(buf)
    local jl = getjumplist()
    for i = 1, #jl do
        print(string.format("%4d %4d %s", jl[i].lnum, jl[i].col, jl[i].filename))
    end
end, {})

-- lsp
vim.api.nvim_create_augroup('lsp_group', {})
vim.api.nvim_create_autocmd('LspAttach', {
    group = 'lsp_group',
    callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        local opts = { buffer = args.buf }
        vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(
            vim.lsp.handlers.hover, { border = 'single' } -- override config
        )

        vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
        -- vim.keymap.set('n', '<C-f>f', vim.lsp.buf.format, opts)
        vim.keymap.set('n', '<C-f>i', vim.lsp.buf.implementation, opts)
        vim.keymap.set('n', '<C-f>d', vim.lsp.buf.definition, opts)
        vim.keymap.set('n', '<C-f>b', vim.lsp.buf.declaration, opts)

        -- vim.api.nvim_create_autocmd('CursorHold', {
        --     group = 'lsp_group',
        --     command = "lua vim.lsp.buf.hover()"
        -- })
    end
})
