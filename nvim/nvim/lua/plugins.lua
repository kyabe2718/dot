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

    'hrsh7th/nvim-cmp',     -- Autocompletion plugin
    'hrsh7th/cmp-nvim-lsp', -- nvim-cmp source for lsp
    'hrsh7th/cmp-buffer',   -- nvim-cmp source for buffer
    'hrsh7th/cmp-path',     -- nvim-cmp source for filesystem paths
    'hrsh7th/cmp-cmdline',  -- nvim-cmp source for vim cmdline
    'hrsh7th/cmp-nvim-lua',  -- nvim-cmp source for neovim lua API

    'nvim-tree/nvim-tree.lua', -- File Explorer
    'nvim-tree/nvim-web-devicons', --

    {
        'nvim-telescope/telescope.nvim', tag = '0.1.2',
        dependencies = { 'nvim-lua/plenary.nvim', 'BurntSushi/ripgrep' }
    },

    -- colorscheme --
    'savq/melange-nvim',
    'EdenEast/nightfox.nvim',
})

-- telescope --
require('telescope').setup({
    i = {
        ["<esc>"] = require('telescope.actions').close,
    },
})
local telescope_builtin = require('telescope.builtin')
vim.keymap.set('n', '<C-f>f', telescope_builtin.find_files, {})
vim.keymap.set('n', '<C-f>g', telescope_builtin.live_grep, {})
vim.keymap.set('n', '<C-f>b', telescope_builtin.buffers, {})

