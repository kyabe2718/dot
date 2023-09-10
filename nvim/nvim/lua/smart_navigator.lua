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
