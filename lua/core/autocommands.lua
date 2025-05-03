-- ~/.config/nvim/lua/core/autocommands.lua
-- Autocommands for enhancing the Neovim experience

local augroup = vim.api.nvim_create_augroup("AstraVim", { clear = true })

-- Highlight yanked text for better feedback
vim.api.nvim_create_autocmd("TextYankPost", {
  group = augroup,
  callback = function()
    vim.highlight.on_yank({ timeout = 150 })
  end,
  desc = "Highlight yanked text",
})

-- Auto-format on save using LSP (except in Beginner mode)
vim.api.nvim_create_autocmd("BufWritePre", {
  group = augroup,
  callback = function()
    if vim.g.astra_mode ~= "beginner" then
      vim.lsp.buf.format({ async = false })
    end
  end,
  desc = "Auto-format on save (Advanced/Pro)",
})

-- Adjust indentation for specific filetypes
vim.api.nvim_create_autocmd("FileType", {
  group = augroup,
  pattern = { "python", "javascript", "typescript" },
  callback = function()
    vim.bo.tabstop = 4
    vim.bo.shiftwidth = 4
  end,
  desc = "Adjust indentation for specific filetypes",
})

-- Clean up alpha timer on exit
vim.api.nvim_create_autocmd("VimLeave", {
  group = augroup,
  callback = function()
    if vim.g.alpha_timer then
      vim.g.alpha_timer:stop()
    end
  end,
  desc = "Clean up alpha timer on exit",
})

-- Fade-in effect on startup (Pro mode only)
if vim.g.astra_mode == "pro" then
  vim.api.nvim_create_autocmd("VimEnter", {
    group = augroup,
    callback = function()
      vim.cmd("hi Normal guibg=NONE ctermbg=NONE")
      for i = 0, 10 do
        vim.defer_fn(function()
          vim.api.nvim_set_hl(0, "Normal", { bg = "NONE", blend = i * 10 })
        end, i * 50)
      end
    end,
    desc = "Fade-in effect on startup (Pro)",
  })
end