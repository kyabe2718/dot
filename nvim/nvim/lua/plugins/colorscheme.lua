-- require('utils/extra-whitespace').setup({})

vim.api.nvim_create_autocmd({"ColorScheme"}, {
  pattern = {"*"},
  callback = function(_)
    vim.cmd('highlight Normal guibg=NONE ctermbg=NONE')
    vim.cmd('highlight LineNr guibg=NONE ctermbg=NONE')
  end
})

return {
  'EdenEast/nightfox.nvim',
  {
    'savq/melange-nvim',
    config = function()
      vim.cmd.colorscheme('melange')
    end,
    lazy = false,
  },
  'nvim-treesitter/nvim-treesitter',
}
