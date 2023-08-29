local set = vim.opt

-- view
set.number = true
set.ruler  = true
-- set.fileencoding = 'utf-8'
set.wrap = false
set.errorbells = false

--- match pairs
set.matchpairs:append('<:>') -- charcters that form pairs

--- scroll
set.scrolloff = 4
set.sidescrolloff = 2
set.sidescroll = 1

---- show invisible char
set.list = true
set.listchars = { tab='>-', trail='-' }

-- no backup
set.writebackup = false
set.backup   = false
set.swapfile = false

-- search
set.ignorecase = true
set.smartcase = true

-- editor style
set.tabstop = 4
set.expandtab = true
set.shiftwidth = 4
set.smartindent = true
set.autoindent = true
vim.api.nvim_create_autocmd({"BufWritePre"}, { -- remove spaces at eol when saving
    pattern = {"*"},
    command = [[:%s/\s\+$//ge]]
})

set.splitbelow = true
set.splitright = true

-- colorscheme
-- vim.cmd.colorscheme('elflord')
set.termguicolors = true
set.background = 'dark'
-- vim.cmd.colorscheme('elflord')
vim.cmd.colorscheme('melange')

-- others
set.backspace = {'indent', 'eol', 'start'}
set.clipboard:append({unnamedplus=true})
set.mouse = 'a'
