return {
  'mhartington/formatter.nvim',
  dependencies = { 'williamboman/mason.nvim' },
  config = function()
    -- require('mason').setup()
    -- local registry = require('mason-registry')
    -- local packages = registry.get_installed_packages()
    -- for i = 1, #packages do
    --   local package = packages[i]
    --   print(package.spec.categories[1])
    --   if package.spec.categories[1] == 'Formatter' then
    --     print(vim.inspect(package.spec))
    --   end
    -- end
    -- local formatters = require('formatter.filetypes')

    require('formatter').setup({
      logging = true,
      log_level = vim.log.levels.WARN,
      filetype = {
        c   = { require('formatter.filetypes.c').clangformat },
        cpp = { require('formatter.filetypes.cpp').clangformat },
        -- lua = { require('formatter.filetypes.lua').stylua },
        lua = {
          exe = "stylua",
          args = {
            "--indent-types Spaces",
            "--indent-widths 2",
            "--", "-"
          },
          stdin = true
        }
      }
    })
  end,
  lazy = false
}
