-- ~/.config/nvim/lua/plugins/init.lua
-- Plugin setup using lazy.nvim

local plugins = {
  -- Theming: TokyoNight
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      local ok, tokyonight = pcall(require, "tokyonight")
      if not ok then
        _G.log_error("Failed to load tokyonight.nvim: " .. tostring(tokyonight))
        return
      end
      tokyonight.setup({
        style = vim.g.astra_mode == "beginner" and "day"
          or vim.g.astra_mode == "advanced" and "storm"
          or "night",
        transparent = false,
        styles = {
          comments = { italic = true },
          keywords = { bold = true },
          functions = { italic = vim.g.astra_mode ~= "beginner" },
        },
        on_highlights = function(hl, c)
          hl.Normal = { bg = c.bg, fg = c.fg }
          hl.NormalFloat = { bg = c.bg_dark, fg = c.fg }
          hl.LineNr = { bg = c.bg, fg = c.fg_gutter }
          hl.SignColumn = { bg = c.bg }
          hl.BufferLineBackground = { bg = c.bg_dark, fg = c.fg_gutter }
          hl.BufferLineBufferSelected = { bg = c.bg_highlight, fg = c.fg, bold = true }
          hl.TelescopeNormal = { bg = c.bg_dark, fg = c.fg }
          hl.TelescopeBorder = { bg = c.bg_dark, fg = c.border_highlight }
          hl.FloatBorder = { bg = c.bg_dark, fg = c.blue }
          hl.LualineNormal = { bg = c.bg_dark, fg = c.fg }
        end,
      })
      vim.cmd("colorscheme tokyonight")
    end,
  },

  -- Web Devicons for file icons
  {
    "nvim-tree/nvim-web-devicons",
    opts = { default = true },
  },

  -- Statusline: Lualine (configured in plugins/lualine.lua)
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    config = function()
      require("plugins.lualine")
    end,
  },

  -- Dashboard: Alpha-nvim
  {
    "goolord/alpha-nvim",
    event = "VimEnter",
    dependencies = { "nvim-lua/plenary.nvim" },
    enabled = vim.g.astra_mode ~= "beginner",
    config = function()
      local ok, alpha = pcall(require, "alpha")
      if not ok then
        _G.log_error("Failed to load alpha-nvim: " .. tostring(alpha))
        return
      end
      local dashboard = require("alpha.themes.dashboard")
      local colors = require("tokyonight.colors").setup()
      local logo = {
        "      🚀    A S T R A V I M    🚀      ",
        "   █████╗ ███████╗████████╗██████╗     ",
        "  ██╔══██╗██╔════╝╚══██╔══╝██╔══██╗    ",
        "  ███████║███████╗   ██║   ██████╔╝    ",
        "  ██╔══██║╚════██║   ██║   ██╔═══╝     ",
        "  ██║  ██║███████║   ██║   ██║         ",
        "  ╚═╝  ╚═╝╚══════╝   ╚═╝   ╚═╝         ",
        "  AI-Powered Coding at Light Speed!    ",
      }
      dashboard.section.header.val = logo
      dashboard.section.header.opts.hl = { { "AstraVimLogo", 0, -1 } }
      vim.api.nvim_set_hl(0, "AstraVimLogo", { fg = colors.blue })
      local buttons = {
        { key = "e", icon = "📜", desc = "New File", action = ":ene <BAR> startinsert <CR>" },
        { key = "f", icon = "🔍", desc = "Find File", action = ":Telescope find_files<CR>" },
        { key = "r", icon = "🕰", desc = "Recent Files", action = ":Telescope oldfiles<CR>" },
        { key = "g", icon = "🔗", desc = "Git Status", action = ":Gitsigns diffthis<CR>" },
        { key = "j", icon = "📓", desc = "Jupyter Notebook", action = ":JupyterRunFile<CR>", mode = "pro" },
        { key = "p", icon = "📂", desc = "Project Browser", action = ":Telescope file_browser<CR>" },
        { key = "t", icon = "🧪", desc = "Run Tests", action = ":Neotest run<CR>", mode = "pro" },
        { key = "s", icon = "⚙️", desc = "Settings", action = ":AstraVimConfig<CR>" },
        { key = "q", icon = "🚪", desc = "Quit", action = ":qa<CR>" },
      }
      dashboard.section.buttons.val = {}
      for _, btn in ipairs(buttons) do
        if not btn.mode or btn.mode == vim.g.astra_mode then
          table.insert(dashboard.section.buttons.val, dashboard.button(btn.key, btn.icon .. "  " .. btn.desc, btn.action))
        end
      end
      local stats = _G.get_system_stats()
      local startup_time = vim.fn.reltimefloat(vim.fn.reltime()) * 1000
      dashboard.section.footer.val = {
        "🌌 AstraVim v2.4 - Powered by xAI",
        "💻 Active Project: " .. vim.fn.getcwd(),
        "🖥  CPU: " .. stats.cpu .. " | Mem: " .. stats.mem,
        "⚡ Startup: " .. string.format("%.2fms", startup_time),
        "🛠  Mode: " .. vim.g.astra_mode:gsub("^%l", string.upper),
      }
      alpha.setup(dashboard.opts)
    end,
  },

  -- File Explorer: Nvim-tree
  {
    "nvim-tree/nvim-tree.lua",
    cmd = { "NvimTreeToggle", "NvimTreeFocus" },
    dependencies = { "nvim-tree/nvim-web-devicons" },
    enabled = vim.g.astra_mode ~= "beginner",
    opts = {
      filters = { dotfiles = false },
      disable_netrw = true,
      hijack_cursor = true,
      sync_root_with_cwd = true,
      update_focused_file = {
        enable = true,
        update_root = false,
      },
      view = {
        width = 30,
        preserve_window_proportions = true,
      },
      renderer = {
        root_folder_label = false,
        highlight_git = true,
        indent_markers = { enable = true },
        icons = {
          glyphs = {
            default = "󰈚",
            folder = {
              default = "",
              empty = "",
              empty_open = "",
              open = "",
              symlink = "",
            },
            git = { unmerged = "", unstaged = "✗", staged = "✓", untracked = "★", renamed = "➜", deleted = "🗑" },
          },
        },
      },
    },
  },

  -- Syntax Highlighting: Treesitter with Rainbow Braces
  {
    "nvim-treesitter/nvim-treesitter",
    event = { "BufReadPost", "BufNewFile" },
    cmd = { "TSInstall", "TSBufEnable", "TSBufDisable", "TSModuleInfo" },
    build = ":TSUpdate",
    dependencies = {
      "nvim-treesitter/nvim-treesitter-textobjects",
      "p00f/nvim-ts-rainbow",
      "JoosepAlviste/nvim-ts-context-commentstring",
    },
    enabled = vim.g.astra_mode ~= "beginner",
    config = function()
      -- Skip the deprecated context_commentstring module to speed up loading
      vim.g.skip_ts_context_commentstring_module = true

      -- Setup ts_context_commentstring standalone
      local ok_ts_context, ts_context = pcall(require, "ts_context_commentstring")
      if not ok_ts_context then
        _G.log_error("Failed to load ts_context_commentstring: " .. tostring(ts_context))
        return
      end
      ts_context.setup({
        enable_autocmd = false, -- We'll handle this in Comment.nvim
      })

      -- Setup nvim-treesitter
      local ok, treesitter = pcall(require, "nvim-treesitter.configs")
      if not ok then
        _G.log_error("Failed to load nvim-treesitter: " .. tostring(treesitter))
        return
      end
      treesitter.setup({
        ensure_installed = {
          "lua", "luadoc", "printf", "vim", "vimdoc",
          "python", "javascript", "typescript", "c", "cpp",
          "java", "bash", "json", "yaml", "html", "css", "markdown",
          "rust", "go", "dockerfile", "regex", "sql",
        },
        highlight = {
          enable = true,
          use_languagetree = true,
          disable = function(lang, buf)
            local max_filesize = 100 * 1024 -- 100 KB
            local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
            return ok and stats and stats.size > max_filesize
          end,
        },
        indent = { enable = true },
        incremental_selection = {
          enable = vim.g.astra_mode == "pro",
          keymaps = {
            init_selection = "<C-Space>",
            node_incremental = "<C-Space>",
            scope_incremental = "<C-s>",
            node_decremental = "<C-Backspace>",
          },
        },
        textobjects = {
          select = {
            enable = vim.g.astra_mode == "pro",
            lookahead = true,
            keymaps = {
              ["af"] = "@function.outer",
              ["if"] = "@function.inner",
              ["ac"] = "@class.outer",
              ["ic"] = "@class.inner",
            },
          },
          move = {
            enable = vim.g.astra_mode == "pro",
            set_jumps = true,
            goto_next_start = {
              ["]m"] = "@function.outer",
              ["]]"] = "@class.outer",
            },
            goto_previous_start = {
              ["[m"] = "@function.outer",
              ["[["] = "@class.outer",
            },
          },
        },
        rainbow = {
          enable = true, -- Enabled for all modes (not just non-Beginner)
          extended_mode = true, -- Highlight all bracket types
          max_file_lines = 2000, -- Limit for performance
          colors = { -- Custom colors for rainbow braces
            "#FF5555", -- Red
            "#55FF55", -- Green
            "#5555FF", -- Blue
            "#FFFF55", -- Yellow
            "#FF55FF", -- Magenta
            "#55FFFF", -- Cyan
          },
          termcolors = { -- Fallback for terminals
            "Red", "Green", "Blue", "Yellow", "Magenta", "Cyan",
          },
        },
      })
    end,
  },

  -- Autocompletion: nvim-cmp
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-nvim-lua",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "saadparwaiz1/cmp_luasnip",
      "L3MON4D3/LuaSnip",
      "zbirenbaum/copilot-cmp",
      "tzachar/cmp-tabnine",
    },
    enabled = vim.g.astra_mode ~= "beginner",
    config = function()
      local ok, cmp = pcall(require, "cmp")
      if not ok then
        _G.log_error("Failed to load nvim-cmp: " .. tostring(cmp))
        return
      end
      local luasnip = require("luasnip")
      cmp.setup({
        completion = { completeopt = "menu,menuone" },
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-p>"] = cmp.mapping.select_prev_item(),
          ["<C-n>"] = cmp.mapping.select_next_item(),
          ["<C-d>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-e>"] = cmp.mapping.close(),
          ["<CR>"] = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Insert, select = true }),
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { "i", "s" }),
        }),
        sources = cmp.config.sources({
          { name = "copilot", priority = 1000, group_index = 1, enabled = vim.g.astra_mode == "pro" },
          { name = "cmp_tabnine", priority = 950, group_index = 1, enabled = vim.g.astra_mode == "pro" },
          { name = "nvim_lsp", priority = 900, group_index = 1 },
          { name = "luasnip", priority = 800, group_index = 2 },
          { name = "buffer", priority = 700, keyword_length = 3, group_index = 3 },
          { name = "nvim_lua", priority = 650, group_index = 3 },
          { name = "path", priority = 600, group_index = 3 },
        }),
        formatting = {
          format = function(entry, vim_item)
            vim_item.menu = ({
              copilot = "[Copilot]",
              cmp_tabnine = "[TabNine]",
              nvim_lsp = "[LSP]",
              luasnip = "[Snippet]",
              buffer = "[Buffer]",
              nvim_lua = "[Lua]",
              path = "[Path]",
            })[entry.source.name]
            return vim_item
          end,
        },
        experimental = {
          ghost_text = vim.g.astra_mode == "pro", -- AI suggestions inline
        },
      })
      cmp.setup.cmdline({ "/", "?" }, {
        mapping = cmp.mapping.preset.cmdline(),
        sources = { { name = "buffer" } },
      })
      cmp.setup.cmdline(":", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
          { name = "path" },
          { name = "cmdline" },
        }),
      })
    end,
  },

  -- AI Integration: Copilot and TabNine
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    enabled = vim.g.astra_mode == "pro",
    config = function()
      local ok, copilot = pcall(require, "copilot")
      if not ok then
        _G.log_error("Failed to load copilot.lua: " .. tostring(copilot))
        return
      end
      copilot.setup({
        suggestion = {
          enabled = true,
          auto_trigger = true,
          debounce = 75,
          keymap = {
            accept = "<M-l>",
            next = "<M-]>",
            prev = "<M-[>",
            dismiss = "<C-]>",
          },
        },
        panel = { enabled = false },
      })
    end,
  },
  {
    "zbirenbaum/copilot-cmp",
    after = "copilot.lua",
    enabled = vim.g.astra_mode == "pro",
    config = function()
      local ok, copilot_cmp = pcall(require, "copilot_cmp")
      if not ok then
        _G.log_error("Failed to load copilot-cmp: " .. tostring(copilot_cmp))
        return
      end
      copilot_cmp.setup()
    end,
  },
  {
    "tzachar/cmp-tabnine",
    build = "./install.sh",
    enabled = vim.g.astra_mode == "pro",
    config = function()
      local ok, tabnine = pcall(require, "cmp_tabnine.config")
      if not ok then
        _G.log_error("Failed to load cmp-tabnine: " .. tostring(tabnine))
        return
      end
      tabnine:setup({
        max_lines = 1000,
        max_num_results = 10,
        sort = true,
      })
    end,
  },

  -- LSP: Configured in plugins/lsp.lua
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "glepnir/lspsaga.nvim",
      "folke/neodev.nvim",
    },
    enabled = vim.g.astra_mode ~= "beginner",
    config = function()
      require("plugins.lsp")
    end,
  },

  -- Jupyter Integration
  {
    "goerz/jupytext.vim",
    event = "BufReadPre *.ipynb",
    enabled = vim.g.astra_mode == "pro",
    config = function()
      vim.g.jupytext_fmt = "py:percent"
      vim.g.jupytext_filetype_map = { ["py:percent"] = "python" }
    end,
  },
  {
    "ahmedkhalf/jupyter-nvim",
    event = "BufReadPre *.ipynb",
    enabled = vim.g.astra_mode == "pro",
    config = function()
      local ok, jupyter = pcall(require, "jupyter-nvim")
      if not ok then
        _G.log_error("Failed to load jupyter-nvim: " .. tostring(jupyter))
        return
      end
      jupyter.setup({
        kernel_timeout = 60,
        auto_attach = true,
      })
    end,
  },
  {
    "dccsillag/magma-nvim",
    event = "BufReadPre *.ipynb",
    build = ":UpdateRemotePlugins",
    enabled = vim.g.astra_mode == "pro",
    config = function()
      vim.g.magma_automatically_open_output = true
      vim.g.magma_image_provider = vim.fn.executable("kitty") == 1 and "kitty" or "none"
    end,
  },

  -- Debugging: DAP
  {
    "mfussenegger/nvim-dap",
    cmd = { "DapToggleBreakpoint", "DapContinue" },
    dependencies = {
      "rcarriga/nvim-dap-ui",
      "theHamsta/nvim-dap-virtual-text",
      "nvim-telescope/telescope-dap.nvim",
      "mfussenegger/nvim-dap-python",
    },
    enabled = vim.g.astra_mode == "pro",
    config = function()
      local ok, dap = pcall(require, "dap")
      if not ok then
        _G.log_error("Failed to load nvim-dap: " .. tostring(dap))
        return
      end
      local ok, dapui = pcall(require, "dapui")
      if not ok then
        _G.log_error("Failed to load nvim-dap-ui: " .. tostring(dapui))
        return
      end
      dapui.setup({
        layouts = {
          {
            elements = {
              { id = "scopes", size = 0.4 },
              { id = "breakpoints", size = 0.2 },
              { id = "stacks", size = 0.2 },
              { id = "watches", size = 0.2 },
            },
            size = 40,
            position = "left",
          },
          {
            elements = { "repl", "console" },
            size = 0.25,
            position = "bottom",
          },
        },
      })
      require("nvim-dap-virtual-text").setup({ commented = true })
      require("dap-python").setup(vim.fn.executable("python3") == 1 and "python3" or nil)
      dap.adapters.node2 = {
        type = "executable",
        command = "node",
        args = { vim.fn.stdpath("data") .. "/mason/packages/js-debug-adapter/js-debug-adapter" },
      }
      dap.configurations.javascript = {
        {
          type = "node2",
          request = "launch",
          name = "Launch file",
          program = "${file}",
          cwd = vim.fn.getcwd(),
        },
      }
      dap.configurations.typescript = dap.configurations.javascript
      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
      end
    end,
  },

  -- Testing: Neotest
  {
    "nvim-neotest/neotest",
    event = "VeryLazy",
    dependencies = {
      "nvim-neotest/neotest-python",
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    enabled = vim.g.astra_mode == "pro",
    config = function()
      local ok, neotest = pcall(require, "neotest")
      if not ok then
        _G.log_error("Failed to load neotest: " .. tostring(neotest))
        return
      end
      neotest.setup({
        adapters = {
          require("neotest-python")({
            dap = { justMyCode = false },
            runner = "pytest",
            python = vim.fn.executable("python3") == 1 and "python3" or nil,
          }),
        },
        output = { open_on_run = true },
        quickfix = { open = false },
      })
    end,
  },

  -- Telescope: Fuzzy Finder
  {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    dependencies = {
      "nvim-lua/plenary.nvim",
      { "nvim-telescope/telescope-fzf-native.nvim", build = vim.fn.executable("make") == 1 and "make" or nil },
      "nvim-telescope/telescope-file-browser.nvim",
      "nvim-telescope/telescope-ui-select.nvim",
      "nvim-telescope/telescope-dap.nvim",
      "nvim-telescope/telescope-project.nvim",
    },
    enabled = vim.g.astra_mode ~= "beginner",
    config = function()
      local ok, telescope = pcall(require, "telescope")
      if not ok then
        _G.log_error("Failed to load telescope: " .. tostring(telescope))
        return
      end
      telescope.setup({
        defaults = {
          prompt_prefix = "   ",
          selection_caret = " ",
          entry_prefix = " ",
          sorting_strategy = "ascending",
          layout_strategy = "horizontal",
          layout_config = {
            horizontal = { width = 0.87, height = 0.80, preview_width = 0.55, prompt_position = "top" },
          },
          mappings = {
            i = {
              ["<C-j>"] = require("telescope.actions").move_selection_next,
              ["<C-k>"] = require("telescope.actions").move_selection_previous,
              ["<C-u>"] = require("telescope.actions").preview_scrolling_up,
              ["<C-d>"] = require("telescope.actions").preview_scrolling_down,
            },
            n = { ["q"] = require("telescope.actions").close },
          },
        },
----- changed ---------------------
        pickers = {
          find_files = {
            layout_config = { preview_width = 0.6 },
          },
        },

        -------------- canged ----------------
        extensions = {
          fzf = {
            fuzzy = true,
            override_generic_sorter = true,
            override_file_sorter = true,
          },
          file_browser = {
            hijack_netrw = true,
            grouped = true,
            respect_gitignore = false,
          },
          project = {
            base_dirs = {
              "~/projects",
              "~/work",
              { "~/ml-projects", max_depth = 3 },
            },
            hidden_files = true,
          },
        },
      })
      telescope.load_extension("fzf")
      telescope.load_extension("file_browser")
      telescope.load_extension("ui-select")
      if vim.g.astra_mode == "pro" then
        telescope.load_extension("dap")
      end
      telescope.load_extension("project")
    end,
  },

 -- Indent Blankline
 {
  "lukas-reineke/indent-blankline.nvim",
  event = "User FilePost",
  opts = {
    indent = { char = "│", highlight = "IblChar" },
    scope = { char = "│", highlight = "IblScopeChar" },
  },
  config = function(_, opts)
    local hooks = require("ibl.hooks")
    hooks.register(hooks.type.WHITESPACE, hooks.builtin.hide_first_space_indent_level)
    require("ibl").setup(opts)
  end,
},

-- Formatting: Conform.nvim
{
  "stevearc/conform.nvim",
  event = "BufWritePre",
  enabled = vim.g.astra_mode ~= "beginner",
  config = function()
    local ok, conform = pcall(require, "conform")
    if not ok then
      _G.log_error("Failed to load conform: " .. tostring(conform))
      return
    end
    conform.setup({
      formatters_by_ft = {
        lua = { "stylua" },
        python = { "black", "isort" },
        javascript = { "prettier" },
        typescript = { "prettier" },
        html = { "prettier" },
        css = { "prettier" },
        json = { "prettier" },
        yaml = { "yamlfmt" },
        markdown = { "prettier" },
      },
      format_on_save = {
        timeout_ms = 500,
        lsp_fallback = true,
      },
      formatters = {
        isort = {
          command = "isort",
          args = { "--profile", "black", "-" },
        },
      },
    })
  end,
},

-- Snippets: LuaSnip
{
  "L3MON4D3/LuaSnip",
  dependencies = { "rafamadriz/friendly-snippets" },
  enabled = vim.g.astra_mode ~= "beginner",
  config = function()
    local ok, luasnip = pcall(require, "luasnip")
    if not ok then
      _G.log_error("Failed to load luasnip: " .. tostring(luasnip))
      return
    end
    require("luasnip.loaders.from_vscode").lazy_load()
    require("luasnip.loaders.from_snipmate").load()
    require("luasnip.loaders.from_lua").load()
    luasnip.filetype_extend("python", { "django", "numpy" })
    luasnip.filetype_extend("javascript", { "javascriptreact" })
    luasnip.filetype_extend("typescript", { "typescriptreact" })
    vim.api.nvim_create_autocmd("InsertLeave", {
      callback = function()
        if luasnip.session.current_nodes[vim.api.nvim_get_current_buf()] and not luasnip.session.jump_active then
          luasnip.unlink_current()
        end
      end,
    })
  end,
},

-- Terminal: Toggleterm (replacing nvchad.term)
{
  "akinsho/toggleterm.nvim",
  cmd = { "ToggleTerm", "TermExec" },
  enabled = vim.g.astra_mode == "pro",
  config = function()
    local ok, toggleterm = pcall(require, "toggleterm")
    if not ok then
      _G.log_error("Failed to load toggleterm: " .. tostring(toggleterm))
      return
    end
    toggleterm.setup({
      size = 20,
      open_mapping = [[<C-\>]],
      shade_terminals = true,
      shading_factor = 2,
      start_in_insert = true,
      persist_size = true,
      direction = "float",
      float_opts = { border = "curved" },
    })
  end,
},

-- Utilities
{
  "folke/which-key.nvim",
  keys = { "<leader>", "<c-w>", '"', "'", "`", "c", "v", "g" },
  cmd = "WhichKey",
  config = function()
    local ok, wk = pcall(require, "which-key")
    if not ok then
      _G.log_error("Failed to load which-key.nvim: " .. tostring(wk))
      return
    end
    wk.setup({
      plugins = { spelling = true, presets = true },
      key_labels = { ["<leader>"] = "SPC" },
      window = { border = "double", margin = { 1, 0, 1, 0 } },
      show_help = true,
      show_keys = true,
      notify = false,
    })
    vim.defer_fn(function()
      wk.register({
        ["<Leader>"] = {
          f = { name = "Find" },
          b = { name = "Buffer" },
          d = { name = "Debug", cond = vim.g.astra_mode == "pro" },
          l = { name = "LSP", cond = vim.g.astra_mode ~= "beginner" },
          j = { name = "Jupyter", cond = vim.g.astra_mode == "pro" },
          t = { name = "Test", cond = vim.g.astra_mode == "pro" },
          s = { name = "Session" },
          p = { name = "Project" },
          z = { name = "Zen" },
          m = { name = "Mode" },
          w = { name = "Workspace" },
        },
      })
    end, 100)
  end,
},
{
  "lewis6991/gitsigns.nvim",
  event = "User FilePost",
  enabled = vim.g.astra_mode ~= "beginner",
  opts = function()
    return {
      signs = {
        add = { text = "│" },
        change = { text = "│" },
        delete = { text = "󰍵" },
        topdelete = { text = "‾" },
        changedelete = { text = "󱕖" },
      },
      current_line_blame = vim.g.astra_mode == "pro",
      current_line_blame_opts = { delay = 500 },
    }
  end,
},
{
  "numToStr/Comment.nvim",
  event = "BufReadPre",
  enabled = vim.g.astra_mode ~= "beginner",
  config = function()
    local ok, comment = pcall(require, "Comment")
    if not ok then
      _G.log_error("Failed to load Comment.nvim: " .. tostring(comment))
      return
    end
    comment.setup({
      pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
    })
  end,
},
{
  "folke/zen-mode.nvim",
  cmd = "ZenMode",
  config = function()
    local ok, zen_mode = pcall(require, "zen-mode")
    if not ok then
      _G.log_error("Failed to load zen-mode: " .. tostring(zen_mode))
      return
    end
    zen_mode.setup({
      window = {
        backdrop = 0.95,
        width = 120,
        height = 1,
        options = {
          signcolumn = "no",
          number = false,
          relativenumber = false,
          cursorline = false,
        },
      },
      plugins = {
        tmux = { enabled = true },
        kitty = { enabled = vim.fn.executable("kitty") == 1, font = "+4" },
      },
    })
  end,
},
{
  "windwp/nvim-autopairs",
  event = "InsertEnter",
  enabled = vim.g.astra_mode ~= "beginner",
  config = function()
    local ok, autopairs = pcall(require, "nvim-autopairs")
    if not ok then
      _G.log_error("Failed to load nvim-autopairs: " .. tostring(autopairs))
      return
    end
    autopairs.setup({
      check_ts = true,
      ts_config = {
        lua = { "string", "source" },
        javascript = { "string", "template_string" },
        python = { "string", "source" },
      },
      fast_wrap = {},
      disable_filetype = { "TelescopePrompt", "vim" },
    })
    local cmp_autopairs = require("nvim-autopairs.completion.cmp")
    require("cmp").event:on("confirm_done", cmp_autopairs.on_confirm_done())
  end,
},
{
  "folke/trouble.nvim",
  cmd = { "Trouble", "TroubleToggle" },
  enabled = vim.g.astra_mode ~= "beginner",
  config = function()
    local ok, trouble = pcall(require, "trouble")
    if not ok then
      _G.log_error("Failed to load trouble: " .. tostring(trouble))
      return
    end
    trouble.setup({
      position = "bottom",
      height = 10,
      auto_open = false,
      auto_close = true,
      icons = true,
      mode = "workspace_diagnostics",
    })
  end,
},
{
  "folke/persistence.nvim",
  event = "BufReadPre",
  config = function()
    local ok, persistence = pcall(require, "persistence")
    if not ok then
      _G.log_error("Failed to load persistence: " .. tostring(persistence))
      return
    end
    persistence.setup({
      dir = vim.fn.stdpath("cache") .. "/session/",
      options = { "buffers", "curdir", "tabpages", "winsize", "globals" },
    })
    vim.api.nvim_create_autocmd("User", {
      pattern = "PersistenceSavePre",
      callback = function()
        vim.g.tokyonight_persist = {
          style = vim.g.tokyonight_style or "night",
          transparent = false,
          mode = vim.g.astra_mode or "advanced",
        }
      end,
    })
    vim.api.nvim_create_autocmd("User", {
      pattern = "PersistenceLoad",
      callback = function()
        if vim.g.tokyonight_persist then
          vim.g.tokyonight_style = vim.g.tokyonight_persist.style
          vim.g.tokyonight_transparent = false
          vim.g.astra_mode = vim.g.tokyonight_persist.mode
          require("tokyonight").setup({
            style = vim.g.tokyonight_style,
            transparent = false,
          })
          vim.cmd("colorscheme tokyonight")
        end
      end,
    })
  end,
},
{
  "echasnovski/mini.nvim",
  event = "VeryLazy",
  enabled = vim.g.astra_mode ~= "beginner",
  config = function()
    local ok_animate, animate = pcall(require, "mini.animate")
    if not ok_animate then
      _G.log_error("Failed to load mini.animate: " .. tostring(animate))
      return
    end
    animate.setup({
      cursor = { enable = false },
      scroll = { enable = vim.g.astra_mode == "pro" },
      resize = { enable = vim.g.astra_mode == "pro" },
      open = { enable = vim.g.astra_mode == "pro" },
      close = { enable = vim.g.astra_mode == "pro" },
    })
    local ok_indentscope, indentscope = pcall(require, "mini.indentscope")
    if not ok_indentscope then
      _G.log_error("Failed to load mini.indentscope: " .. tostring(indentscope))
    else
      indentscope.setup()
    end
    local ok_clue, clue = pcall(require, "mini.clue")
    if not ok_clue then
      _G.log_error("Failed to load mini.clue: " .. tostring(clue))
    else
      clue.setup()
    end
  end,
},
}

