-- ~/.config/nvim/lua/plugins/lsp.lua
-- LSP configuration with improved attachment reliability

-- Setup neodev for better Lua LSP support
local ok, neodev = pcall(require, "neodev")
if not ok then
  _G.log_error("Failed to load neodev: " .. tostring(neodev))
  return
end
neodev.setup()

-- Setup Mason for LSP server management
local ok, mason = pcall(require, "mason")
if not ok then
  _G.log_error("Failed to load mason: " .. tostring(mason))
  return
end
mason.setup({
  ui = {
    border = "rounded",
    icons = {
      package_pending = " ",
      package_installed = " ",
      package_uninstalled = " ",
    },
  },
  max_concurrent_installers = 10,
  log_level = vim.log.levels.DEBUG, -- Enable debug logging for Mason
})

-- Setup Mason-LSPConfig to bridge Mason and LSPConfig
local ok, mason_lspconfig = pcall(require, "mason-lspconfig")
if not ok then
  _G.log_error("Failed to load mason-lspconfig: " .. tostring(mason_lspconfig))
  return
end
mason_lspconfig.setup({
  ensure_installed = {
    "lua_ls", "pyright", "tsserver", "rust_analyzer", "gopls",
    "jsonls", "yamlls", "html", "cssls", "bashls", "clangd",
  },
  automatic_installation = true,
})

-- Setup Lspsaga for enhanced LSP UI
local ok, lspsaga = pcall(require, "lspsaga")
if not ok then
  _G.log_error("Failed to load lspsaga: " .. tostring(lspsaga))
  return
end
lspsaga.setup({
  ui = { border = "rounded", code_action_icon = "💡" },
  symbol_in_winbar = { enable = true },
  code_action = { num_shortcut = true, show_server_name = true },
  lightbulb = { enable = true, sign = true, virtual_text = false },
  rename = { in_select = false },
})

-- Define LSP capabilities with autocompletion support
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)
capabilities.textDocument.completion.completionItem.snippetSupport = true
capabilities.textDocument.completion.completionItem.resolveSupport = {
  properties = { "documentation", "detail", "additionalTextEdits" },
}
capabilities.textDocument.foldingRange = {
  dynamicRegistration = false,
  lineFoldingOnly = true,
}

-- Diagnostic signs
local signs = { Error = " ", Warn = " ", Hint = "󰌵 ", Info = " " }
for type, icon in pairs(signs) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end
vim.diagnostic.config({
  virtual_text = { prefix = "●", spacing = 4, source = "if_many" },
  signs = true,
  update_in_insert = false,
  severity_sort = true,
  float = { border = "rounded", source = "always" },
})
-- changed here -------------------------------------------
vim.api.nvim_create_user_command("ToggleDiagnostics", function()
  local current = vim.diagnostic.config().virtual_text
  vim.diagnostic.config({ virtual_text = not current })
  vim.notify("Diagnostics virtual text " .. (current and "disabled" or "enabled"), vim.log.levels.INFO)
end, { desc = "Toggle diagnostics virtual text" })

-- Setup LSP servers
local lspconfig = require("lspconfig")
mason_lspconfig.setup_handlers({
  -- Default handler for all servers
  function(server_name)
    lspconfig[server_name].setup({
      capabilities = capabilities,
      on_attach = function(client, bufnr)
        -- Log successful attachment
        _G.log_error("LSP attached: " .. server_name .. " to buffer " .. bufnr)

        -- Enable semantic tokens
        client.server_capabilities.semanticTokensProvider = {
          full = true,
          legend = {
            tokenTypes = { "keyword", "string", "number", "variable", "function", "method", "class", "interface" },
            tokenModifiers = { "declaration", "definition", "readonly", "static", "deprecated" },
          },
        }

        -- Keybindings are handled in core/mappings.lua
      end,
      handlers = {
        ["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" }),
        ["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = "rounded" }),
      },
    })
  end,
  -- Specific configuration for lua_ls
  ["lua_ls"] = function()
    lspconfig.lua_ls.setup({
      capabilities = capabilities,
      on_attach = function(client, bufnr)
        _G.log_error("LSP attached: lua_ls to buffer " .. bufnr)
        client.server_capabilities.semanticTokensProvider = {
          full = true,
          legend = {
            tokenTypes = { "keyword", "string", "number", "variable", "function", "method" },
            tokenModifiers = { "declaration", "definition" },
          },
        }
      end,
      settings = {
        Lua = {
          runtime = { version = "LuaJIT" },
          diagnostics = { globals = { "vim" } },
          workspace = { checkThirdParty = false },
          telemetry = { enable = false },
        },
      },
    })
  end,
  -- Specific configuration for pyright
  ["pyright"] = function()
    lspconfig.pyright.setup({
      capabilities = capabilities,
      on_attach = function(client, bufnr)
        _G.log_error("LSP attached: pyright to buffer " .. bufnr)
        client.server_capabilities.semanticTokensProvider = {
          full = true,
          legend = {
            tokenTypes = { "keyword", "string", "number", "variable", "function", "method", "class" },
            tokenModifiers = { "declaration", "definition" },
          },
        }
      end,
      settings = {
        python = {
          analysis = {
            autoSearchPaths = true,
            useLibraryCodeForTypes = true,
            diagnosticMode = "workspace",
          },
        },
      },
    })
  end,
})

-- Log LSP errors for debugging
vim.lsp.handlers["window/logMessage"] = function(_, result, ctx)
  if result.type == vim.lsp.log_levels.ERROR then
    _G.log_error("LSP Error: " .. result.message .. " (client: " .. ctx.client_id .. ")")
  end
end