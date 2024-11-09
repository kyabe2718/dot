return {
  {
    'akinsho/toggleterm.nvim',
    version = "*",
    config = function()
      require('toggleterm').setup({
        hide_numbers = true,
        start_in_insert = true,
        open_mapping = '<A-2>',
        insert_mappings = true,
        terminal_mappings = true,
      })
    end
  }
}
