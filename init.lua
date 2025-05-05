-- ~/.config/nvim/init.lua
-- Main entry point for Neovim IDE setup

-- Initialize global settings
vim.g.mapleader = " "
vim.g.maplocalleader = ","

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
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
  require("core.options")
  require("core.autocommands")
  require("core.mappings")

  -- Load plugins
  require("plugins.plugins")
