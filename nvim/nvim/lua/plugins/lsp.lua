return {
  {
    'williamboman/mason.nvim',           -- easy editor tool manager
    config = function()
      require("mason").setup()
    end
  },
  {
    'williamboman/mason-lspconfig.nvim', -- closes gaps between mason.nvim and nvim-lspconfig
    config = function()
      -- See :help mason-lspconfig-automatic-server-setup
      require("mason-lspconfig").setup({
        ensure_installed = {
          "clangd",
          "rust_analyzer",
          "lua_ls",
          "pylsp"
        },
        automatic_installation = true,
        handlers = {
          -- The first entry (without a key) will be the default handler
          -- and will be called for each installed server that doesn't have
          -- a dedicated handler.
          function(server_name) -- default handler (optional)
            require("lspconfig")[server_name].setup {
              capabilities = require('cmp_nvim_lsp').default_capabilities()
            }
          end
        },
      })
    end
  },
  {
    'neovim/nvim-lspconfig',               -- configs for the Nvim LSP client
    config = function()
      vim.api.nvim_create_augroup('lsp_group', {})
      vim.api.nvim_create_autocmd('LspAttach', {
        group = 'lsp_group',
        callback = function(args)
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          local opts = { buffer = args.buf }
          vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover, { border = 'single' })

          vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
          vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
          vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
          vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
          vim.keymap.set('n', 'gf', vim.lsp.buf.format, opts)

          local customize_handler = function(name)
            -- c.f. :help lsp-handler
            local handler = vim.lsp.handlers[name]
            vim.lsp.handlers[name] = function(err, result, ctx, config)
              config = config or {reuse_win = true}

              local win = vim.api.nvim_get_current_win()
              local prev_buf = vim.api.nvim_win_get_buf(win)
              handler(err, result, ctx, config)
              local curr_buf = vim.api.nvim_win_get_buf(win)

              -- to show a target location in a new tab
              -- default handler uses a current window if there is no buffer opening a target location
              if prev_buf ~= curr_buf then
                vim.api.nvim_win_set_buf(0, prev_buf)
                vim.cmd.tabnew()
                vim.api.nvim_win_set_buf(0, curr_buf)
              end
            end
          end
          customize_handler('textDocument/definition')
          customize_handler('textDocument/declaration')
          customize_handler('textDocument/typeDefinition')
          customize_handler('textDocument/implementation')
        end
      })
    end
  }
}
