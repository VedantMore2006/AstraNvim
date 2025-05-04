-- ~/.config/nvim/lua/core/options.lua
-- Global Neovim options

local opt = vim.opt

-- Appearance
opt.termguicolors = true
opt.background = "dark"
opt.signcolumn = "yes"
opt.cursorline = true
opt.number = true
opt.relativenumber = true
opt.showmode = false
opt.list = true
opt.listchars = { tab = "» ", trail = "·", eol = "¬" }

-- Behavior
opt.mouse = "a"
opt.clipboard = "unnamedplus"
opt.undofile = true
opt.ignorecase = true
opt.smartcase = true
opt.timeoutlen = 300
opt.updatetime = 250

-- Indentation
opt.expandtab = true
opt.shiftwidth = 2
opt.tabstop = 2
opt.softtabstop = 2
opt.smartindent = true

-- Window management
opt.splitbelow = true
opt.splitright = true

-- Transparency (will be enhanced by tokyonight)
vim.g.transparent_enabled = true