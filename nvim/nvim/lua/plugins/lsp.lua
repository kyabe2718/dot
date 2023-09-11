return {
  'neovim/nvim-lspconfig',               -- configs for the Nvim LSP client
  dependencies = {
    'williamboman/mason.nvim',           -- easy editor tool manager
    'williamboman/mason-lspconfig.nvim', -- closes gaps between mason.nvim and nvim-lspconfig
  },
  config = function()
    -- LSP Server management
    require("mason").setup()

    -- See :help mason-lspconfig-automatic-server-setup
    require("mason-lspconfig").setup_handlers {
      -- The first entry (without a key) will be the default handler
      -- and will be called for each installed server that doesn't have
      -- a dedicated handler.
      function(server_name) -- default handler (optional)
        require("lspconfig")[server_name].setup {
          capabilities = require('cmp_nvim_lsp').default_capabilities()
        }
      end,
      -- -- Next, you can provide a dedicated handler for specific servers.
      -- -- For example, a handler override for the `rust_analyzer`:
      -- ["rust_analyzer"] = function ()
      --   require("rust-tools").setup {}
      -- end
    }

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

        -- vim.api.nvim_create_autocmd({ 'BufWritePre' }, {
        --   group = 'lsp_group', pattern = { "*" },
        --   callback = function()
        --     vim.lsp.buf.format({ async = false })
        --   end
        -- })
      end
    })
  end
}
