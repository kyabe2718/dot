-- keymaps
-- :help vim.keymap.set
-- vim.keymap.set(mode, lhs, rhs, options)

vim.keymap.set('n', ';', ':')
vim.keymap.set('v', ';', ':')

-- vim.keymap.set('n', '<Esc><Esc>', ':nohlsearch<CR>')

vim.keymap.set('n', 'S-Left',  '<C-w><<CR>')
vim.keymap.set('n', 'S-Right', '<C-w>><CR>')
vim.keymap.set('n', 'S-Up',  '<C-w>-<CR>')
vim.keymap.set('n', 'S-Down',  '<C-w>+<CR>')

vim.keymap.set('n', '<C-w><S-h>', '<C-w><<CR>')
vim.keymap.set('n', '<C-w><S-l>', '<C-w>><CR>')
vim.keymap.set('n', '<C-w><S-j>', '<C-w>-<CR>')
vim.keymap.set('n', '<C-w><S-k>', '<C-w>+<CR>')

vim.keymap.set('n', 'gl', 'gt')
vim.keymap.set('n', 'gh', 'gT')

vim.keymap.set('n', '<A-Left>', '<C-o>')
vim.keymap.set('n', '<A-Right>', '<C-i>')

-- nvim-tree
-- vim.keymap.set('n', '<A-1>', '<cmd>:NvimTreeToggle<CR>')
vim.keymap.set('n', '<M-1>', function() vim.cmd('NvimTreeToggle') end)

local getjumplist = function()
  print(vim.inspect(vim.fn.getjumplist(1, 1)))
  local jumplist = vim.fn.getjumplist()[1]
  -- reverse the list
  local sorted_jumplist = {}
  for i = #jumplist, 1, -1 do
  if vim.api.nvim_buf_is_valid(jumplist[i].bufnr) then
    jumplist[i].filename = vim.api.nvim_buf_get_name(jumplist[i].bufnr)
    table.insert(sorted_jumplist, jumplist[i])
  end
  end
  return sorted_jumplist
end

vim.api.nvim_create_user_command('JumpList', function(buf)
  local jl = getjumplist()
  for i = 1, #jl do
    print(string.format("%4d %4d %s", jl[i].lnum, jl[i].col, jl[i].filename))
  end
end, {})


local is_tmux = function()
  return vim.env.TMUX ~= ""
end

local contains = function(arr, v)
  for i = 1, #arr do
    if v == arr[i] then
      return true
    end
  end
  return false
end

local try_to_move = function(dir)
  local pre_win = vim.api.nvim_win_get_number(0) -- current window
  vim.cmd(string.format("wincmd %s", dir))
  local cur_win = vim.api.nvim_win_get_number(0)
  return pre_win ~= cur_win
end

local hjkl2LDUR = {}
hjkl2LDUR["h"] = "L"
hjkl2LDUR["j"] = "D"
hjkl2LDUR["k"] = "U"
hjkl2LDUR["l"] = "R"

local smart_win_cmd = function(buf)
  local arg = buf.args
  if is_tmux() and contains({'h', 'j', 'k', 'l'}, arg) then
    if not try_to_move(arg) then
      vim.cmd(string.format("silent !tmux select-pane -%s\n", hjkl2LDUR[arg]))
    end
  else
    vim.cmd(string.format("wincmd %s\n", arg))
  end
end

vim.api.nvim_create_user_command("SmartWinCmd", smart_win_cmd, { nargs = 1 })
vim.keymap.set('n', '<C-w>h', ':silent SmartWinCmd h<CR>')
vim.keymap.set('n', '<C-w>j', ':silent SmartWinCmd j<CR>')
vim.keymap.set('n', '<C-w>k', ':silent SmartWinCmd k<CR>')
vim.keymap.set('n', '<C-w>l', ':silent SmartWinCmd l<CR>')
