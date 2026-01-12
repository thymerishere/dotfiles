-- I hope you enjoy your Neovim journey,
-- - TJ

-- Set <space> as the leader key
-- See `:help mapleader`
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Set to true if you have a Nerd Font installed and selected in the terminal
vim.g.have_nerd_font = true

-- [[ Setting options ]]
-- See `:help vim.opt`

-- Make line numbers default
vim.opt.number = true
-- You can also add relative line numbers, to help with jumping.
--  Experiment for yourself to see if you like it!
vim.opt.relativenumber = true

-- Enable mouse mode, can be useful for resizing splits for example!
vim.opt.mouse = 'a'

-- Don't show the mode, since it's already in the status line
vim.opt.showmode = false

-- Enable break indent
vim.opt.breakindent = true

-- Save undo history
vim.opt.undofile = true

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Keep signcolumn on by default
vim.opt.signcolumn = 'yes'

-- Decrease update time
vim.opt.updatetime = 250

-- Decrease mapped sequence wait time
-- Displays which-key popup sooner
vim.opt.timeoutlen = 300

-- Configure how new splits should be opened
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Sets how neovim will display certain whitespace characters in the editor.
--  See `:help 'list'`
--  and `:help 'listchars'`
vim.opt.list = true
vim.opt.listchars = { tab = '  ', trail = '.', nbsp = '␣' }

-- Set tab width
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4

-- Preview substitutions live, as you type!
vim.opt.inccommand = 'split'

-- Show which line your cursor is on
vim.opt.cursorline = false

-- Minimal number of screen lines to keep above and below the cursor.
vim.opt.scrolloff = 10

-- Add virtual text diagnostics
vim.diagnostic.config {
  virtual_text = true,
  -- virtual_lines = { current_line = false },
}

-- Temporary workarround for issue with treesitter giving nil errors
vim.hl = vim.highlight

-- Center on up and down
vim.keymap.set('n', '<c-d>', '<c-d>zz')
vim.keymap.set('n', '<c-u>', '<c-u>zz')
vim.keymap.set('n', '<c-b>', '<c-b>zz')
vim.keymap.set('n', '<c-f>', '<c-f>zz')

-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

