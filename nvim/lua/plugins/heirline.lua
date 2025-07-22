return {
  'rebelot/heirline.nvim',
  config = function()
    local conditions = require 'heirline.conditions'
    local utils = require 'heirline.utils'
    local colors = require('catppuccin.palettes').get_palette 'frappe'

    local Align = { provider = '%=' }
    local LeftSep = { provider = ' ⟩ ', hl = { fg = colors.overlay0 } }
    local RightSep = { provider = ' ⟨ ', hl = { fg = colors.overlay0 } }
    local Space = { provider = ' ', hl = { fg = colors.overlay0 } }

    -- NOTE: Vi mode (insert, normal, visual, ...)
    local ViMode = {
      -- get vim current mode, this information will be required by the provider
      -- and the highlight functions, so we compute it only once per component
      -- evaluation and store it as a component attribute
      init = function(self)
        self.mode = vim.fn.mode(1) -- :h mode()
      end,
      -- Now we define some dictionaries to map the output of mode() to the
      -- corresponding string and color. We can put these into `static` to compute
      -- them at initialisation time.
      static = {
        mode_names = { -- change the strings if you like it vvvvverbose!
          n = 'NORMAL',
          no = 'NORMAL?',
          nov = 'NORMAL?',
          noV = 'NORMAL?',
          ['no\22'] = 'NORMAL?',
          niI = 'NORMALi',
          niR = 'NORMALr',
          niV = 'NORMALv',
          nt = 'NORMALt',
          v = 'VISUAL',
          vs = 'VISUALs',
          V = 'VISUAL_',
          Vs = 'VISUALs',
          ['\22'] = '^VISUAL',
          ['\22s'] = '^VISUAL',
          s = 'S',
          S = 'S_',
          ['\19'] = '^S',
          i = 'INSERT',
          ic = 'INSERTc',
          ix = 'INSERTx',
          R = 'REPLACE',
          Rc = 'REPLACEc',
          Rx = 'REPLACEx',
          Rv = 'REPLACEv',
          Rvc = 'REPLACEv',
          Rvx = 'REPLACEv',
          c = 'COMMAND',
          cv = 'EX',
          r = '...',
          rm = 'M',
          ['r?'] = '?',
          ['!'] = '!',
          t = 'T',
        },
        mode_colors = {
          n = colors.red,
          i = colors.teal,
          v = colors.sky,
          V = colors.sky,
          ['\22'] = colors.sky,
          c = colors.peach,
          s = colors.mauve,
          S = colors.mauve,
          ['\19'] = colors.mauve,
          R = colors.yellow,
          r = colors.yellow,
          ['!'] = colors.red,
          t = colors.pink,
        },
      },
      -- We can now access the value of mode() that, by now, would have been
      -- computed by `init()` and use it to index our strings dictionary.
      -- note how `static` fields become just regular attributes once the
      -- component is instantiated.
      -- To be extra meticulous, we can also add some vim statusline syntax to
      -- control the padding and make sure our string is always at least 2
      -- characters long. Plus a nice Icon.
      provider = function(self)
        -- return '  %2(' .. self.mode_names[self.mode] .. '%)'
        -- ⧉ ⟁
        return ' ⛫  ' .. self.mode_names[self.mode] .. ''
      end,
      -- Same goes for the highlight. Now the foreground will change according to the current mode.
      hl = function(self)
        local mode = self.mode:sub(1, 1) -- get only the first mode character
        return { fg = self.mode_colors[mode], bold = true }
      end,
      -- Re-evaluate the component only on ModeChanged event!
      -- Also allows the statusline to be re-evaluated when entering operator-pending mode
      update = {
        'ModeChanged',
        pattern = '*:*',
        callback = vim.schedule_wrap(function()
          vim.cmd 'redrawstatus'
        end),
      },
    }

    -- NOTE: Shows when recording a macro
    local MacroRec = {
      condition = function()
        return vim.fn.reg_recording() ~= '' and vim.o.cmdheight == 0
      end,
      provider = ' ',
      hl = { fg = colors.red, bold = true },
      utils.surround({ '[', ']' }, nil, {
        provider = function()
          return vim.fn.reg_recording()
        end,
        hl = { fg = colors.red, bold = true },
      }),
      update = {
        'RecordingEnter',
        'RecordingLeave',
      },
    }

    -- NOTE: Shows git status
    local Git = {
      condition = conditions.is_git_repo,

      init = function(self)
        self.status_dict = vim.b.gitsigns_status_dict
        self.is_main = self.status_dict.head == 'main' or self.status_dict.head == 'master'
        self.has_changes = self.status_dict.added ~= 0 or self.status_dict.removed ~= 0 or self.status_dict.changed ~= 0
      end,

      hl = { fg = colors.subtext0 },

      { -- git branch name
        provider = function(self)
          return ' ' .. self.status_dict.head
        end,
        hl = function(self)
          if self.is_main then
            return { bold = false, fg = colors.maroon }
          else
            return { bold = false }
          end
        end,
      },
      {
        condition = function(self)
          return self.has_changes
        end,
        provider = '(',
      },
      {
        provider = function(self)
          local count = self.status_dict.added or 0
          return count > 0 and ('+' .. count)
        end,
        hl = { fg = colors.green },
      },
      {
        provider = function(self)
          local count = self.status_dict.removed or 0
          return count > 0 and ('-' .. count)
        end,
        hl = { fg = colors.maroon },
      },
      {
        provider = function(self)
          local count = self.status_dict.changed or 0
          return count > 0 and ('~' .. count)
        end,
        hl = { fg = colors.yellow },
      },
      {
        condition = function(self)
          return self.has_changes
        end,
        provider = ')',
      },
    }

    -- NOTE: File name
    local FileNameBlock = {
      init = function(self)
        self.filename = vim.api.nvim_buf_get_name(0)
      end,
    }

    local FileIcon = {
      init = function(self)
        local filename = self.filename
        local extension = vim.fn.fnamemodify(filename, ':e')
        self.icon, self.icon_color = require('nvim-web-devicons').get_icon_color(filename, extension, { default = true })
      end,
      provider = function(self)
        return self.icon and (self.icon .. ' ')
      end,
      hl = function(self)
        return { fg = self.icon_color }
      end,
    }

    local FileName = {
      provider = function(self)
        -- first, trim the pattern relative to the current directory. For other
        -- options, see :h filename-modifers
        local filename = vim.fn.fnamemodify(self.filename, ':.')
        if filename == '' then
          return '[No Name]'
        end
        -- now, if the filename would occupy more than 1/4th of the available
        -- space, we trim the file path to its initials
        -- See Flexible Components section below for dynamic truncation
        if not conditions.width_percent_below(#filename, 0.25) then
          filename = vim.fn.pathshorten(filename)
        end
        return filename
      end,
      -- hl = { fg = utils.get_highlight('Directory').fg },
      hl = { fg = colors.subtext0 },
    }

    local FileFlags = {
      {
        condition = function()
          return vim.bo.modified
        end,
        provider = '[+]',
        hl = { fg = colors.green },
      },
      {
        condition = function()
          return not vim.bo.modifiable or vim.bo.readonly
        end,
        provider = '',
        hl = { fg = colors.maroon },
      },
    }

    local FileNameModifer = {
      hl = function()
        if vim.bo.modified then
          -- use `force` because we need to override the child's hl foreground
          return { fg = colors.green, old = true, force = true }
        end
      end,
    }

    -- let's add the children to our FileNameBlock component
    FileNameBlock = utils.insert(
      FileNameBlock,
      FileIcon,
      utils.insert(FileNameModifer, FileName), -- a new table where FileName is a child of FileNameModifier
      FileFlags,
      { provider = '%<' } -- this means that the statusline is cut here when there's not enough space
    )

    -- NOTE: Shows which language servers are active for the current document
    local LSPActive = {
      condition = conditions.lsp_attached,
      update = { 'LspAttach', 'LspDetach' },

      provider = function()
        local names = {}
        for i, server in pairs(vim.lsp.get_clients { bufnr = 0 }) do
          table.insert(names, server.name)
        end
        return ' [' .. table.concat(names, ' ') .. ']'
      end,
      hl = { fg = colors.subtext0, bold = false },
    }

    -- NOTE: Ruler and scrollbar for location in document
    local Ruler = {
      -- %l = current line number
      -- %L = number of lines in the buffer
      -- %c = column number
      -- %P = percentage through file of displayed window
      provider = '%7(%l/%3L%):%2c',
      hl = { fg = colors.mauve },
    }

    local ScrollBar = {
      static = {
        -- sbar = { '▁', '▂', '▃', '▄', '▅', '▆', '▇', '█' },
        sbar = { '🭶', '🭷', '🭸', '🭹', '🭺', '🭻' },
      },
      provider = function(self)
        local curr_line = vim.api.nvim_win_get_cursor(0)[1]
        local lines = vim.api.nvim_buf_line_count(0)
        local i = math.floor((curr_line - 1) / lines * #self.sbar) + 1
        return string.rep(self.sbar[i], 2)
      end,
      hl = { fg = colors.mauve, bg = colors.surface0 },
    }

    local StatusLine = {
      ViMode,
      MacroRec,
      LeftSep,
      { Git, LeftSep, FileNameBlock, LeftSep, LSPActive },
      Align,
      { Ruler, Space, ScrollBar },
    }

    require('heirline').setup {
      statusline = StatusLine,
      opts = {
        colors = colors,
      },
    }
  end,
}
