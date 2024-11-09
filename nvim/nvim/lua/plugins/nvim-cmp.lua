return {
  'hrsh7th/cmp-nvim-lsp', -- nvim-cmp source for lsp
  'hrsh7th/cmp-buffer',   -- nvim-cmp source for buffer
  'hrsh7th/cmp-path',     -- nvim-cmp source for filesystem paths
  'hrsh7th/cmp-cmdline',  -- nvim-cmp source for vim cmdline
  'hrsh7th/cmp-nvim-lua', -- nvim-cmp source for neovim lua API
  {'L3MON4D3/LuaSnip',
    -- follow latest release.
    version = "v2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
    -- install jsregexp (optional!).
    build = "make install_jsregexp"
  },
  { 'saadparwaiz1/cmp_luasnip' },
  { 'hrsh7th/nvim-cmp',     -- Autocompletion plugin
    config = function()
      local cmp = require('cmp')
      cmp.setup({
          snippet = {
            expand = function(args)
              require('luasnip').lsp_expand(args.body)
            end,
          },
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
              { name = 'luasnip' },
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