-- Load plugins with optimized settings
require("lazy").setup(plugins, {
defaults = { lazy = true },
install = { colorscheme = { "tokyonight" } },
performance = {
  cache = { enabled = true },
  rtp = {
    disabled_plugins = {
      "gzip", "matchit", "netrw", "tarPlugin", "tohtml", "tutor", "zipPlugin",
      "spellfile", "rplugin",
    },
  },
},
profiling = {
  loader = true,
  require = true,
},
})
------changed here -------------------

vim.api.nvim_create_user_command("ToggleTheme", function()
  local current = vim.g.tokyonight_style or "night"
  local new_style = current == "night" and "day" or "night"
  vim.g.tokyonight_style = new_style
  require("tokyonight").setup({ style = new_style })
  vim.cmd("colorscheme tokyonight")
  vim.notify("Theme switched to " .. new_style, vim.log.levels.INFO)
end, { desc = "Toggle between light and dark themes" })


vim.api.nvim_create_user_command("FineTuneModel", function(opts)
  local args = opts.args ~= "" and opts.args or "--model gpt2 --dataset %"
  vim.cmd("ToggleTerm")
  vim.cmd("TermExec cmd='python3 fine_tune_model.py " .. args .. "'")
end, { nargs = "*", desc = "Fine-tune AI model" })

