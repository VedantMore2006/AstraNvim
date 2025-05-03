-- Ultimate Lualine and Bufferline configuration with file type icon near filename and file paths in bufferline

-- Conditions for dynamic display
local conditions = {
  buffer_not_empty = function()
    return vim.fn.empty(vim.fn.expand("%:t")) ~= 1
  end,
  hide_in_width = function()
    return vim.fn.winwidth(0) > 80
  end,
  is_pro_mode = function()
    return vim.g.astra_mode == "pro"
  end,
  check_git_workspace = function()
    return vim.fn.isdirectory(".git") == 1
  end,
}

-- Custom Astra Mode Indicator
local function astra_mode()
  local mode = vim.g.astra_mode or "advanced"
  local icons = { beginner = "󰣐", advanced = "󰚩", pro = "󱃖" }
  return icons[mode] .. " " .. mode:sub(1, 1):upper() .. mode:sub(2)
end

-- Custom ML Training Status Indicator
local function ml_training_status()
  local training = vim.fn.filereadable("/tmp/plate_training.log") == 1
  return training and "🧠 Training" or ""
end

-- Theme configuration for Tokyo Night
local theme = {
  normal = {
    a = { bg = "#7aa2f7", fg = "#1a1b26", gui = "bold" },
    b = { bg = "#3b4261", fg = "#c0caf5" },
    c = { bg = "#1a1b26", fg = "#a9b1d6" },
  },
  insert = { a = { bg = "#9ece6a", fg = "#1a1b26", gui = "bold" } },
  visual = { a = { bg = "#bb9af7", fg = "#1a1b26", gui = "bold" } },
  replace = { a = { bg = "#f7768e", fg = "#1a1b26", gui = "bold" } },
  command = { a = { bg = "#e0af68", fg = "#1a1b26", gui = "bold" } },
  inactive = {
    a = { bg = "#1a1b26", fg = "#3b4261" },
    b = { bg = "#1a1b26", fg = "#3b4261" },
    c = { bg = "#1a1b26", fg = "#3b4261" },
  },
}

-- Lualine Configuration
require("lualine").setup({
  options = {
    theme = theme,
    component_separators = { left = "", right = "" },
    section_separators = { left = "", right = "" },
    disabled_filetypes = {
      statusline = { "alpha", "dashboard", "starter" },
      winbar = { "ipynb" },
    },
    globalstatus = true,
    always_divide_middle = true,
    refresh = {
      statusline = 500,
      tabline = 1000,
      winbar = 1000,
    },
  },
  sections = {
    lualine_a = {
      { "mode", fmt = function(str) return str end, icon = " " }, -- Full mode name (e.g., "NORMAL")
    },
    lualine_b = {
      { "branch", icon = "" },
      {
        "diff",
        symbols = { added = " ", modified = "柳", removed = " " },
        cond = conditions.hide_in_width,
      },
    },
    lualine_c = {
      -- File Type Icon next to Filename
      {
        "filetype",
        icon_only = true,
        colored = true,
        padding = { left = 1, right = 0 },
      },
      {
        "filename",
        path = 1,
        cond = conditions.buffer_not_empty,
        symbols = {
          modified = "●",
          readonly = "🔒",
          unnamed = "[No Name]",
        },
        padding = { left = 0, right = 1 },
      },
      { astra_mode, icon = "󰌌" },
      {
        ml_training_status,
        cond = function() return conditions.is_pro_mode() and conditions.hide_in_width() end,
      },
    },
    lualine_x = {
      {
        "diagnostics",
        sources = { "nvim_diagnostic" },
        symbols = { error = " ", warn = " ", info = " ", hint = "󰌵 " },
        colored = true,
        always_visible = true,
      },
      { "encoding", cond = conditions.hide_in_width },
    },
    lualine_y = {
      { "progress", fmt = function() return "%P/%L" end },
    },
    lualine_z = {
      { "location", icon = "" },
    },
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {
      { "filename", path = 1, cond = conditions.buffer_not_empty },
    },
    lualine_x = { "location" },
    lualine_y = {},
    lualine_z = {},
  },
  extensions = { "nvim-tree", "toggleterm", "quickfix", "fugitive" },
})

-- Bufferline Configuration with File Path
require("bufferline").setup({
  options = {
    numbers = "none",
    close_command = "bdelete! %d",
    right_mouse_command = nil,
    left_mouse_command = "buffer %d",
    middle_mouse_command = nil,
    indicator = {
      icon = "▎",
      style = "icon",
    },
    buffer_close_icon = "",
    modified_icon = "●",
    close_icon = "",
    left_trunc_marker = "",
    right_trunc_marker = "",
    max_name_length = 30,
    max_prefix_length = 15,
    enforce_regular_tabs = false,
    show_buffer_icons = true,
    show_buffer_close_icons = true,
    show_close_icon = false,
    separator_style = "slant",
    offsets = {
      { filetype = "NvimTree", text = "File Explorer", text_align = "center" },
    },
    custom_filter = function(buf_number)
      -- Filter out special buffers if needed
      return true
    end,
    diagnostics = "nvim_lsp",
    diagnostics_indicator = function(count, level, diagnostics_dict, context)
      local icon = level:match("error") and " " or " "
      return " " .. icon .. count
    end,
    -- Show full file paths in bufferline
    name_formatter = function(buf)
      local name = vim.fn.fnamemodify(buf.name, ":~:.")
      return name
    end,
  },
})