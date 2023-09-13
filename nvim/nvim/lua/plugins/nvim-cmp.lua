return {
  'hrsh7th/cmp-nvim-lsp', -- nvim-cmp source for lsp
  'hrsh7th/cmp-buffer',   -- nvim-cmp source for buffer
  'hrsh7th/cmp-path',     -- nvim-cmp source for filesystem paths
  'hrsh7th/cmp-cmdline',  -- nvim-cmp source for vim cmdline
  'hrsh7th/cmp-nvim-lua', -- nvim-cmp source for neovim lua API

  { 'hrsh7th/nvim-cmp',     -- Autocompletion plugin
    config = function()
      local cmp = require('cmp')
      cmp.setup({
          mapping = cmp.mapping.preset.insert({
              ['<C-d>'] = cmp.mapping.scroll_docs(-4),
              ['<C-u>'] = cmp.mapping.scroll_docs(4),
              ['<C-l>'] = cmp.mapping.complete(),
              ['<Esc>'] = cmp.mapping.abort(),
              ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
          }),
          sources = cmp.config.sources({
              { name = 'nvim_lsp' },
              -- { name = 'buffer' },
              -- { name = 'path' },
              -- { name = 'cmdline' },
              { name = 'nvim_lua' },
          })
      })
      cmp.setup.cmdline(':', {
          mapping = cmp.mapping.preset.cmdline(),
          sources = cmp.config.sources({
              { name = 'path' },
              { name = 'cmdline' }
          })
      })
    end
  }
}
