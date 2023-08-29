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

    -- colorscheme --
     "savq/melange-nvim",
})

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
require('nvim-tree').setup({
    sort_by = 'case_sensitive',
    view = {
        number = true
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
    end,
})
vim.keymap.set('n', '<A-1>', '<cmd>:NvimTreeToggle<CR>')
