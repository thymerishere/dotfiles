return {
  {
    'igorlfs/nvim-dap-view',
    ---@module 'dap-view'
    ---@type dapview.Config
    opts = {},
    keys = function()
      local dapview = require 'dap-view'

      return {
        { '<leader>ru', dapview.toggle,                                     desc = 'Debug: Dap UI' },
        { '<leader>ww', function() dapview.jump_to_view("watches") end,     desc = 'Debug: Watches' },
        { '<leader>ws', function() dapview.jump_to_view("scopes") end,      desc = 'Debug: Scopes' },
        { '<leader>we', function() dapview.jump_to_view("exceptions") end,  desc = 'Debug: Exceptions' },
        { '<leader>wb', function() dapview.jump_to_view("breakpoints") end, desc = 'Debug: Breakpoints' },
        { '<leader>wt', function() dapview.jump_to_view("threads") end,     desc = 'Debug: Threads' },
        { '<leader>wr', function() dapview.jump_to_view("repl") end,        desc = 'Debug: REPL' },
      }
    end,
  },
}
