-- ~/.config/nvim/lua/core/options.lua
-- Core Neovim settings for performance and usability

-- Enable true color support for better themes
vim.opt.termguicolors = true

-- Display line numbers
vim.opt.number = true
vim.opt.relativenumber = vim.g.astra_mode ~= "beginner" -- Relative numbers off in Beginner mode

-- Highlight the current line number
vim.opt.cursorline = true
vim.opt.cursorlineopt = "number"

-- Smoother navigation with scroll offset
vim.opt.scrolloff = 12

-- Always show signcolumn for diagnostics and git signs
vim.opt.signcolumn = "yes:1"

-- Enable mouse support in all modes
vim.opt.mouse = "a"

-- Use system clipboard for yanking and pasting
vim.opt.clipboard = "unnamedplus"

-- Persistent undo across sessions
vim.opt.undofile = true
vim.opt.undodir = vim.fn.stdpath("cache") .. "/undo"

-- Enable smooth scrolling for a better visual experience
vim.opt.smoothscroll = true

-- Faster updates for responsive UI
vim.opt.updatetime = 250
vim.opt.timeoutlen = 400

-- Performance optimizations
vim.opt.lazyredraw = true  -- Reduce redraws during macros
vim.opt.redrawtime = 1500  -- Optimize for large files
vim.opt.shortmess:append("sIc") -- Reduce unnecessary messages

-- Cursor settings: Blink once every 2 seconds
vim.opt.guicursor = {
  "n-v-c:block-Cursor/lCursor-blinkwait2000-blinkon200-blinkoff200",
  "i-ci-ve:ver25-Cursor/lCursor-blinkwait2000-blinkon200-blinkoff200",
  "r-cr-o:hor20-Cursor/lCursor-blinkwait2000-blinkon200-blinkoff200",
}

-- Editing settings for clean code
vim.opt.tabstop = 2        -- 2 spaces for tabs
vim.opt.shiftwidth = 2     -- 2 spaces for indent
vim.opt.expandtab = true   -- Convert tabs to spaces
vim.opt.smartindent = true -- Smart auto-indenting
vim.opt.wrap = false       -- Disable line wrapping
vim.opt.list = vim.g.astra_mode ~= "beginner" -- Show invisible characters (off in Beginner)
vim.opt.listchars = {
  tab = "→ ",
  trail = "·",
  nbsp = "␣",
  eol = "↲",
}
vim.opt.breakindent = true        -- Indent wrapped lines
vim.opt.formatoptions:remove("r") -- Disable auto-comment on Enter
vim.opt.fillchars = { eob = " " } -- Remove ~ for empty lines

-- Search settings for efficiency
vim.opt.ignorecase = true        -- Case-insensitive search
vim.opt.smartcase = true         -- Case-sensitive with uppercase
vim.opt.inccommand = "split"     -- Live preview for substitutions
vim.opt.grepprg = "rg --vimgrep" -- Use ripgrep for faster grep
vim.opt.grepformat = "%f:%l:%c:%m" -- Ripgrep format

-- Window settings for seamless workflow
vim.opt.splitbelow = true        -- New splits below
vim.opt.splitright = true        -- New splits to the right
vim.opt.completeopt = { "menuone", "noselect" } -- Better completion
vim.opt.pumheight = 10           -- Limit completion menu height

-- Leader keys for custom mappings
vim.g.mapleader = " "
vim.g.maplocalleader = ","

-- Create necessary directories for caching
local dirs = {
  vim.fn.stdpath("cache") .. "/undo",
  vim.fn.stdpath("cache") .. "/backup",
  vim.fn.stdpath("cache") .. "/session",
  vim.fn.stdpath("cache") .. "/logs",
}
for _, dir in ipairs(dirs) do
  if not vim.fn.isdirectory(dir) then
    vim.fn.mkdir(dir, "p")
  end
end