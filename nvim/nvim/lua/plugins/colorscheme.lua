-- require('utils/extra-whitespace').setup({})

return {
  'EdenEast/nightfox.nvim',
  {
    'savq/melange-nvim',
    config = function()
      vim.cmd.colorscheme('melange')
      -- vim.cmd('highlight String cterm=None gui=None guifg=#a3a9ce')
    end,
    lazy = false,
  },
  'nvim-treesitter/nvim-treesitter',
}
