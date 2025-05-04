-- Load lualine
local lualine = require('lualine')

-- Load the papercolor_dark theme
local papercolor_dark = require('papercolor_dark')

-- Customize diagnostics colors to match the theme
local diagnostics_colors = {
  error = { fg = papercolor_dark.error }, -- Use the error color from the theme
  warn = { fg = papercolor_dark.orange },
  info = { fg = papercolor_dark.aqua },
  hint = { fg = papercolor_dark.green },
}

-- Configure lualine
lualine.setup {
  options = {
    theme = papercolor_dark, -- Use the provided papercolor_dark theme
    section_separators = { left = '', right = '' }, -- Modern section separators
    component_separators = { left = '', right = '' }, -- Component separators
    icons_enabled = true, -- Enable icons (requires nvim-web-devicons)
    globalstatus = true, -- Use a global statusline (Neovim 0.7+)
    disabled_filetypes = {
      statusline = { 'alpha', 'dashboard' }, -- Disable for Alpha dashboard
      winbar = {},
    },
    refresh = {
      statusline = 100, -- Refresh every 100ms
      tabline = 100,
      winbar = 100,
    },
  },
  sections = {
    -- Left side sections
    lualine_a = { 'mode' }, -- Show the current mode (Normal, Insert, Visual, etc.)
    lualine_b = {
      { 'branch', icon = '' }, -- Git branch with an icon
      { 'diff', symbols = { added = '+', modified = '~', removed = '-' } }, -- Git diff status
    },
    lualine_c = {
      {
        'diagnostics',
        sources = { 'nvim_diagnostic' }, -- Use Neovim's built-in diagnostics
        sections = { 'error', 'warn', 'info', 'hint' },
        diagnostics_color = diagnostics_colors, -- Custom diagnostics colors
        symbols = { error = 'E', warn = 'W', info = 'I', hint = 'H' },
      },
      {
        'filename',
        file_status = true, -- Show modified/readonly status
        path = 1, -- Show relative path
        symbols = { modified = '[+]', readonly = '[-]', unnamed = '[No Name]' },
      },
    },

    -- Right side sections
    lualine_x = {
      { 'filetype', icon_only = false }, -- Show file type with icon
      { 'encoding', show_bomb = true }, -- Show encoding (e.g., utf-8) and BOM if present
    },
    lualine_y = { 'progress' }, -- Show progress (percentage through file)
    lualine_z = { 'location' }, -- Show line:column location
  },
  inactive_sections = {
    -- Configuration for inactive windows
    lualine_a = {},
    lualine_b = {},
    lualine_c = { 'filename' },
    lualine_x = { 'location' },
    lualine_y = {},
    lualine_z = {},
  },
  tabline = {}, -- Not using tabline for now
  winbar = {}, -- Not using winbar for now
  inactive_winbar = {},
  extensions = { 'telescope', 'toggleterm', 'quickfix' }, -- Enable extensions for your plugins
}