-- Copy to clipboard
vim.keymap.set({ 'n', 'v' }, '<leader>y', [["+y]])
vim.keymap.set('n', '<leader>Y', [["+Y]])
vim.keymap.set({ 'n', 'v' }, '<leader>p', [["+p]])
vim.keymap.set('n', '<leader>P', [["+P]])

-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Diagnostic keymaps
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--
--  See `:help wincmd` for a list of all window commands
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })


-- Keybinds for LSP actions
vim.keymap.set('n', '<leader>cr', vim.lsp.buf.rename, { desc = 'Rename symbol' })
-- vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, { desc = 'Code Action' })
-- vim.keymap.set('n', 'K', vim.lsp.buf.signature_help, { desc = 'Hover info' })
vim.keymap.set(
  { 'n', 'x' },
  '<leader>ca',
  '<cmd>lua require("fastaction").code_action()<CR>',
  { desc = "Display code actions", buffer = bufnr }
)

-- vim.lsp.config['basedpyright'] = {
--   settings = {
--     basedpyright = {
--       -- Using Ruff's import organizer
--       disableOrganizeImports = true,
--     },
--     python = {
--       analysis = {
--         -- Ignore all files for analysis to exclusively use Ruff for linting
--         ignore = { '*' },
--       },
--     },
--   },
-- }


vim.lsp.config['pyrefly'] = {
  cmd = { 'pyrefly', 'lsp' },
  filetypes = { 'python' },
  root_markers = { '.git', "pyproject.toml" },
  init_options = {
    pyrefly = {
      displayTypeErrors = "force-on"
    },
  }
}

vim.lsp.config['mojo'] = {
  cmd = { 'mojo-lsp-server' },
  filetypes = { 'mojo' },
  root_markers = { '.git' },
}

vim.lsp.enable("mojo")


-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- [[ Install `lazy.nvim` plugin manager ]]
--    See `:help lazy.nvim.txt` or https://github.com/folke/lazy.nvim for more info
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.uv.fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
  if vim.v.shell_error ~= 0 then
    error('Error cloning lazy.nvim:\n' .. out)
  end
end ---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(lazypath)

-- [[ Configure and install plugins ]]
--
--  To check the current status of your plugins, run
--    :Lazy
--
--  You can press `?` in this menu for help. Use `:q` to close the window
--
--  To update plugins you can run
--    :Lazy update
--
require('lazy').setup({
  'tpope/vim-sleuth',   -- Detect tabstop and shiftwidth automatically
  {                     -- Useful plugin to show you pending keybinds.
    'folke/which-key.nvim',
    event = 'VimEnter', -- Sets the loading event to 'VimEnter'
    config = function() -- This is the function that runs, AFTER loading
      require('which-key').setup()

      -- Document existing key chains
      require('which-key').add {
        { '<leader>c', group = '[C]ode' },
        { '<leader>d', group = '[D]ocument' },
        { '<leader>r', group = '[R]un' },
        { '<leader>s', group = '[S]earch' },
        { '<leader>w', group = '[W]orkspace' },
        { '<leader>t', group = '[T]oggle' },
        { '<leader>h', group = 'Git [H]unk', mode = { 'n', 'v' } },
      }
    end,
  },

  -- LuaSnip for snippet management
  {
    'benfowler/telescope-luasnip.nvim',
    lazy = false,
    config = function()
      local luasnip = require 'luasnip'
      luasnip.config.setup {}

      local snip = luasnip.snippet
      local node = luasnip.snippet_node
      local text = luasnip.text_node
      local insert = luasnip.insert_node
      local func = luasnip.function_node
      local choice = luasnip.choice_node
      local dynamicn = luasnip.dynamic_node

      -- Definine some snippets for python
      luasnip.add_snippets(nil, {
        python = {
          snip('cell', {
            text { '@app.cell', 'def _():', '\t' },
            insert(0),
          }),
          snip('pl', {
            text { 'import polars as pl', '' },
            insert(0),
          }),
          snip('px', {
            text { 'from plotly import express as px', '' },
            insert(0),
          }),
          snip('ft', {
            text { '"%FT%T%:z"' },
            insert(0),
          }),
        },
      })
    end,
  },
  -- Snacks contains many useful plugins but I'm only using a select few (maybe even only one)
  {
    "folke/snacks.nvim",
    opts = {
      picker = {}, -- Replacement for Telescope
    },
    keys = {
      -- Top Pickers
      ---@module "snacks"
      { "<leader>sf",       function() Snacks.picker.smart() end,                                   desc = "Smart Find Files" },
      { "<leader><leader>", function() Snacks.picker.buffers() end,                                 desc = "Buffers" },
      { "<leader>/",        function() Snacks.picker.grep() end,                                    desc = "Grep" },
      { "<leader>:",        function() Snacks.picker.command_history() end,                         desc = "Command History" },
      -- find
      { "<leader>fc",       function() Snacks.picker.files({ cwd = vim.fn.stdpath("config") }) end, desc = "Find Config File" },
      { "<leader>ff",       function() Snacks.picker.files() end,                                   desc = "Find Files" },
      { "<leader>fg",       function() Snacks.picker.git_files() end,                               desc = "Find Git Files" },
      { "<leader>fp",       function() Snacks.picker.projects() end,                                desc = "Projects" },
      { "<leader>fr",       function() Snacks.picker.recent() end,                                  desc = "Recent" },
      -- git
      { "<leader>gb",       function() Snacks.picker.git_branches() end,                            desc = "Git Branches" },
      -- { "<leader>gl",       function() Snacks.picker.git_log() end,                                 desc = "Git Log" },
      -- { "<leader>gL",       function() Snacks.picker.git_log_line() end,                            desc = "Git Log Line" },
      { "<leader>gs",       function() Snacks.picker.git_status() end,                              desc = "Git Status" },
      { "<leader>gS",       function() Snacks.picker.git_stash() end,                               desc = "Git Stash" },
      { "<leader>gd",       function() Snacks.picker.git_diff() end,                                desc = "Git Diff (Hunks)" },
      { "<leader>gf",       function() Snacks.picker.git_log_file() end,                            desc = "Git Log File" },
      -- Grep
      { "<leader>sb",       function() Snacks.picker.lines() end,                                   desc = "Buffer Lines" },
      { "<leader>sB",       function() Snacks.picker.grep_buffers() end,                            desc = "Grep Open Buffers" },
      { "<leader>sg",       function() Snacks.picker.grep() end,                                    desc = "Grep" },
      { "<leader>sw",       function() Snacks.picker.grep_word() end,                               desc = "Visual selection or word", mode = { "n", "x" } },
      -- search
      { '<leader>s"',       function() Snacks.picker.registers() end,                               desc = "Registers" },
      { '<leader>s/',       function() Snacks.picker.search_history() end,                          desc = "Search History" },
      { "<leader>sa",       function() Snacks.picker.autocmds() end,                                desc = "Autocmds" },
      { "<leader>sb",       function() Snacks.picker.lines() end,                                   desc = "Buffer Lines" },
      { "<leader>sc",       function() Snacks.picker.command_history() end,                         desc = "Command History" },
      { "<leader>sC",       function() Snacks.picker.commands() end,                                desc = "Commands" },
      { "<leader>sd",       function() Snacks.picker.diagnostics() end,                             desc = "Diagnostics" },
      { "<leader>sD",       function() Snacks.picker.diagnostics_buffer() end,                      desc = "Buffer Diagnostics" },
      { "<leader>sh",       function() Snacks.picker.help() end,                                    desc = "Help Pages" },
      { "<leader>sH",       function() Snacks.picker.highlights() end,                              desc = "Highlights" },
      { "<leader>si",       function() Snacks.picker.icons() end,                                   desc = "Icons" },
      { "<leader>sj",       function() Snacks.picker.jumps() end,                                   desc = "Jumps" },
      { "<leader>sk",       function() Snacks.picker.keymaps() end,                                 desc = "Keymaps" },
      { "<leader>sl",       function() Snacks.picker.loclist() end,                                 desc = "Location List" },
      { "<leader>sm",       function() Snacks.picker.marks() end,                                   desc = "Marks" },
      { "<leader>sM",       function() Snacks.picker.man() end,                                     desc = "Man Pages" },
      { "<leader>sp",       function() Snacks.picker.lazy() end,                                    desc = "Search for Plugin Spec" },
      { "<leader>sq",       function() Snacks.picker.qflist() end,                                  desc = "Quickfix List" },
      { "<leader>sR",       function() Snacks.picker.resume() end,                                  desc = "Resume" },
      { "<leader>su",       function() Snacks.picker.undo() end,                                    desc = "Undo History" },
      { "<leader>uC",       function() Snacks.picker.colorschemes() end,                            desc = "Colorschemes" },
      -- LSP
      { "gd",               function() Snacks.picker.lsp_definitions() end,                         desc = "Goto Definition" },
      { "gD",               function() Snacks.picker.lsp_declarations() end,                        desc = "Goto Declaration" },
      { "gr",               function() Snacks.picker.lsp_references() end,                          nowait = true,                     desc = "References" },
      { "gi",               function() Snacks.picker.lsp_implementations() end,                     desc = "Goto Implementation" },
      { "gy",               function() Snacks.picker.lsp_type_definitions() end,                    desc = "Goto T[y]pe Definition" },
      { "<leader>ss",       function() Snacks.picker.lsp_symbols() end,                             desc = "LSP Symbols" },
      { "<leader>sS",       function() Snacks.picker.lsp_workspace_symbols() end,                   desc = "LSP Workspace Symbols" },
    },
  },
  {
    -- `lazydev` configures Lua LSP for your Neovim config, runtime and plugins
    -- used for completion, annotations and signatures of Neovim apis
    'folke/lazydev.nvim',
    ft = 'lua',
    opts = {
      library = {
        -- Load luvit types when the `vim.uv` word is found
        { path = 'luvit-meta/library', words = { 'vim%.uv' } },
      },
    },
  },
  -- Help pages for loops in Lua
  { 'Bilal2453/luvit-meta',     lazy = true },
  {
    'mason-org/mason-lspconfig.nvim',
    opts = {
      ensure_installed = { 'lua_ls', 'gopls', 'tinymist', 'rust_analyzer' },
    },
    dependencies = {
      { 'mason-org/mason.nvim', opts = {} },
      'neovim/nvim-lspconfig',
    },
  },

  { -- Autoformat
    'stevearc/conform.nvim',
    event = { 'BufWritePre' },
    cmd = { 'ConformInfo' },
    keys = {
      {
        '<leader>cf',
        function()
          require('conform').format { async = true, lsp_fallback = true }
        end,
        mode = '',
        desc = '[F]ormat buffer',
      },
    },
    opts = {
      notify_on_error = false,
      format_on_save = function(bufnr)
        -- Disable "format_on_save lsp_fallback" for languages that don't
        -- have a well standardized coding style. You can add additional
        -- languages here or re-enable it for the disabled ones.
        local disable_filetypes = { c = true, cpp = true }
        return {
          timeout_ms = 500,
          lsp_fallback = not disable_filetypes[vim.bo[bufnr].filetype],
        }
      end,
      formatters_by_ft = {
        lua = { 'stylua' },
        go = { 'golines' },
        python = { 'ruff_fix', 'ruff_format' },
        --
        -- You can use 'stop_after_first' to run the first available formatter from the list
        -- javascript = { "prettierd", "prettier", stop_after_first = true },
      },
    },
  },

  { -- Autocompletion
    'hrsh7th/nvim-cmp',
    event = 'InsertEnter',
    dependencies = {
      -- Snippet Engine & its associated nvim-cmp source
      {
        'L3MON4D3/LuaSnip',
        build = (function()
          -- Build Step is needed for regex support in snippets.
          -- This step is not supported in many windows environments.
          -- Remove the below condition to re-enable on windows.
          if vim.fn.has 'win32' == 1 or vim.fn.executable 'make' == 0 then
            return
          end
          return 'make install_jsregexp'
        end)(),
        dependencies = {
          -- `friendly-snippets` contains a variety of premade snippets.
          --    See the README about individual language/framework/plugin snippets:
          --    https://github.com/rafamadriz/friendly-snippets
          {
            'rafamadriz/friendly-snippets',
            config = function()
              require('luasnip.loaders.from_vscode').lazy_load()
            end,
          },
        },
      },
      'saadparwaiz1/cmp_luasnip',

      -- Adds other completion capabilities.
      --  nvim-cmp does not ship with all sources by default. They are split
      --  into multiple repos for maintenance purposes.
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-nvim-lsp-signature-help'
    },
    config = function()
      -- See `:help cmp`
      local cmp = require 'cmp'
      local luasnip = require 'luasnip'

      cmp.setup {
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        completion = { completeopt = 'menu,menuone,noinsert' },

        -- window = {
        --   completion = {
        --     border = 'rounded',
        --   },
        --   documentation = {
        --     border = 'rounded',
        --   },
        -- },

        -- For an understanding of why these mappings were
        -- chosen, you will need to read `:help ins-completion`
        --
        -- No, but seriously. Please read `:help ins-completion`, it is really good!
        mapping = cmp.mapping.preset.insert {
          -- Select the [n]ext item
          ['<C-n>'] = cmp.mapping.select_next_item(),
          -- Select the [p]revious item
          ['<C-p>'] = cmp.mapping.select_prev_item(),

          -- Scroll the documentation window [b]ack / [f]orward
          ['<C-b>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),

          -- Accept ([y]es) the completion.
          --  This will auto-import if your LSP supports it.
          --  This will expand snippets if the LSP sent a snippet.
          ['<C-y>'] = cmp.mapping.confirm { select = true },

          -- If you prefer more traditional completion keymaps,
          -- you can uncomment the following lines
          --['<CR>'] = cmp.mapping.confirm { select = true },
          --['<Tab>'] = cmp.mapping.select_next_item(),
          --['<S-Tab>'] = cmp.mapping.select_prev_item(),

          -- Manually trigger a completion from nvim-cmp.
          --  Generally you don't need this, because nvim-cmp will display
          --  completions whenever it has completion options available.
          ['<C-Space>'] = cmp.mapping.complete {},

          -- Think of <c-l> as moving to the right of your snippet expansion.
          --  So if you have a snippet that's like:
          --  function $name($args)
          --    $body
          --  end
          --
          -- <c-l> will move you to the right of each of the expansion locations.
          -- <c-h> is similar, except moving you backwards.
          ['<C-l>'] = cmp.mapping(function()
            if luasnip.expand_or_locally_jumpable() then
              luasnip.expand_or_jump()
            end
          end, { 'i', 's' }),
          ['<C-h>'] = cmp.mapping(function()
            if luasnip.locally_jumpable(-1) then
              luasnip.jump(-1)
            end
          end, { 'i', 's' }),

          -- For more advanced Luasnip keymaps (e.g. selecting choice nodes, expansion) see:
          --    https://github.com/L3MON4D3/LuaSnip?tab=readme-ov-file#keymaps
        },
        sources = {
          {
            name = 'lazydev',
            -- set group index to 0 to skip loading LuaLS completions as lazydev recommends it
            group_index = 0,
          },
          { name = 'nvim_lsp' },
          { name = 'luasnip' },
          { name = 'path' },
          -- { name = 'nvim_lsp_signature_help' }
        },
      }
    end,
  },

  -- Highlight todo, notes, etc in comments
  { 'folke/todo-comments.nvim', event = 'VimEnter', dependencies = { 'nvim-lua/plenary.nvim' }, opts = { signs = false } },

  { -- Collection of various small independent plugins/modules
    'echasnovski/mini.nvim',
    config = function()
      -- Better Around/Inside textobjects
      require('mini.ai').setup { n_lines = 500 }
      require('mini.surround').setup {
        mappings = {
          add = 'ysa',            -- Add surrounding in Normal and Visual modes
          delete = 'ysd',         -- Delete surrounding
          find = 'ysf',           -- Find surrounding (to the right)
          find_left = 'ysF',      -- Find surrounding (to the left)
          highlight = 'ysh',      -- Highlight surrounding
          replace = 'ysr',        -- Replace surrounding
          update_n_lines = 'ysn', -- Update `n_lines`

          suffix_last = 'l',      -- Suffix to search with "prev" method
          suffix_next = 'n',      -- Suffix to search with "next" method
        },
      }
    end,
  },
  { -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    opts = {
      ensure_installed = { 'bash', 'c', 'diff', 'html', 'lua', 'luadoc', 'markdown', 'markdown_inline', 'query', 'vim', 'vimdoc', 'typst' },
      -- Autoinstall languages that are not installed
      auto_install = true,
      highlight = {
        enable = true,
        -- Some languages depend on vim's regex highlighting system (such as Ruby) for indent rules.
        --  If you are experiencing weird indenting issues, add the language to
        --  the list of additional_vim_regex_highlighting and disabled languages for indent.
        additional_vi_regex_highlighting = { 'ruby' },
      },
      indent = { enable = true, disable = { 'ruby' } },
    },
    config = function(_, opts)
      -- [[ Configure Treesitter ]] See `:help nvim-treesitter`

      ---@diagnostic disable-next-line: missing-fields
      require('nvim-treesitter.configs').setup(opts)

      -- There are additional nvim-treesitter modules that you can use to interact
      -- with nvim-treesitter. You should go explore a few and see what interests you:
      --
      --    - Incremental selection: Included, see `:help nvim-treesitter-incremental-selection-mod`
      --    - Show your current context: https://github.com/nvim-treesitter/nvim-treesitter-context
      --    - Treesitter + textobjects: https://github.com/nvim-treesitter/nvim-treesitter-textobjects
    end,
  },

  require 'plugins.autopairs',
  require 'plugins.colorscheme',
  require 'plugins.oil',
  require 'plugins.flash',
  require 'plugins.gitsigns',
  require 'plugins.fugitive',
  require 'plugins.arrow',
  require 'plugins.fastaction',
  require 'plugins.heirline',
  require 'plugins.dap',
  require 'plugins.dap-view',
  require 'plugins.typst-preview',
  require 'plugins.render-markdown',
  require 'plugins.spectre',

  -- require 'plugins.lsp_signature',
  -- require 'plugins.noice',
  -- require 'plugins.lualine',
  -- require 'plugins.indent_line',
  -- require 'plugins.lint',
  -- require 'plugins.neo-tree',
  -- require 'plugins.molten',
  -- require 'plugins.obsidian',
  -- require 'plugins.harpoon',
  -- require 'plugins.tailwind-tools',
  -- require 'plugins.surround',
  -- require 'plugins.kitty',
  -- require 'plugins.multicursor',
}, {
  ui = {
    icons = vim.g.have_nerd_font and {} or {
      cmd = '⌘',
      config = '🛠',
      event = '📅',
      ft = '📂',
      init = '⚙',
      keys = '🗝',
      plugin = '🔌',
      runtime = '💻',
      require = '🌙',
      source = '📄',
      start = '🚀',
      task = '📌',
      lazy = '💤 ',
    },
  },
})

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
