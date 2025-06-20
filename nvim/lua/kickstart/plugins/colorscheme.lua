-- return {
--   'EdenEast/nightfox.nvim',
--   opts = {
--     transparent = true,
--   },
--   lazy = false,
--   priority = 1000,
--   config = function(_, opts)
--     local nightfox = require 'nightfox'
--     nightfox.setup(opts)
--     nightfox.load()
--   end,
-- }

return {
  'catppuccin/nvim',
  opts = {
    flavour = 'frappe',
    transparent_background = true,
  },
  lazy = false,
  priority = 1000,
  config = function(_, opts)
    local theme = require 'catppuccin'
    theme.setup(opts)
    theme.load()
  end,
}

-- return {
--   'projekt0n/github-nvim-theme',
--   options = {
--     transparent = true,
--   },
--   config = function(_, options)
--     local github = require 'github-nvim-theme'
--     github.setup(options)
--     github.load()
--   end,
-- }

-- return {
--   'folke/tokyonight.nvim',
--   lazy = false,
--   priority = 1000,
--   opts = {
--     style = 'day',
--     transparent = true,
--     styles = {
--       sidebars = 'transparent',
--       floats = 'transparent',
--     },
--   },
--   config = function(_, opts)
--     local tokyonight = require 'tokyonight'
--     tokyonight.setup(opts)
--     tokyonight.load()
--   end,
-- }
