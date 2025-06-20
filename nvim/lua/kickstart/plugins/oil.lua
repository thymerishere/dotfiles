return {
  'stevearc/oil.nvim',
  ---@module 'oil'
  ---@type oil.SetupOpts
  opts = {
    default_file_explorer = true,
    delete_to_trash = true,
    skip_confirm_for_simple_edits = false,
    view_options = {
      show_hidden = true,
      natural_order = true,
      is_always_hidden = function(name, _)
        return name == '..' or name == '.git'
      end,
    },
    win_options = {
      wrap = true,
    },
    keymaps = {
      -- ['yp'] = {
      --   'actions.yank_entry',
      --   desc = 'Yank filepath of entry',
      -- },
      ['yp'] = {
        callback = function()
          local oil = require 'oil'
          local entry = oil.get_cursor_entry()
          local dir = oil.get_current_dir()

          if not entry or not dir then
            return
          end

          local relpath = vim.fn.fnamemodify(dir, ':.')
          vim.fn.setreg('"', relpath .. entry.name)
        end,
      },
      ['<leader>yp'] = {
        -- Same as yp, only copy to system clipboard
        callback = function()
          local oil = require 'oil'
          local entry = oil.get_cursor_entry()
          local dir = oil.get_current_dir()

          if not entry or not dir then
            return
          end

          local relpath = vim.fn.fnamemodify(dir, ':.')
          vim.fn.setreg('+', relpath .. entry.name)
        end,
      },
    },
    vim.keymap.set('n', '-', '<CMD>Oil --float<CR>', { desc = 'Open parent directory' }),
  },
  -- Optional dependencies
  dependencies = { { 'echasnovski/mini.icons', opts = {} } },
  -- dependencies = { "nvim-tree/nvim-web-devicons" }, -- use if you prefer nvim-web-devicons
  -- Lazy loading is not recommended because it is very tricky to make it work correctly in all situations.
  lazy = false,
}
