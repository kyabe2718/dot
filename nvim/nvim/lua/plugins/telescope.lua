return {
  'nvim-telescope/telescope.nvim',
  tag = '0.1.2',
  dependencies = { 'nvim-lua/plenary.nvim', 'BurntSushi/ripgrep' },
  config = function()
    require('telescope').setup({
      mappings = {
        i = {
          ["<esc>"] = require('telescope.actions').close,
        },
      }
    })

    local telescope_builtin = require('telescope.builtin')
    vim.keymap.set('n', '<C-f>f', telescope_builtin.find_files, {})
    vim.keymap.set('n', '<C-f>g', telescope_builtin.live_grep, {})
    vim.keymap.set('n', '<C-f>b', telescope_builtin.buffers, {})
  end,
}