vim.api.nvim_create_user_command("AstraCheatSheet", function()
  local cheat_sheet = vim.fn.stdpath("config") .. "/cheatsheet.md"
  if vim.fn.filereadable(cheat_sheet) == 0 then
    local content = [[
    # AstraVim Cheat Sheet
    ## General
    - `<Leader>s`: Save
    - `<Leader>q`: Quit
    - `<Leader>n`: Toggle line numbers
    ## File Explorer
    - `<C-n>`: Toggle NvimTree
    - `<Leader>e`: Focus NvimTree
    ## Telescope
    - `<Leader>ff`: Find files
    - `<Leader>fw`: Live grep
    ## LSP
    - `K`: Hover doc
    - `gd`: Go to definition
    - `<Leader>ca`: Code action
    ]]
    vim.fn.writefile(vim.split(content, "\n"), cheat_sheet)
  end
  vim.cmd("split " .. cheat_sheet)
end, { desc = "View AstraVim Cheat Sheet" })


vim.api.nvim_create_user_command("AstraViewLogs", function()
  vim.cmd("split " .. vim.fn.stdpath("cache") .. "/logs/astra_errors.log")
end, { desc = "View AstraVim error logs" })

-- Custom Commands for Vehicle Number Plate Detection
vim.api.nvim_create_user_command("RunPlateDetection", function(opts)
  if vim.fn.filereadable("run_plate_detection.py") == 0 then
    vim.notify("run_plate_detection.py not found", vim.log.levels.ERROR)
    return
  end
  local args = opts.args ~= "" and opts.args or "--model yolov8 --input %"
  vim.cmd("!python3 run_plate_detection.py " .. vim.fn.shellescape(args))
end, { nargs = "*", desc = "Run vehicle number plate detection" })

