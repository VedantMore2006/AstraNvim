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

     -- Theme toggle
     map("n", "<Leader>tt", function()
       local styles = { "night", "storm", "moon", "day" }
       local current = vim.g.tokyonight_style or "night"
       local next_idx = (vim.fn.index(styles, current) + 1) % #styles + 1
       vim.g.tokyonight_style = styles[next_idx]
       require("tokyonight").setup({
         style = styles[next_idx],
         transparent = vim.g.transparent_enabled,
         styles = {
           sidebars = "transparent",
           floats = "transparent",
         },
         on_highlights = function(hl, c)
           hl.Normal = { bg = "NONE", fg = c.fg }
           hl.NormalFloat = { bg = "NONE", fg = c.fg }
           hl.LineNr = { bg = "NONE", fg = c.fg_gutter }
           hl.SignColumn = { bg = "NONE" }
           hl.FloatBorder = { bg = "NONE", fg = c.blue }
           hl.TelescopeNormal = { bg = "NONE", fg = c.fg }
           hl.LualineNormal = { bg = "NONE", fg = c.fg }
         end,
       })
       vim.cmd("colorscheme tokyonight")
     end, opts) -- Toggle TokyoNight theme variant