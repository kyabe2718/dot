local set = vim.opt

-- view
set.number = true
set.ruler  = true
set.fileencoding = 'utf-8'
set.wrap = false
set.errorbells = false

--- match pairs
set.matchpairs:append('<:>') -- charcters that form pairs

--- scroll
set.scrolloff = 4
set.sidescrolloff = 2
set.sidescroll = 1

-- no backup
set.writebackup = false
set.backup   = false
set.swapfile = false

-- search
set.ignorecase = true
set.smartcase = true

-- editor style
set.tabstop = 4
set.shiftwidth = 0 -- = tabstop
set.softtabstop = -1 -- = shifwidth
set.expandtab = true
set.smartindent = true
set.autoindent = true

-- set tabstop for specific filetypes
vim.api.nvim_create_autocmd({"BufNewFile", "BufRead"}, {
  pattern = {"*.lua", ".vimrc", "*.vim"},
  callback = function() set.tabstop = 2 end
})

-- remove spaces at eol when saving
vim.api.nvim_create_autocmd({"BufWritePre"}, {
  pattern = {"*"},
  command = [[:%s/\s\+$//ge]]
})
set.splitbelow = true
set.splitright = true

-- colorscheme
---- show invisible char
set.list = true
set.listchars = { tab='>-', trail='-' }
require('utils/extra-whitespace').setup({})

set.termguicolors = true
set.background = 'dark'

-- others
set.backspace = {'indent', 'eol', 'start'}
set.clipboard:append({'unnamedplus'})
set.mouse = 'a' -- enable mouse for all modes
