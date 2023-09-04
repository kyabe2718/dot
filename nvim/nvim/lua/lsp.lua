-- LSP Server management
require("mason").setup({
    ui = {
        icons = {
            package_installed = "✓",
            package_pending = "➜",
            package_uninstalled = "✗"
        }
    }
})

-- See :help mason-lspconfig-automatic-server-setup
require("mason-lspconfig").setup_handlers {
    -- The first entry (without a key) will be the default handler
    -- and will be called for each installed server that doesn't have
    -- a dedicated handler.
    function (server_name) -- default handler (optional)
        require("lspconfig")[server_name].setup {}
    end,
    -- -- Next, you can provide a dedicated handler for specific servers.
    -- -- For example, a handler override for the `rust_analyzer`:
    -- ["rust_analyzer"] = function ()
    --     require("rust-tools").setup {}
    -- end
}

-- Auto Completion
local cmp = require('cmp')
cmp.setup({
    mapping = cmp.mapping.preset.insert({
        ['<C-b>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-l>'] = cmp.mapping.complete(),
        ['<C-e>'] = cmp.mapping.abort(),
        ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    }),
    sources = cmp.config.sources({
        { name = 'nvim_lsp' },
        { name = 'buffer' },
        { name = 'path' },
        { name = 'cmdline' },
        { name = 'nvim_lua' },
    })
})

require('cmp_nvim_lsp').default_capabilities()

vim.api.nvim_create_augroup('LspGroup', {})
vim.api.nvim_create_autocmd('LspAttach', {
    group = 'LspGroup',
    callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        local opts = { buffer = args.buf }

        -- vim.keymap.set('n', 'K' , vim.lsp.buf.hover,            opts)
        -- vim.keymap.set('n', 'gf', vim.lsp.buf.format,           opts)
        -- vim.keymap.set('n', 'gi', vim.lsp.buf.implementation,   opts)
        -- vim.keymap.set('n', 'gd', '<cmd>lua vim.lsp.buf.definition() | <C-o><CR>', opts)
        -- vim.keymap.set('n', 'gb', '<cmd>lua vim.lsp.buf.declaration()', opts)

        -- vim.api.nvim_create_autocmd('CursorHold', {
        --     group = 'LspGroup',
        --     command = "lua vim.lsp.buf.hover()"
        -- })
    end
})