vim.api.nvim_create_user_command("TrainPlateModel", function(opts)
  local args = opts.args ~= "" and opts.args or "--epochs 50 --batch 16"
  vim.cmd("!python3 train_plate_model.py " .. args)
end, { nargs = "*", desc = "Train plate detection model" })

vim.api.nvim_create_user_command("TrainYOLO", function(opts)
  local args = opts.args ~= "" and opts.args or "--epochs 50 --batch 16"
  vim.cmd("ToggleTerm")
  vim.cmd("TermExec cmd='python3 train_plate_model.py " .. args .. "'")
end, { nargs = "*", desc = "Train YOLOvX model in terminal" })

vim.api.nvim_create_user_command("VisualizeYOLO", function()
  if vim.fn.executable("python3") ~= 1 then
    vim.notify("Python3 not found", vim.log.levels.ERROR)
    return
  end
  vim.cmd("MagmaEvaluateLine")
  vim.defer_fn(function()
    vim.cmd("MagmaShowOutput")
  end, 500)
end, { desc = "Visualize YOLOvX output" })

-- Custom Config Editor
vim.api.nvim_create_user_command("AstraVimConfig", function()
  vim.cmd("vsplit " .. vim.fn.stdpath("config") .. "/init.lua")
  vim.cmd("set filetype=lua")
  vim.notify("Editing AstraVim configuration", vim.log.levels.INFO)
end, { desc = "Edit AstraVim configuration" })

