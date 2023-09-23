local M = {
  { "nvim-telescope/telescope-frecency.nvim", dependencies = { "kkharji/sqlite.lua" } },
  { 'nvim-telescope/telescope-media-files.nvim', dependencies = { 'nvim-lua/popup.nvim', 'nvim-lua/plenary.nvim'} },
  { 'nvim-telescope/telescope.nvim',
    dependencies = { 'nvim-lua/plenary.nvim', 'BurntSushi/ripgrep' },
    config = function()
      require('telescope').setup({
        mappings = {
          n = {
            ["<esc>"] = require('telescope.actions').close,
            ["q"] = require('telescope.actions').close,
          },
          i = {
            ["<esc>"] = require('telescope.actions').close
          },
        }
      })
      require("telescope").load_extension("frecency")
      require("telescope").load_extension("media_files")
    end,
    lazy = false
  },
}


local opts = function(desc)
  -- return { noremap = true, desc = desc, buffer = true }
  return { noremap = true, silent = true, desc = desc }
end

vim.keymap.set({'n', 'i', 'v'}, '<C-f>f', "<cmd>Telescope find_files<CR>", opts("Telescope find_files"))
vim.keymap.set({'n', 'i', 'v'}, '<C-f>g', "<cmd>Telescope live_grep<CR>",  opts("Telescope live_grep"))
vim.keymap.set({'n', 'i', 'v'}, '<C-f>b', "<cmd>Telescope buffers<CR>",    opts("Telescope buffers"))
vim.keymap.set({'n', 'i', 'v'}, '<C-f>h', "<cmd>Telescope help_tags<CR>",  opts("Telescope help_tags"))
vim.keymap.set({'n', 'i', 'v'}, '<C-f>s', "<cmd>Telescope current_buffer_fuzzy_find<CR>", opts("Telescope current_buffer_fuzzy_find"))
vim.api.nvim_create_user_command('Help', "<cmd>Telescope help_tags<CR>", {})
vim.api.nvim_create_user_command('H',    "<cmd>Telescope help_tags<CR>", {})

return M
