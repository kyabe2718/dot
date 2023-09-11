return {
  {
    'nvim-tree/nvim-tree.lua', -- File Explorer
    config = function()
      -- nvim-tree --
      vim.g.loaded_netrw = 1
      vim.g.loaded_netrwPlugin = 1

      require('nvim-tree').setup({
        sort_by = 'case_sensitive',
        view = {
          number = true
        },
        tab = {
          sync = { open = true, close = true }
        },
        on_attach = function (buf)
          local api = require ('nvim-tree.api')
          local function opts(desc)
            return { desc = "nvim-tree: " .. desc, buffer = buf, noremap = true, silent = true, nowait = true }
          end
          -- default mapping
          api.config.mappings.default_on_attach(buf)

          -- custom mapping
          vim.keymap.set('n', '?', api.tree.toggle_help, opts('Help'))
          vim.keymap.set('n', '<CR>', function()
              local wins = vim.api.nvim_tabpage_list_wins(0)
              local cwin = vim.api.nvim_get_current_win()
              for i = 1, #wins do
                if wins[i] ~= cwin then -- not eqaul
                  local b = vim.api.nvim_win_get_buf(wins[i])
                  local name = vim.api.nvim_buf_get_name(b)
                  if string.len(name) ~= 0 then
                    -- Open in new tab if non-empty window exists
                    api.node.open.tab_drop()
                    return
                  end
                end
              end
              -- Open in current tab if all windows are empty
              api.node.open.drop()
            end,
            opts('Open: Current or New Tab'))
        end,
      })

      -- Closes the explorer when all other windows are closed
      vim.api.nvim_create_augroup("file_explorer", {})
      vim.api.nvim_create_autocmd("QuitPre", {
        group = "file_explorer",
        callback = function(ev)
          local nt_api = require('nvim-tree.api')
          local wins = vim.api.nvim_tabpage_list_wins(0)
          local curbuf = vim.api.nvim_win_get_buf(0)
          local remain_other_wins = false
          for i = 1, #wins do
            local bufid = vim.api.nvim_win_get_buf(wins[i])
            if bufid ~= curbuf and not nt_api.tree.is_tree_buf(bufid) then
              remain_other_wins = true
              break
            end
          end
          if not remain_other_wins then
            nt_api.tree.close_in_this_tab()
          end
        end,
      })
      vim.api.nvim_create_autocmd("TabLeave", {
        group = "file_explorer",
        callback = function(ev)
          local nt_api = require('nvim-tree.api')
          local curbuf = vim.api.nvim_win_get_buf(0)
          if not nt_api.tree.is_tree_buf(curbuf) then
            return
          end
          local wins = vim.api.nvim_tabpage_list_wins(0)
          for i = 1, #wins do
            local bufid = vim.api.nvim_win_get_buf(wins[i])
            if not nt_api.tree.is_tree_buf(bufid) then
              vim.api.nvim_set_current_win(wins[i])
              return
            end
          end
        end
      })
    end
  },
  'nvim-tree/nvim-web-devicons',
  -- 'nvim-treesitter/nvim-treesitter',
}
