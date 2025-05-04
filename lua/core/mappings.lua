-- ~/.config/nvim/lua/core/mappings.lua
-- Keybindings for Neovim IDE

local map = vim.keymap.set
local opts = { noremap = true, silent = true }

-- Preserve requested keybindings
map("n", "<Leader>s", ":w<CR>", opts) -- Save
map("n", "<Leader>q", ":q<CR>", opts) -- Quit

-- Navigation
map("n", "<C-h>", "<C-w>h", opts) -- Move to left window
map("n", "<C-j>", "<C-w>j", opts) -- Move to bottom window
map("n", "<C-k>", "<C-w>k", opts) -- Move to top window
map("n", "<C-l>", "<C-w>l", opts) -- Move to right window

-- File explorer
map("n", "<Leader>e", ":NvimTreeToggle<CR>", opts) -- Toggle file explorer

-- Telescope
map("n", "<Leader>ff", "<cmd>Telescope find_files<CR>", opts) -- Find files
map("n", "<Leader>fg", "<cmd>Telescope live_grep<CR>", opts) -- Live grep
map("n", "<Leader>fb", "<cmd>Telescope buffers<CR>", opts) -- Buffers
map("n", "<Leader>fh", "<cmd>Telescope help_tags<CR>", opts) -- Help tags

-- LSP
map("n", "gd", vim.lsp.buf.definition, opts) -- Go to definition
map("n", "K", vim.lsp.buf.hover, opts) -- Hover documentation
map("n", "<Leader>ca", vim.lsp.buf.code_action, opts) -- Code action
map("n", "<Leader>rn", vim.lsp.buf.rename, opts) -- Rename

-- Debugging
map("n", "<F5>", "<cmd>DapContinue<CR>", opts) -- Start/Continue debugging
map("n", "<F10>", "<cmd>DapStepOver<CR>", opts) -- Step over
map("n", "<F11>", "<cmd>DapStepInto<CR>", opts) -- Step into
map("n", "<F12>", "<cmd>DapStepOut<CR>", opts) -- Step out
map("n", "<Leader>b", "<cmd>DapToggleBreakpoint<CR>", opts) -- Toggle breakpoint

-- Terminal
map("n", "<C-\\>", "<cmd>ToggleTerm<CR>", opts) -- Toggle terminal