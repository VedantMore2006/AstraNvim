-- ~/.config/nvim/lua/plugins/lualine.lua
-- Lualine configuration for statusline and tabline

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
}

-- Custom component for AstraVim mode
local function astra_mode()
  local mode = vim.g.astra_mode or "advanced"
  local icons = { beginner = "󰣐", advanced = "󰚩", pro = "󱃖" }
  return icons[mode] .. " " .. mode:sub(1, 1):upper() .. mode:sub(2)
end

-- Custom component for ML training status (placeholder)
local function ml_training_status()
  local training = vim.fn.filereadable("/tmp/plate_training.log") == 1
  return training and "🧠 Training" or ""
end

require("lualine").setup({
  options = {
    theme = "tokyonight", -- Use tokyonight theme
    component_separators = { left = "│", right = "│" },
    section_separators = { left = "", right = "" },
    disabled_filetypes = {
      statusline = { "alpha", "dashboard", "starter" },
      winbar = { "ipynb" },
    },
    ignore_focus = { "NvimTree" },
    always_divide_middle = true,
    globalstatus = true,
    refresh = {
      statusline = 500,
      tabline = 1000,
      winbar = 1000,
    },
  },
  sections = {
    lualine_a = {
      {
        "mode",
        fmt = function(str) return str end, -- Display full mode name (e.g., "NORMAL")
        icon = { "󰌌" },
        padding = { left = 1, right = 1 },
      },
    },
    lualine_b = {
      {
        "branch",
        icon = { "" },
        padding = { left = 1, right = 1 },
      },
      {
        "diff",
        symbols = { added = " ", modified = "󰝤 ", removed = "󰍵 " },
        cond = conditions.hide_in_width,
      },
    },
    lualine_c = {
      {
        "filetype",
        colored = true,
        icon_only = true,
        padding = { left = 1, right = 0 }, -- No padding on right to keep close to filename
        cond = conditions.hide_in_width,
      },
      {
        "filename",
        cond = conditions.buffer_not_empty,
        file_status = true,
        newfile_status = true,
        path = 1,
        symbols = {
          modified = "●",
          readonly = "🔒",
          unnamed = "[No Name]",
          newfile = "[New]",
        },
        padding = { left = 0, right = 1 }, -- No padding on left to keep close to filetype
      },
      {
        ml_training_status,
        cond = function() return conditions.is_pro_mode() and conditions.hide_in_width() end,
      },
    },
    lualine_x = {
      {
        "diagnostics",
        sources = { "nvim_lsp" },
        sections = { "error", "warn", "info", "hint" },
        symbols = { error = " ", warn = " ", info = " ", hint = "󰌵 " },
        colored = true,
        update_in_insert = false,
        always_visible = false,
        cond = conditions.hide_in_width,
      },
      {
        "lsp_status",
        icon = "",
        symbols = { spinner = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }, done = "✓" },
        cond = conditions.is_pro_mode,
      },
      {
        "location",
        padding = { left = 1, right = 1 },
      },
    },
    lualine_y = {
      {
        "encoding",
        show_bomb = true,
        cond = conditions.hide_in_width,
      },
      {
        "fileformat",
        symbols = { unix = "", dos = "", mac = "" },
        cond = conditions.hide_in_width,
      },
    },
    lualine_z = {
      {
        "progress",
        fmt = function() return "%P/%L" end,
        padding = { left = 1, right = 1 },
      },
      {
        astra_mode,
        padding = { left = 1, right = 1 },
      },
    },
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {
      {
        "filename",
        file_status = true,
        path = 1,
        symbols = { modified = "●", readonly = "🔒", unnamed = "[No Name]" },
      },
    },
    lualine_x = { "location" },
    lualine_y = {},
    lualine_z = {},
  },
  tabline = {
    lualine_a = {
      {
        "buffers",
        show_filename_only = true,
        hide_filename_extension = false,
        show_modified_status = true,
        mode = 2, -- Show buffer name and number
        max_length = vim.o.columns * 2 / 3,
        symbols = { modified = " ●", alternate_file = "#", directory = "" },
        padding = { left = 1, right = 1 },
        separator = { left = "", right = "" },
      },
    },
    lualine_z = {
      {
        "tabs",
        padding = { left = 1, right = 1 },
        separator = { left = "", right = "" },
      },
    },
  },
  winbar = {
    lualine_c = {
      {
        "filename",
        file_status = true,
        path = 3,
        symbols = { modified = "●", readonly = "🔒", unnamed = "[No Name]" },
      },
    },
  },
  inactive_winbar = {
    lualine_c = {
      {
        "filename",
        file_status = true,
        path = 3,
        symbols = { modified = "●", readonly = "🔒", unnamed = "[No Name]" },
      },
    },
  },
  extensions = { "nvim-tree", "toggleterm", "quickfix", "fugitive", "magma-nvim" },
})