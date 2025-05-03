-- Define conditions for dynamic display
local conditions = {
  buffer_not_empty = function()
    return vim.fn.empty(vim.fn.expand('%:t')) == 0
  end,
  hide_in_width = function()
    return vim.fn.winwidth(0) > 80
  end,
  check_git_workspace = function()
    local filepath = vim.fn.expand('%:p:h')
    local gitdir = vim.fn.finddir('.git', filepath .. ';')
    return gitdir ~= '' and gitdir ~= nil
  end,
  is_pro_mode = function()
    return vim.g.astra_mode == "pro"
  end,
}

-- Custom components
local function astra_mode()
  local mode = vim.g.astra_mode or "advanced"
  local icons = {
    beginner = "󰣐",
    advanced = "󰚩",
    pro = "󱃖",
  }
  return icons[mode] .. " " .. vim.fn.substitute(mode, "^%l", string.upper, '')
end

local function ml_training_status()
  if vim.fn.filereadable("/tmp/plate_training.log") == 1 then
    return "🧠 Training"
  end
  return ""
end

local function lsp_client_name()
  local msg = "No Active Lsp"
  local buf_ft = vim.api.nvim_buf_get_option(0, "filetype")
  local clients = vim.lsp.get_active_clients()
  if next(clients) == nil then
    return msg
  end
  for _, client in ipairs(clients) do
    local filetypes = client.config.filetypes
    if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
      return client.name
    end
  end
  return msg
end

local function open_buffers()
  return "Buffers: " .. #vim.fn.getbufinfo({ buflisted = 1 })
end

-- Lualine setup
require('lualine').setup {
  options = {
    theme = 'auto', -- Follows the current colorscheme
    component_separators = { left = '', right = ''},
    section_separators = { left = '', right = ''},
    disabled_filetypes = { "alpha", "dashboard", "starter" },
    always_divide_middle = true,
    globalstatus = true,
    refresh = {
      statusline = 500,
      tabline = 1000,
      winbar = 1000,
    },
  },
  sections = {
    lualine_a = {'mode'},
    lualine_b = {'branch', 'diff', 'diagnostics'},
    lualine_c = {
      {
        'filename',
        file_status = true, -- Displays file status (readonly, modified)
        path = 1 -- Relative path
      },
      {
        'filetype',
        icon_only = true, -- Only show filetype icon
        colored = true, -- Color the icon
      },
      { astra_mode, condition = conditions.hide_in_width },
      { ml_training_status, condition = function() return conditions.hide_in_width() and conditions.is_pro_mode() end },
    },
    lualine_x = {'encoding', 'fileformat', 'filetype', lsp_client_name},
    lualine_y = {'progress', open_buffers},
    lualine_z = {'location'}
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {'filename'},
    lualine_x = {'location'},
    lualine_y = {},
    lualine_z = {}
  },
  extensions = {'nvim-tree', 'toggleterm', 'quickfix', 'fugitive'}
}

-- Bufferline setup
require("bufferline").setup {
  options = {
    mode = "buffers",
    numbers = "none",
    close_command = "bdelete! %d",
    right_mouse_command = "bdelete! %d",
    left_mouse_command = "buffer %d",
    middle_mouse_command = nil,
    indicator = {
      icon = '▎',
      style = 'icon'
    },
    buffer_close_icon = '',
    modified_icon = '●',
    close_icon = '',
    left_trunc_marker = '',
    right_trunc_marker = '',
    max_name_length = 18,
    max_prefix_length = 15,
    tab_size = 18,
    diagnostics = "nvim_lsp",
    diagnostics_update_in_insert = false,
    offsets = {
      {
        filetype = "NvimTree",
        text = "File Explorer",
        text_align = "left",
        separator = true
      }
    },
    show_buffer_icons = true,
    show_buffer_close_icons = true,
    show_close_icon = true,
    show_tab_indicators = true,
    persist_buffer_sort = true,
    separator_style = "thin",
    enforce_regular_tabs = false,
    always_show_bufferline = true,
  },
}