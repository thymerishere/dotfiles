return {
  {
    'igorlfs/nvim-dap-view',
    ---@module 'dap-view'
    ---@type dapview.Config
    opts = {},
    keys = function()
      local dapview = require 'dap-view'

      return {
        { '<leader>ru', dapview.toggle, desc = 'Debug: Dap UI' },
      }
    end,
  },
}
