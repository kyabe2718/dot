local M = {}

function M.setup(opts)
  opts = {
    pattern = opts.pattern or "[\\u00A0\\u2000-\\u200B\\u3000]",
    highlight_args = opts.highlight_args or [[cterm=underline gui=underline ctermfg=lightblue guifg=lightblue ctermbg=darkgray guibg=darkgray]],
  }
  vim.api.nvim_create_augroup('extraWhiteSpace', {})
  vim.api.nvim_create_autocmd({"VimEnter", "WinEnter", "BufRead"}, {
    group = 'extraWhiteSpace',
    pattern = {"*"},
    command = string.format([[call matchadd("ExtraWhiteSpace", "%s")]], opts.pattern)
  })
  vim.api.nvim_create_autocmd({"ColorScheme"}, {
    group = 'extraWhiteSpace',
    pattern = {"*"},
    command = 'highlight ExtraWhiteSpace ' .. opts.highlight_args
  })
  vim.cmd('highlight ExtraWhiteSpace ' .. opts.highlight_args)
end

return M
