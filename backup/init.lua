-- ~/.config/nvim/init.lua
-- AstraVim v2.4: Ultimate Neovim Configuration
-- Created by Grok, Optimized for Performance and AI-Driven Development
-- Updated: April 29, 2025

-- AstraVim Modes: Beginner, Advanced, Pro
-- - Beginner: Minimal plugins, simple UI, no AI or animations
-- - Advanced: Adds LSP, AI completions, moderate UI enhancements
-- - Pro: Full features with debugging, ML tools, and animations
local astra_mode = vim.g.astra_mode or "advanced" -- Default to Advanced

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

  -- Core Settings for Performance and Usability
  vim.opt.termguicolors = true      -- Enable true color support
  vim.opt.number = true             -- Show line numbers
  vim.opt.relativenumber = astra_mode ~= "beginner" -- Relative line numbers (off in Beginner)
  vim.opt.cursorline = true         -- Highlight current line
  vim.opt.cursorlineopt = "number"  -- Highlight only line number
  vim.opt.scrolloff = 12            -- Smoother navigation
  vim.opt.signcolumn = "yes:1"      -- Always show signcolumn
  vim.opt.mouse = "a"               -- Enable mouse
  vim.opt.clipboard = "unnamedplus" -- System clipboard
  vim.opt.undofile = true           -- Persistent undo
  vim.opt.undodir = vim.fn.stdpath("cache") .. "/undo" -- Undo file location
  vim.opt.smoothscroll = true       -- Smooth scrolling
  vim.opt.updatetime = 250          -- Faster updates
  vim.opt.timeoutlen = 400          -- Faster key sequences
  vim.opt.lazyredraw = true         -- Reduce redraws for performance
  vim.opt.redrawtime = 1500         -- Optimize for large files
  vim.opt.shortmess:append("sIc")   -- Reduce messages

  -- Cursor Settings: Blink once every 2 seconds
  vim.opt.guicursor = {
    "n-v-c:block-Cursor/lCursor-blinkwait2000-blinkon200-blinkoff200",
    "i-ci-ve:ver25-Cursor/lCursor-blinkwait2000-blinkon200-blinkoff200",
    "r-cr-o:hor20-Cursor/lCursor-blinkwait2000-blinkon200-blinkoff200",
  }

  -- Editing Settings for Clean Code
  vim.opt.tabstop = 2               -- 2 spaces for tabs
  vim.opt.shiftwidth = 2            -- 2 spaces for indent
  vim.opt.expandtab = true          -- Convert tabs to spaces
  vim.opt.smartindent = true        -- Smart auto-indenting
  vim.opt.wrap = false              -- No line wrapping
  vim.opt.list = astra_mode ~= "beginner" -- Show invisible characters (off in Beginner)
  vim.opt.listchars = {
    tab = "→ ",
    trail = "·",
    nbsp = "␣",
    eol = "↲",
  }                                 -- Enhanced visibility
  vim.opt.breakindent = true        -- Indent wrapped lines
  vim.opt.formatoptions:remove("r") -- Disable auto-comment on Enter
  vim.opt.fillchars = { eob = " " } -- Remove ~ for empty lines

  -- Search Settings for Efficiency
  vim.opt.ignorecase = true         -- Case-insensitive search
  vim.opt.smartcase = true          -- Case-sensitive with uppercase
  vim.opt.inccommand = "split"      -- Live preview for substitutions
  vim.opt.grepprg = "rg --vimgrep"  -- Use ripgrep for faster grep
  vim.opt.grepformat = "%f:%l:%c:%m" -- Ripgrep format

  -- Window Settings for Seamless Workflow
  vim.opt.splitbelow = true         -- New splits below
  vim.opt.splitright = true         -- New splits to the right
  vim.opt.completeopt = { "menuone", "noselect" } -- Better completion
  vim.opt.pumheight = 10            -- Limit completion menu height

  -- Leader Keys
  vim.g.mapleader = " "
  vim.g.maplocalleader = ","

  -- Create Directories
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

      -- Error Logging Setup
      local function log_error(msg)
      local log_file = vim.fn.stdpath("cache") .. "/logs/astra_errors.log"
      local timestamp = os.date("%Y-%m-%d %H:%M:%S")
      local log_msg = string.format("[%s] %s\n", timestamp, msg)
      local file = io.open(log_file, "a")
      if file then
        file:write(log_msg)
        file:close()
        end
        end

        -- Cross-Platform System Stats
        local function get_system_stats()
        local stats = { cpu = "N/A", mem = "N/A" }
        local is_windows = vim.loop.os_uname().sysname:match("Windows")
        local ok, result = pcall(function()
        if is_windows then
          local wmic_cpu = vim.fn.systemlist("wmic cpu get loadpercentage")
          for _, line in ipairs(wmic_cpu) do
            local percent = line:match("^%d+$")
            if percent then
              stats.cpu = percent .. "%"
              break
              end
              end
              local wmic_mem = vim.fn.systemlist("wmic os get freephysicalmemory,totalvisiblememorysize")
              local free, total
              for _, line in ipairs(wmic_mem) do
                if line:match("^%d+$") then
                  if not free then
                    free = tonumber(line) / 1024
                    else
                      total = tonumber(line) / 1024
                      end
                      end
                      end
                      if free and total then
                        stats.mem = string.format("%.1f/%.1f GB", total - free, total)
                        end
                        else
                          local cpu = vim.fn.systemlist("top -bn1 2>/dev/null")
                          for _, line in ipairs(cpu) do
                            if line:match("%%Cpu") then
                              local cpu_idle = line:match("(%d+%.%d+)%s+id")
                              stats.cpu = cpu_idle and string.format("%.1f%%", 100 - tonumber(cpu_idle)) or "N/A"
                              break
                              end
                              end
                              local mem = vim.fn.systemlist("free -h 2>/dev/null")
                              for _, line in ipairs(mem) do
                                if line:match("Mem:") then
                                  stats.mem = line:match("Mem:%s+%S+%s+(%S+)") or "N/A"
                                  break
                                  end
                                  end
                                  end
                                  end)
        if not ok then
          log_error("Failed to get system stats: " .. result)
          end
          return stats
          end

          -- Autocommands for Enhanced Experience
          local augroup = vim.api.nvim_create_augroup("AstraVim", { clear = true })
          vim.api.nvim_create_autocmd("TextYankPost", {
            group = augroup,
            callback = function()
            vim.highlight.on_yank({ timeout = 150 })
            end,
            desc = "Highlight yanked text",
          })
          vim.api.nvim_create_autocmd("BufWritePre", {
            group = augroup,
            callback = function()
            if astra_mode ~= "beginner" then
              vim.lsp.buf.format({ async = false })
              end
              end,
              desc = "Auto-format on save (Advanced/Pro)",
          })
          vim.api.nvim_create_autocmd("FileType", {
            group = augroup,
            pattern = { "python", "javascript", "typescript" },
            callback = function()
            vim.bo.tabstop = 4
            vim.bo.shiftwidth = 4
            end,
            desc = "Adjust indentation for specific filetypes",
          })
          vim.api.nvim_create_autocmd("VimLeave", {
            group = augroup,
            callback = function()
            if vim.g.alpha_timer then vim.g.alpha_timer:stop() end
              end,
          })

          -- Startup Fade-In Effect (Pro Mode Only)
          if astra_mode == "pro" then
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

            -- Mode Management
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

            -- Plugins Setup with lazy.nvim
            local plugins = {
              -- Theming: TokyoNight
              {
                "folke/tokyonight.nvim",
                lazy = false,
                priority = 1000,
                config = function()
                local ok, tokyonight = pcall(require, "tokyonight")
                if not ok then
                  log_error("Failed to load tokyonight.nvim: " .. tostring(tokyonight))
                  return
                  end
                  tokyonight.setup({
                    style = astra_mode == "beginner" and "day"
                    or astra_mode == "advanced" and "storm"
                    or "night",
                    transparent = false,
                    styles = {
                      comments = { italic = true },
                      keywords = { bold = true },
                      functions = { italic = astra_mode ~= "beginner" },
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

              -- Web Devicons
              {
                "nvim-tree/nvim-web-devicons",
                opts = { default = true },
              },

              -- Statusline: Lualine
              {
                "nvim-lualine/lualine.nvim",
                event = "VeryLazy",
                config = function()

                -- Conditions for dynamic display
                local conditions = {
                  buffer_not_empty = function()
                  return vim.fn.empty(vim.fn.expand("%:t")) ~= 1
                  end,
                  hide_in_width = function()
                  return vim.fn.winwidth(0) > 80
                  end,
                  is_pro_mode = function()
                  return vim.g.astra_mode == "pro"
                  end,
                }

                -- Custom component for AstraVim mode
                local function astra_mode()
                local mode = vim.g.astra_mode or "advanced"
                local icons = { beginner = "󰣐", advanced = "󰚩", pro = "󱃖" }
                return icons[mode] .. " " .. mode:sub(1, 1):upper() .. mode:sub(2)
                end

                -- Custom component for ML training status (placeholder)
                local function ml_training_status()
                local training = vim.fn.filereadable("/tmp/plate_training.log") == 1
                return training and "🧠 Training" or ""
                end

                require("lualine").setup({
                  options = {
                    theme = jnhtr_theme,
                    component_separators = { left = "│", right = "│" },
                    section_separators = { left = "", right = "" },
                    disabled_filetypes = {
                      statusline = { "alpha", "dashboard", "starter" },
                      winbar = { "ipynb" },
                    },
                    ignore_focus = { "NvimTree" },
                    always_divide_middle = true,
                    globalstatus = true,
                    refresh = {
                      statusline = 500,
                      tabline = 1000,
                      winbar = 1000,
                    },
                  },
                  sections = {
                    lualine_a = {
                      {
                        "mode",
                        fmt = function(str) return str:sub(1, 1) end,
                                         icon = { "󰌌" },
                                         padding = { left = 1, right = 1 },
                      },
                    },
                    lualine_b = {
                      {
                        "branch",
                        icon = { "" },
                        padding = { left = 1, right = 1 },
                      },
                      {
                        "diff",
                        symbols = { added = " ", modified = "󰝤 ", removed = "󰍵 " },
                        cond = conditions.hide_in_width,
                      },
                      {
                        "filetype",
                        colored = true,
                        icon_only = true,
                        padding = { left = 1, right = 1 },
                        cond = conditions.hide_in_width,
                      },
                    },
                    lualine_c = {
                      {
                        "filename",
                        cond = conditions.buffer_not_empty,
                        file_status = true,
                        newfile_status = true,
                        path = 1,
                        symbols = {
                          modified = "●",
                          readonly = "🔒",
                          unnamed = "[No Name]",
                          newfile = "[New]",
                        },
                      },
                      {
                        ml_training_status,
                        cond = function() return conditions.is_pro_mode() and conditions.hide_in_width() end,
                      },
                    },
                    lualine_x = {
                      {
                        "diagnostics",
                        sources = { "nvim_lsp" },
                        sections = { "error", "warn", "info", "hint" },
                        symbols = { error = " ", warn = " ", info = " ", hint = "󰌵 " },
                        colored = true,
                        update_in_insert = false,
                        always_visible = false,
                        cond = conditions.hide_in_width,
                      },
                      {
                        "lsp_status",
                        icon = "",
                        symbols = { spinner = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }, done = "✓" },
                        cond = conditions.is_pro_mode,
                      },
                      {
                        "location",
                        padding = { left = 1, right = 1 },
                      },
                    },
                    lualine_y = {
                      {
                        "encoding",
                        show_bomb = true,
                        cond = conditions.hide_in_width,
                      },
                      {
                        "fileformat",
                        symbols = { unix = "", dos = "", mac = "" },
                        cond = conditions.hide_in_width,
                      },
                    },
                    lualine_z = {
                      {
                        "progress",
                        fmt = function() return "%P/%L" end,
                                         padding = { left = 1, right = 1 },
                      },
                      {
                        astra_mode,
                        padding = { left = 1, right = 1 },
                      },
                    },
                  },
                  inactive_sections = {
                    lualine_a = {},
                    lualine_b = {},
                    lualine_c = {
                      {
                        "filename",
                        file_status = true,
                        path = 1,
                        symbols = { modified = "●", readonly = "🔒", unnamed = "[No Name]" },
                      },
                    },
                    lualine_x = { "location" },
                    lualine_y = {},
                    lualine_z = {},
                  },
                  tabline = {
                    lualine_a = {
                      {
                        "buffers",
                        show_filename_only = true,
                        hide_filename_extension = false,
                        show_modified_status = true,
                        mode = 2,
                        max_length = vim.o.columns * 2 / 3,
                        symbols = { modified = " ●", alternate_file = "#", directory = "" },
                      },
                    },
                    lualine_z = { "tabs" },
                  },
                  winbar = {
                    lualine_c = {
                      {
                        "filename",
                        file_status = true,
                        path = 3,
                        symbols = { modified = "●", readonly = "🔒", unnamed = "[No Name]" },
                      },
                    },
                  },
                  inactive_winbar = {
                    lualine_c = {
                      {
                        "filename",
                        file_status = true,
                        path = 3,
                        symbols = { modified = "●", readonly = "🔒", unnamed = "[No Name]" },
                      },
                    },
                  },
                  extensions = { "nvim-tree", "toggleterm", "quickfix", "fugitive", "magma-nvim" },
                })

                -- Set transparent statusline highlights using colors table

                end,
              },

              -- Dashboard: Alpha-nvim
              {
                "goolord/alpha-nvim",
                event = "VimEnter",
                dependencies = { "nvim-lua/plenary.nvim" },
                enabled = astra_mode ~= "beginner",
                config = function()
                local ok, alpha = pcall(require, "alpha")
                if not ok then
                  log_error("Failed to load alpha-nvim: " .. tostring(alpha))
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
                    if not btn.mode or btn.mode == astra_mode then
                      table.insert(dashboard.section.buttons.val, dashboard.button(btn.key, btn.icon .. "  " .. btn.desc, btn.action))
                      end
                      end
                      local stats = get_system_stats()
                      local startup_time = vim.fn.reltimefloat(vim.fn.reltime()) * 1000
                      dashboard.section.footer.val = {
                        "🌌 AstraVim v2.4 - Powered by xAI",
                        "💻 Active Project: " .. vim.fn.getcwd(),
                        "🖥  CPU: " .. stats.cpu .. " | Mem: " .. stats.mem,
                        "⚡ Startup: " .. string.format("%.2fms", startup_time),
                        "🛠  Mode: " .. astra_mode:gsub("^%l", string.upper),
                      }
                      alpha.setup(dashboard.opts)
                      end,
              },

              -- File Explorer: Nvim-tree
              {
                "nvim-tree/nvim-tree.lua",
                cmd = { "NvimTreeToggle", "NvimTreeFocus" },
                dependencies = { "nvim-tree/nvim-web-devicons" },
                enabled = astra_mode ~= "beginner",
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

              -- Syntax Highlighting: Treesitter
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
                enabled = astra_mode ~= "beginner",
                config = function()
                local ok, treesitter = pcall(require, "nvim-treesitter.configs")
                if not ok then
                  log_error("Failed to load nvim-treesitter: " .. tostring(treesitter))
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
                      enable = astra_mode == "pro",
                      keymaps = {
                        init_selection = "<C-Space>",
                        node_incremental = "<C-Space>",
                        scope_incremental = "<C-s>",
                        node_decremental = "<C-Backspace>",
                      },
                    },
                    textobjects = {
                      select = {
                        enable = astra_mode == "pro",
                        lookahead = true,
                        keymaps = {
                          ["af"] = "@function.outer",
                          ["if"] = "@function.inner",
                          ["ac"] = "@class.outer",
                          ["ic"] = "@class.inner",
                        },
                      },
                      move = {
                        enable = astra_mode == "pro",
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
                      enable = astra_mode ~= "beginner",
                      extended_mode = true,
                      max_file_lines = 2000,
                    },
                    context_commentstring = { enable = true, enable_autocmd = false },
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
                enabled = astra_mode ~= "beginner",
                config = function()
                local ok, cmp = pcall(require, "cmp")
                if not ok then
                  log_error("Failed to load nvim-cmp: " .. tostring(cmp))
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
                      { name = "copilot", priority = 1000, group_index = 1, enabled = astra_mode == "pro" },
                      { name = "cmp_tabnine", priority = 950, group_index = 1, enabled = astra_mode == "pro" },
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
                      ghost_text = astra_mode == "pro", -- AI suggestions inline
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
                enabled = astra_mode == "pro",
                config = function()
                local ok, copilot = pcall(require, "copilot")
                if not ok then
                  log_error("Failed to load copilot.lua: " .. tostring(copilot))
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
                enabled = astra_mode == "pro",
                config = function()
                local ok, copilot_cmp = pcall(require, "copilot_cmp")
                if not ok then
                  log_error("Failed to load copilot-cmp: " .. tostring(copilot_cmp))
                  return
                  end
                  copilot_cmp.setup()
                  end,
              },
              {
                "tzachar/cmp-tabnine",
                build = "./install.sh",
                enabled = astra_mode == "pro",
                config = function()
                local ok, tabnine = pcall(require, "cmp_tabnine.config")
                if not ok then
                  log_error("Failed to load cmp-tabnine: " .. tostring(tabnine))
                  return
                  end
                  tabnine:setup({
                    max_lines = 1000,
                    max_num_results = 10,
                    sort = true,
                  })
                  end,
              },

              -- LSP: Optimized with Mason and Lspsaga
              {
                "neovim/nvim-lspconfig",
                event = { "BufReadPost", "BufNewFile" },
                dependencies = {
                  "williamboman/mason.nvim",
                  "williamboman/mason-lspconfig.nvim",
                  "glepnir/lspsaga.nvim",
                  "folke/neodev.nvim",
                },
                enabled = astra_mode ~= "beginner",
                config = function()
                local ok, neodev = pcall(require, "neodev")
                if not ok then
                  log_error("Failed to load neodev: " .. tostring(neodev))
                  return
                  end
                  neodev.setup()
                  local ok, mason = pcall(require, "mason")
                  if not ok then
                    log_error("Failed to load mason: " .. tostring(mason))
                    return
                    end
                    mason.setup({
                      PATH = "skip",
                      ui = {
                        border = "rounded",
                        icons = {
                          package_pending = " ",
                          package_installed = " ",
                          package_uninstalled = " ",
                        },
                      },
                      max_concurrent_installers = 10,
                    })
                    local ok, mason_lspconfig = pcall(require, "mason-lspconfig")
                    if not ok then
                      log_error("Failed to load mason-lspconfig: " .. tostring(mason_lspconfig))
                      return
                      end
                      mason_lspconfig.setup({
                        ensure_installed = {
                          "lua_ls", "pyright", "tsserver", "html", "cssls", "jsonls",
                          "clangd", "rust_analyzer", "gopls", "bashls", "yamlls",
                          "dockerls", "marksman",
                        },
                        automatic_installation = true,
                      })
                      local ok, lspsaga = pcall(require, "lspsaga")
                      if not ok then
                        log_error("Failed to load lspsaga: " .. tostring(lspsaga))
                        return
                        end
                        lspsaga.setup({
                          ui = { border = "rounded", code_action_icon = "💡" },
                          symbol_in_winbar = { enable = astra_mode == "pro", separator = " ➤ " },
                          code_action = { show_server_name = true },
                          lightbulb = { enable = astra_mode == "pro", sign = false },
                        })
                        local lspconfig = require("lspconfig")
                        local capabilities = vim.tbl_deep_extend("force", vim.lsp.protocol.make_client_capabilities(), {
                          textDocument = {
                            completion = {
                              completionItem = {
                                documentationFormat = { "markdown", "plaintext" },
                                snippetSupport = true,
                                preselectSupport = true,
                                insertReplaceSupport = true,
                                labelDetailsSupport = true,
                                deprecatedSupport = true,
                                commitCharactersSupport = true,
                                tagSupport = { valueSet = { 1 } },
                                resolveSupport = {
                                  properties = { "documentation", "detail", "additionalTextEdits" },
                                },
                              },
                            },
                          },
                        })
                        local on_attach = function(client, bufnr)
                        if vim.api.nvim_buf_line_count(bufnr) > 10000 then
                          client.server_capabilities.diagnosticProvider = false
                          client.server_capabilities.documentFormattingProvider = false
                          end
                          if client.server_capabilities.inlayHintProvider and astra_mode == "pro" then
                            vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
                            end
                            if client.supports_method("textDocument/semanticTokens") then
                              client.server_capabilities.semanticTokensProvider = nil
                              end
                              end
                              local servers = {
                                lua_ls = {
                                  settings = {
                                    Lua = {
                                      diagnostics = { globals = { "vim" } },
                                      workspace = {
                                        library = {
                                          vim.fn.expand("$VIMRUNTIME/lua"),
                                          vim.fn.stdpath("data") .. "/lazy/ui/nvchad_types",
                                          vim.fn.stdpath("data") .. "/lazy/lazy.nvim/lua/lazy",
                                          "${3rd}/luv/library",
                                        },
                                        checkThirdParty = false,
                                      },
                                      telemetry = { enable = false },
                                    },
                                  },
                                },
                                pyright = {
                                  settings = {
                                    python = {
                                      analysis = {
                                        autoSearchPaths = true,
                                        useLibraryCodeForTypes = true,
                                        diagnosticMode = "openFilesOnly",
                                      },
                                    },
                                  },
                                },
                                tsserver = {},
                                html = {},
                                cssls = {},
                                jsonls = {},
                                clangd = {},
                                rust_analyzer = {},
                                gopls = {},
                                bashls = {},
                                yamlls = {},
                                dockerls = {},
                                marksman = {},
                              }
                              for server, config in pairs(servers) do
                                lspconfig[server].setup(vim.tbl_deep_extend("force", {
                                  on_attach = on_attach,
                                  capabilities = capabilities,
                                }, config))
                                end
                                vim.api.nvim_create_autocmd("LspAttach", {
                                  callback = function(args)
                                  local bufnr = args.buf
                                  local opts = function(desc) return { buffer = bufnr, desc = "LSP " .. desc, silent = true } end
                                  vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts("Go to declaration"))
                                  vim.keymap.set("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, opts("Add workspace folder"))
                                  vim.keymap.set("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, opts("Remove workspace folder"))
                                  vim.keymap.set("n", "<leader>wl", function()
                                  print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
                                  end, opts("List workspace folders"))
                                  vim.keymap.set("n", "<leader>D", vim.lsp.buf.type_definition, opts("Go to type definition"))
                                  end,
                                })
                                end,
              },

              -- Jupyter Integration: Enhanced for ML Work
              {
                "goerz/jupytext.vim",
                event = "BufReadPre *.ipynb",
                enabled = astra_mode == "pro",
                config = function()
                vim.g.jupytext_fmt = "py:percent"
                vim.g.jupytext_filetype_map = { ["py:percent"] = "python" }
                end,
              },
              {
                "ahmedkhalf/jupyter-nvim",
                event = "BufReadPre *.ipynb",
                enabled = astra_mode == "pro",
                config = function()
                local ok, jupyter = pcall(require, "jupyter-nvim")
                if not ok then
                  log_error("Failed to load jupyter-nvim: " .. tostring(jupyter))
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
                enabled = astra_mode == "pro",
                config = function()
                vim.g.magma_automatically_open_output = true
                vim.g.magma_image_provider = vim.fn.executable("kitty") == 1 and "kitty" or "none"
                end,
              },

              -- Debugging: Advanced DAP
              {
                "mfussenegger/nvim-dap",
                cmd = { "DapToggleBreakpoint", "DapContinue" },
                dependencies = {
                  "rcarriga/nvim-dap-ui",
                  "theHamsta/nvim-dap-virtual-text",
                  "nvim-telescope/telescope-dap.nvim",
                  "mfussenegger/nvim-dap-python",
                },
                enabled = astra_mode == "pro",
                config = function()
                local ok, dap = pcall(require, "dap")
                if not ok then
                  log_error("Failed to load nvim-dap: " .. tostring(dap))
                  return
                  end
                  local ok, dapui = pcall(require, "dapui")
                  if not ok then
                    log_error("Failed to load nvim-dap-ui: " .. tostring(dapui))
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
                enabled = astra_mode == "pro",
                config = function()
                local ok, neotest = pcall(require, "neotest")
                if not ok then
                  log_error("Failed to load neotest: " .. tostring(neotest))
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

              -- Telescope: Enhanced with Project Management
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
                enabled = astra_mode ~= "beginner",
                config = function()
                local ok, telescope = pcall(require, "telescope")
                if not ok then
                  log_error("Failed to load telescope: " .. tostring(telescope))
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
                        },
                        n = { ["q"] = require("telescope.actions").close },
                      },
                    },
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
                  if astra_mode == "pro" then
                    telescope.load_extension("dap")
                    end
                    telescope.load_extension("project")
                    end,
              },

              -- Indent Blankline (NvChad Config)
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
                enabled = astra_mode ~= "beginner",
                config = function()
                local ok, conform = pcall(require, "conform")
                if not ok then
                  log_error("Failed to load conform: " .. tostring(conform))
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

              -- Snippets: LuaSnip (NvChad Config)
              {
                "L3MON4D3/LuaSnip",
                dependencies = { "rafamadriz/friendly-snippets" },
                enabled = astra_mode ~= "beginner",
                config = function()
                local ok, luasnip = pcall(require, "luasnip")
                if not ok then
                  log_error("Failed to load luasnip: " .. tostring(luasnip))
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

              -- Terminal: Toggleterm
              {
                "akinsho/toggleterm.nvim",
                cmd = { "ToggleTerm", "TermExec" },
                enabled = astra_mode == "pro",
                config = function()
                local ok, toggleterm = pcall(require, "toggleterm")
                if not ok then
                  log_error("Failed to load toggleterm: " .. tostring(toggleterm))
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
                  log_error("Failed to load which-key.nvim: " .. tostring(wk))
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
                      d = { name = "Debug", cond = astra_mode == "pro" },
                      l = { name = "LSP", cond = astra_mode ~= "beginner" },
                      j = { name = "Jupyter", cond = astra_mode == "pro" },
                      t = { name = "Test", cond = astra_mode == "pro" },
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
                enabled = astra_mode ~= "beginner",
                opts = function()
                return {
                  signs = {
                    add = { text = "│" },
                    change = { text = "│" },
                    delete = { text = "󰍵" },
                    topdelete = { text = "‾" },
                    changedelete = { text = "󱕖" },
                  },
                  current_line_blame = astra_mode == "pro",
                  current_line_blame_opts = { delay = 500 },
                }
                end,
              },
              {
                "numToStr/Comment.nvim",
                event = "BufReadPre",
                enabled = astra_mode ~= "beginner",
                config = function()
                local ok, comment = pcall(require, "Comment")
                if not ok then
                  log_error("Failed to load Comment.nvim: " .. tostring(comment))
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
                  log_error("Failed to load zen-mode: " .. tostring(zen_mode))
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
                enabled = astra_mode ~= "beginner",
                config = function()
                local ok, autopairs = pcall(require, "nvim-autopairs")
                if not ok then
                  log_error("Failed to load nvim-autopairs: " .. tostring(autopairs))
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
                enabled = astra_mode ~= "beginner",
                config = function()
                local ok, trouble = pcall(require, "trouble")
                if not ok then
                  log_error("Failed to load trouble: " .. tostring(trouble))
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
                  log_error("Failed to load persistence: " .. tostring(persistence))
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
                      require("base46").load_all_highlights()
                      end
                      end,
                  })
                  end,
              },
              {
                "echasnovski/mini.nvim",
                event = "VeryLazy",
                enabled = astra_mode ~= "beginner",
                config = function()
                local ok_animate, animate = pcall(require, "mini.animate")
                if not ok_animate then
                  log_error("Failed to load mini.animate: " .. tostring(animate))
                  return
                  end
                  animate.setup({
                    cursor = { enable = false },
                    scroll = { enable = astra_mode == "pro" },
                    resize = { enable = astra_mode == "pro" },
                    open = { enable = astra_mode == "pro" },
                    close = { enable = astra_mode == "pro" },
                  })
                  local ok_indentscope, indentscope = pcall(require, "mini.indentscope")
                  if not ok_indentscope then
                    log_error("Failed to load mini.indentscope: " .. tostring(indentscope))
                    else
                      indentscope.setup()
                      end
                      local ok_clue, clue = pcall(require, "mini.clue")
                      if not ok_clue then
                        log_error("Failed to load mini.clue: " .. tostring(clue))
                        else
                          clue.setup()
                          end
                          end,
              },
            }

            -- Load Plugins with Optimized Settings
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

            -- Keybindings (Merged AstraVim and NvChad)
            local keymap = vim.keymap.set
            local opts = { silent = true }

            -- General
            keymap("n", "<Esc>", ":noh<CR>", { desc = "Clear highlights", silent = true })
            keymap("n", "<C-s>", ":w<CR>", { desc = "Save", silent = true })
            keymap("n", "<Leader>w", ":w<CR>", { desc = "Save", silent = true })
            keymap("n", "<Leader>q", ":q<CR>", { desc = "Quit", silent = true })
            keymap("n", "<Leader>W", ":wa<CR>", { desc = "Save all", silent = true })
            keymap("n", "<Leader>Q", ":qa<CR>", { desc = "Quit all", silent = true })
            keymap("n", "<C-c>", ":%y+<CR>", { desc = "Copy whole file", silent = true })
            keymap("n", "<leader>n", ":set nu!<CR>", { desc = "Toggle line number", silent = true })
            keymap("n", "<leader>rn", ":set rnu!<CR>", { desc = "Toggle relative number", silent = true })

            -- Window Navigation (NvChad)
            keymap("n", "<C-h>", "<C-w>h", { desc = "Switch window left", silent = true })
            keymap("n", "<C-l>", "<C-w>l", { desc = "Switch window right", silent = true })
            keymap("n", "<C-j>", "<C-w>j", { desc = "Switch window down", silent = true })
            keymap("n", "<C-k>", "<C-w>k", { desc = "Switch window up", silent = true })

            -- Insert Mode Navigation (NvChad)
            keymap("i", "<C-b>", "<ESC>^i", { desc = "Move beginning of line", silent = true })
            keymap("i", "<C-e>", "<End>", { desc = "Move end of line", silent = true })
            keymap("i", "<C-h>", "<Left>", { desc = "Move left", silent = true })
            keymap("i", "<C-l>", "<Right>", { desc = "Move right", silent = true })
            keymap("i", "<C-j>", "<Down>", { desc = "Move down", silent = true })
            keymap("i", "<C-k>", "<Up>", { desc = "Move up", silent = true })

            -- Nvim-tree
            if astra_mode ~= "beginner" then
              keymap("n", "<C-n>", "<cmd>NvimTreeToggle<CR>", { desc = "Toggle file explorer", silent = true })
              keymap("n", "<Leader>e", "<cmd>NvimTreeFocus<CR>", { desc = "Focus file explorer", silent = true })
              keymap("n", "<Leader>E", "<cmd>NvimTreeFindFile<CR>", { desc = "Reveal file", silent = true })
              end

              -- Telescope
              if astra_mode ~= "beginner" then
                keymap("n", "<Leader>ff", "<cmd>Telescope find_files<CR>", { desc = "Find files", silent = true })
                keymap("n", "<Leader>fa", "<cmd>Telescope find_files follow=true no_ignore=true hidden=true<CR>", { desc = "Find all files", silent = true })
                keymap("n", "<Leader>fw", "<cmd>Telescope live_grep<CR>", { desc = "Live grep", silent = true })
                keymap("n", "<Leader>fb", "<cmd>Telescope buffers<CR>", { desc = "Find buffers", silent = true })
                keymap("n", "<Leader>fo", "<cmd>Telescope oldfiles<CR>", { desc = "Find oldfiles", silent = true })
                keymap("n", "<Leader>fz", "<cmd>Telescope current_buffer_fuzzy_find<CR>", { desc = "Find in current buffer", silent = true })
                keymap("n", "<Leader>cm", "<cmd>Telescope git_commits<CR>", { desc = "Git commits", silent = true })
                keymap("n", "<Leader>gt", "<cmd>Telescope git_status<CR>", { desc = "Git status", silent = true })
                keymap("n", "<Leader>fp", "<cmd>Telescope project<CR>", { desc = "Find projects", silent = true })
                keymap("n", "<Leader>fr", "<cmd>Telescope resume<CR>", { desc = "Resume last search", silent = true })
                keymap("n", "<Leader>pp", "<cmd>Telescope projects<CR>", { desc = "Project Dashboard", silent = true })
                keymap("n", "<Leader>fh", "<cmd>Telescope help_tags<CR>", { desc = "Help page", silent = true })
                keymap("n", "<Leader>ma", "<cmd>Telescope marks<CR>", { desc = "Find marks", silent = true })
                end
                if astra_mode == "pro" then
                  keymap("n", "<Leader>fd", "<cmd>Telescope dap commands<CR>", { desc = "DAP commands", silent = true })
                  end

                  -- LSP
                  if astra_mode ~= "beginner" then
                    keymap("n", "K", "<cmd>Lspsaga hover_doc<CR>", { desc = "Hover doc", silent = true })
                    keymap("n", "gd", "<cmd>Lspsaga goto_definition<CR>", { desc = "Go to definition", silent = true })
                    keymap("n", "gr", "<cmd>Lspsaga finder<CR>", { desc = "Find references", silent = true })
                    keymap("n", "<Leader>ca", "<cmd>Lspsaga code_action<CR>", { desc = "Code action", silent = true })
                    keymap("n", "<Leader>rn", "<cmd>Lspsaga rename<CR>", { desc = "Rename", silent = true })
                    keymap("n", "<Leader>lf", "<cmd>lua vim.lsp.buf.format({ async = true })<CR>", { desc = "Format", silent = true })
                    keymap("n", "<Leader>ld", "<cmd>Trouble document_diagnostics<CR>", { desc = "Document diagnostics", silent = true })
                    keymap("n", "<Leader>lw", "<cmd>Trouble workspace_diagnostics<CR>", { desc = "Workspace diagnostics", silent = true })
                    keymap("n", "<Leader>ds", vim.diagnostic.setloclist, { desc = "LSP diagnostic loclist", silent = true })
                    end

                    -- Debugging
                    if astra_mode == "pro" then
                      keymap("n", "<Leader>dt", "<cmd>lua require'dap'.toggle_breakpoint()<CR>", { desc = "Toggle breakpoint", silent = true })
                      keymap("n", "<Leader>dc", "<cmd>lua require'dap'.continue()<CR>", { desc = "Continue", silent = true })
                      keymap("n", "<Leader>du", "<cmd>lua require'dapui'.toggle()<CR>", { desc = "Toggle DAP UI", silent = true })
                      keymap("n", "<Leader>ds", "<cmd>lua require'dap'.step_over()<CR>", { desc = "Step over", silent = true })
                      keymap("n", "<Leader>di", "<cmd>lua require'dap'.step_into()<CR>", { desc = "Step into", silent = true })
                      keymap("n", "<Leader>do", "<cmd>lua require'dap'.step_out()<CR>", { desc = "Step out", silent = true })
                      end

                      -- Testing
                      if astra_mode == "pro" then
                        keymap("n", "<Leader>tt", "<cmd>Neotest run<CR>", { desc = "Run nearest test", silent = true })
                        keymap("n", "<Leader>tf", "<cmd>Neotest run file<CR>", { desc = "Run test file", silent = true })
                        keymap("n", "<Leader>ts", "<cmd>Neotest summary<CR>", { desc = "Test summary", silent = true })
                        end

                        -- Jupyter
                        if astra_mode == "pro" then
                          keymap("n", "<Leader>jr", "<cmd>JupyterRunFile<CR>", { desc = "Run Jupyter file", silent = true })
                          keymap("n", "<Leader>jc", "<cmd>JupyterConnect<CR>", { desc = "Connect to Jupyter", silent = true })
                          keymap("n", "<Leader>jm", "<cmd>MagmaEvaluateOperator<CR>", { desc = "Evaluate with Magma", silent = true })
                          keymap("v", "<Leader>jm", ":<C-u>MagmaEvaluateVisual<CR>", { desc = "Evaluate selection with Magma", silent = true })
                          end

                          -- Tabufline (NvChad)
                          keymap("n", "<Leader>b", "<cmd>enew<CR>", { desc = "New buffer", silent = true })
                          keymap("n", "<tab>", function()
                          require("nvchad.tabufline").next()
                          end, { desc = "Next buffer", silent = true })
                          keymap("n", "<S-tab>", function()
                          require("nvchad.tabufline").prev()
                          end, { desc = "Previous buffer", silent = true })
                          keymap("n", "<Leader>x", function()
                          require("nvchad.tabufline").close_buffer()
                          end, { desc = "Close buffer", silent = true })

                          -- Comment (NvChad)
                          if astra_mode ~= "beginner" then
                            keymap("n", "<Leader>/", "gcc", { desc = "Toggle comment", remap = true })
                            keymap("v", "<Leader>/", "gc", { desc = "Toggle comment", remap = true })
                            end

                            -- Terminal (NvChad)
                            keymap("t", "<C-x>", "<C-\\><C-N>", { desc = "Escape terminal mode", silent = true })
                            if astra_mode == "pro" then
                              keymap("n", "<Leader>h", function()
                              require("nvchad.term").new { pos = "sp" }
                              end, { desc = "New horizontal term", silent = true })
                              keymap("n", "<Leader>v", function()
                              require("nvchad.term").new { pos = "vsp" }
                              end, { desc = "New vertical term", silent = true })
                              keymap({ "n", "t" }, "<A-v>", function()
                              require("nvchad.term").toggle { pos = "vsp", id = "vtoggleTerm" }
                              end, { desc = "Toggle vertical term", silent = true })
                              keymap({ "n", "t" }, "<A-h>", function()
                              require("nvchad.term").toggle { pos = "sp", id = "htoggleTerm" }
                              end, { desc = "Toggle horizontal term", silent = true })
                              keymap({ "n", "t" }, "<A-i>", function()
                              require("nvchad.term").toggle { pos = "float", id = "floatTerm" }
                              end, { desc = "Toggle floating term", silent = true })
                              end

                              -- WhichKey
                              keymap("n", "<Leader>wK", "<cmd>WhichKey<CR>", { desc = "WhichKey all keymaps", silent = true })
                              keymap("n", "<Leader>wk", function()
                              vim.cmd("WhichKey " .. vim.fn.input("WhichKey: "))
                              end, { desc = "WhichKey query lookup", silent = true })

                              -- Zen Mode
                              keymap("n", "<Leader>z", "<cmd>ZenMode<CR>", { desc = "Toggle Zen Mode", silent = true })

                              -- Session Management
                              keymap("n", "<Leader>ss", "<cmd>lua require('persistence').save()<CR>", { desc = "Save session", silent = true })
                              keymap("n", "<Leader>sl", "<cmd>lua require('persistence').load()<CR>", { desc = "Load session", silent = true })

                              -- Mode Switching
                              keymap("n", "<Leader>mb", "<cmd>AstraModeBeginner<CR>", { desc = "Beginner Mode", silent = true })
                              keymap("n", "<Leader>ma", "<cmd>AstraModeAdvanced<CR>", { desc = "Advanced Mode", silent = true })
                              keymap("n", "<Leader>mp", "<cmd>AstraModePro<CR>", { desc = "Pro Mode", silent = true })

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

                              -- Optimize Startup
                              vim.defer_fn(function()
                              vim.cmd("syntax sync minlines=200")
                              vim.opt.foldmethod = "expr"
                              vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
                              vim.opt.foldenable = false
                              end, 0)

                              -- Preserve the original vim.notify
                              local original_notify = vim.notify

                              -- Custom notify function to suppress which-key warnings
                              vim.notify = function(msg, level, opts)
                              if level == vim.log.levels.WARN and msg:match("which%-key") then
                                log_error("Suppressed which-key warning: " .. msg)
                                return
                                end
                                original_notify(msg, level, opts)
                                end

                                -- Add Mason binaries to PATH (NvChad)
                                local is_windows = vim.fn.has("win32") ~= 0
                                local sep = is_windows and "\\" or "/"
                                local delim = is_windows and ";" or ":"
                                vim.env.PATH = table.concat({ vim.fn.stdpath("data"), "mason", "bin" }, sep) .. delim .. vim.env.PATH

                                -- Documentation
                                -- Getting Started:
                                -- 1. Ensure dependencies: `ripgrep`, `python3`, `node`, `make` (optional for fzf).
                                -- 2. Install plugins: Run `:Lazy sync` after starting Neovim.
                                -- 3. Switch modes: `<Leader>mb` (Beginner), `<Leader>ma` (Advanced), `<Leader>mp` (Pro).
                                -- 4. ML workflows: Use `:RunPlateDetection`, `:TrainPlateModel`, `:TrainYOLO`, `:VisualizeYOLO` for vehicle number plate detection.
                                -- 5. Edit config: `:AstraVimConfig` to modify this file.
                                -- Key Plugins:
                                -- - lazy.nvim: Plugin manager with lazy-loading.
                                -- - tokyonight.nvim: Theme with day/storm/night variants.
                                -- - nvchad/base46: Theme integration for UI components.
                                -- - nvchad/ui: Statusline and tabufline (NvChad style).
                                -- - alpha-nvim: Animated dashboard (Pro mode).
                                -- - nvim-cmp: Autocompletion with Copilot/TabNine (Pro mode).
                                -- - nvim-lspconfig: Language server support (Advanced/Pro).
                                -- - nvim-treesitter: Syntax highlighting and navigation (Advanced/Pro).
                                -- - telescope.nvim: Fuzzy finder for files, projects, and more (Advanced/Pro).
                                -- - nvim-dap: Debugging for Python/JS (Pro mode).
                                -- - neotest: Testing with pytest (Pro mode).
                                -- - jupyter-nvim/magma-nvim: Jupyter notebook support (Pro mode).
