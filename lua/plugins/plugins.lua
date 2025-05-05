-- ~/.config/nvim/lua/plugins/plugins.lua
-- Plugin setup using lazy.nvim

local plugins = {
  -- Theming: TokyoNight with transparency
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    config = function()
    require("tokyonight").setup({
      style = "night",
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
    end,
  },

  -- Plugin manager: lazy.nvim
  { "folke/lazy.nvim" },

  -- File icons
  { "nvim-tree/nvim-web-devicons", opts = { default = true } },

  -- Statusline
  {
    "nvim-lualine/lualine.nvim",
    event = "UIEnter",
    config = function()
    require("plugins.lualine")
    end,
  },

  -- Dashboard
  {
    "goolord/alpha-nvim",
    event = "VimEnter",
    config = function()
    require("plugins.alpha")
    end,
  },

  -- File explorer
  {
    "nvim-tree/nvim-tree.lua",
    cmd = { "NvimTreeToggle", "NvimTreeFocus" },
    config = function()
    require("nvim-tree").setup({
      view = { width = 30, side = "left" },
      renderer = { indent_markers = { enable = true } },
      filters = { dotfiles = false },
    })
    end,
  },

  -- Syntax highlighting
  {
    "nvim-treesitter/nvim-treesitter",
    event = { "BufReadPost", "BufNewFile" },
    build = ":TSUpdate",
    config = function()
    require("nvim-treesitter.configs").setup({
      ensure_installed = {
        "lua",
        "python",
        "javascript",
        "typescript",
        "html",
        "css",
        "json",
        "yaml",
        "markdown",
      },
      highlight = { enable = true },
      indent = { enable = true },
    })
    end,
  },

  -- Autocompletion
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
    },
    config = function()
    require("plugins.cmp")
    end,
  },

  -- LSP
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
    },
    config = function()
    require("plugins.lsp")
    end,
  },

  -- Fuzzy finder
  {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    dependencies = {
      "nvim-lua/plenary.nvim",
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    },
    config = function()
    require("plugins.telescope")
    end,
  },

  -- Debugging
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "rcarriga/nvim-dap-ui",
      "mfussenegger/nvim-dap-python",
      "nvim-neotest/nvim-nio", -- Added dependency for nvim-dap-ui
    },
    config = function()
    local dap = require("dap")
    local dapui = require("dapui")
    dapui.setup()
    require("dap-python").setup("python3")
    dap.listeners.after.event_initialized["dapui_config"] = function()
    dapui.open()
    end
    dap.listeners.before.event_terminated["dapui_config"] = function()
    dapui.close()
    end
    end,
  },

  -- Terminal
  {
    "akinsho/toggleterm.nvim",
    cmd = { "ToggleTerm" },
    config = function()
    require("toggleterm").setup({
      size = 20,
      open_mapping = [[<C-\>]],
      direction = "float",
      float_opts = { border = "curved" },
    })
    end,
  },

  { "nvim-lua/lsp-status.nvim" },

  -- Git integration
  {
    "lewis6991/gitsigns.nvim",
    event = "BufReadPre",
    opts = {
      signs = {
        add = { text = "┃" },
        change = { text = "┃" },
        delete = { text = "󰍵" },
      },
    },
  },

  -- Auto-pairs
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = function()
    require("nvim-autopairs").setup()
    require("cmp").event:on("confirm_done", require("nvim-autopairs.completion.cmp").on_confirm_done())
    end,
  },

  -- Which-key
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    config = function()
    require("which-key").setup({
      window = { border = "rounded" },
      disable = { filetypes = { "TelescopePrompt" } }, -- Suppress health check warnings
    })
    end,
  },
}

require("lazy").setup(plugins, {
  performance = {
    rtp = {
      disabled_plugins = { "netrw", "tohtml", "tutor" },
    },
  },
})
