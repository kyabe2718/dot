-- See https://github.com/folke/lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup({
    'neovim/nvim-lspconfig', -- configs for the Nvim LSP client
    'williamboman/mason.nvim', -- easy editor tool manager
    'williamboman/mason-lspconfig.nvim', -- closes gaps between mason.nvim and nvim-lspconfig
    'hrsh7th/nvim-cmp', -- Autocompletion plugin
    'hrsh7th/cmp-nvim-lsp', -- LSP source for nvim-cmp

    'nvim-tree/nvim-tree.lua', -- File Explorer
    'nvim-tree/nvim-web-devicons', --

    {
        'nvim-telescope/telescope.nvim', tag = '0.1.2',
        dependencies = { 'nvim-lua/plenary.nvim' }
    },

    -- colorscheme --
    'savq/melange-nvim',
    'EdenEast/nightfox.nvim',
})

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
require('nvim-tree').setup({
    sort_by = 'case_sensitive',
    view = {
        number = true
    },
    tab = {
        sync = { open = true, close = true }
    },
    on_attach = function (buf)
        local api = require ('nvim-tree.api')
        local function opts(desc)
            return { desc = "nvim-tree: " .. desc, buffer = buf, noremap = true, silent = true, nowait = true }
        end
        -- default mapping
        api.config.mappings.default_on_attach(buf)

        -- custom mapping
        vim.keymap.set('n', '?', api.tree.toggle_help, opts('Help'))
        local function open_edit_or_tab ()
            local wins = vim.api.nvim_tabpage_list_wins(0)
            local cwin = vim.api.nvim_get_current_win()
            for i = 1, #wins do
                if wins[i] ~= cwin then -- not eqaul
                    local b = vim.api.nvim_win_get_buf(wins[i])
                    local name = vim.api.nvim_buf_get_name(b)
                    if string.len(name) ~= 0 then
                        -- Open in new tab if non-empty window exists
                        api.node.open.tab()
                        return
                    end
                end
            end
            -- Open in current tab if all windows are empty
            api.node.open.edit()
        end
        -- -- vim.keymap.set('n', '<CR>', api.node.open.tab, opts('Open: New Tab'))
        vim.keymap.set('n', '<CR>', open_edit_or_tab, opts('Open: Current or New Tab'))
    end,
})
vim.keymap.set('n', '<A-1>', '<cmd>:NvimTreeToggle<CR>')
