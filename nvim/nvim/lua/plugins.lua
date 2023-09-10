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

    'nvim-treesitter/nvim-treesitter',

    { 'nvim-telescope/telescope.nvim',
        tag = '0.1.2',
        dependencies = { 'nvim-lua/plenary.nvim', 'BurntSushi/ripgrep' }
    },

    -- copilot
    { 'github/copilot.vim', lazy=false },

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


require('nvim-treesitter.configs').setup({
    ensure_installed = {'c', 'cpp', 'llvm', 'lua', 'vim', 'vimdoc', 'python'},
    sync_install = false,
    auto_install = true,
    highlight = {
        enable = true,
    },
    indent = {
        enable = true,
    },
})