-- Mode Management Commands
vim.api.nvim_create_user_command("AstraModeBeginner", function()
  vim.g.astra_mode = "beginner"
  vim.notify("Switched to Beginner Mode", vim.log.levels.INFO)
  vim.cmd("colorscheme tokyonight-day")
  vim.opt.relativenumber = false
  vim.opt.list = false
  vim.cmd("NvimTreeClose")
end, { desc = "Switch to Beginner Mode" })

vim.api.nvim_create_user_command("AstraModeAdvanced", function()
  vim.g.astra_mode = "advanced"
  vim.notify("Switched to Advanced Mode", vim.log.levels.INFO)
  vim.cmd("colorscheme tokyonight-storm")
  vim.opt.relativenumber = true
  vim.opt.list = true
end, { desc = "Switch to Advanced Mode" })

vim.api.nvim_create_user_command("AstraModePro", function()
  vim.g.astra_mode = "pro"
  vim.notify("Switched to Pro Mode", vim.log.levels.INFO)
  vim.cmd("colorscheme tokyonight-night")
  vim.opt.relativenumber = true
  vim.opt.list = true
end, { desc = "Switch to Pro Mode" })

-- Optimize Startup
vim.defer_fn(function()
  vim.cmd("syntax sync minlines=200")
  vim.opt.foldmethod = "expr"
  vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
  vim.opt.foldenable = false
end, 0)

-- Custom notify to suppress which-key warnings
local original_notify = vim.notify
vim.notify = function(msg, level, opts)
  if level == vim.log.levels.WARN and msg:match("which%-key") then
    _G.log_error("Suppressed which-key warning: " .. msg)
    return
  end
  original_notify(msg, level, opts)
end