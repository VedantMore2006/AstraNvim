-- ~/.config/nvim/init.lua
-- AstraVim v2.4: Ultimate Neovim Configuration
-- Created by Grok, Optimized for Performance and AI-Driven Development
-- Updated: May 3, 2025

-- Define AstraVim mode (Beginner, Advanced, Pro)
local astra_mode = vim.g.astra_mode or "advanced" -- Default to Advanced
vim.g.astra_mode = astra_mode

-- Bootstrap lazy.nvim (Plugin Manager)
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Load core configurations
require("core.options")      -- General Neovim settings
require("core.autocommands") -- Autocommands for enhanced experience
require("core.mappings")     -- Keybindings
require("core.utils")        -- Utility functions
require("plugins")           -- Plugin setup with lazy.nvim