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
        require("lspconfig")[server_name].setup {
            capabilities = require('cmp_nvim_lsp').default_capabilities()
        }
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
        ['<C-d>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
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

require('cmp_nvim_lsp').default_capabilities()

local jump_lsp_newtab = function(name)
    local handler = vim.lsp.handlers[name]
    vim.lsp.handlers[name] = function(_, result, ctx, config)
        -- print(vim.inspect(result))
        return handler(_, result, ctx, config)
    end
end

jump_lsp_newtab('textDocument/definition')
jump_lsp_newtab('textDocument/declaration')
jump_lsp_newtab('textDocument/typeDefinition')
jump_lsp_newtab('textDocument/implementation')

