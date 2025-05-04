-- ~/.config/nvim/lua/core/autocommands.lua
-- Autocommands for Neovim IDE

local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- Highlight yanked text
local yank_group = augroup("HighlightYank", {})
autocmd("TextYankPost", {
  group = yank_group,
  callback = function()
    vim.highlight.on_yank { higroup = "IncSearch", timeout = 150 }
  end,
})

-- Auto-format on save
local format_group = augroup("AutoFormat", {})
autocmd("BufWritePre", {
  group = format_group,
  callback = function()
    vim.lsp.buf.format { async = false }
  end,
})

-- Restore cursor position
local cursor_group = augroup("RestoreCursor", {})
autocmd("BufReadPost", {
  group = cursor_group,
  callback = function()
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    if mark[1] > 1 and mark[1] <= vim.api.nvim_buf_line_count(0) then
      vim.api.nvim_win_set_cursor(0, mark)
    end
  end,
})