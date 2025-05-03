-- ~/.config/nvim/lua/core/mappings.lua
-- Keybindings for AstraVim

local keymap = vim.keymap.set
local opts = { silent = true }

-- General mappings
keymap("n", "<Esc>", ":noh<CR>", { desc = "Clear highlights", silent = true })
keymap("n", "<C-s>", ":w<CR>", { desc = "Save", silent = true })
keymap("n", "<Leader>w", ":w<CR>", { desc = "Save", silent = true })
keymap("n", "<Leader>q", ":q<CR>", { desc = "Quit", silent = true })
keymap("n", "<Leader>W", ":wa<CR>", { desc = "Save all", silent = true })
keymap("n", "<Leader>Q", ":qa<CR>", { desc = "Quit all", silent = true })
keymap("n", "<C-c>", ":%y+<CR>", { desc = "Copy whole file", silent = true })
keymap("n", "<leader>n", ":set nu!<CR>", { desc = "Toggle line number", silent = true })
keymap("n", "<leader>rn", ":set rnu!<CR>", { desc = "Toggle relative number", silent = true })

-------------- changed -----------
keymap("n", "<Leader>dt", "<cmd>ToggleDiagnostics<CR>", { desc = "Toggle diagnostics", silent = true })
keymap("n", "<Leader>cs", "<cmd>AstraCheatSheet<CR>", { desc = "View cheat sheet", silent = true })
keymap("n", "<Leader>tt", "<cmd>ToggleTheme<CR>", { desc = "Toggle theme", silent = true })






-- Window navigation
keymap("n", "<C-h>", "<C-w>h", { desc = "Switch window left", silent = true })
keymap("n", "<C-l>", "<C-w>l", { desc = "Switch window right", silent = true })
keymap("n", "<C-j>", "<C-w>j", { desc = "Switch window down", silent = true })
keymap("n", "<C-k>", "<C-w>k", { desc = "Switch window up", silent = true })

-- Insert mode navigation
keymap("i", "<C-b>", "<ESC>^i", { desc = "Move beginning of line", silent = true })
keymap("i", "<C-e>", "<End>", { desc = "Move end of line", silent = true })
keymap("i", "<C-h>", "<Left>", { desc = "Move left", silent = true })
keymap("i", "<C-l>", "<Right>", { desc = "Move right", silent = true })
keymap("i", "<C-j>", "<Down>", { desc = "Move down", silent = true })
keymap("i", "<C-k>", "<Up>", { desc = "Move up", silent = true })

-- Nvim-tree (file explorer)
if vim.g.astra_mode ~= "beginner" then
  keymap("n", "<C-n>", "<cmd>NvimTreeToggle<CR>", { desc = "Toggle file explorer", silent = true })
  keymap("n", "<Leader>e", "<cmd>NvimTreeFocus<CR>", { desc = "Focus file explorer", silent = true })
  keymap("n", "<Leader>E", "<cmd>NvimTreeFindFile<CR>", { desc = "Reveal file", silent = true })
end

-- Telescope (fuzzy finder)
if vim.g.astra_mode ~= "beginner" then
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
if vim.g.astra_mode == "pro" then
  keymap("n", "<Leader>fd", "<cmd>Telescope dap commands<CR>", { desc = "DAP commands", silent = true })
end

-- LSP mappings
if vim.g.astra_mode ~= "beginner" then
  keymap("n", "K", "<cmd>Lspsaga hover_doc<CR>", { desc = "Hover doc", silent = true })
  keymap("n", "gd", "<cmd>Lspsaga goto_definition<CR>", { desc = "Go to definition", silent = true })
  keymap("n", "gr", "<cmd>Lspsaga finder<CR>", { desc = "Find references", silent = true })
  keymap("n", "<Leader>ca", "<cmd>Lspsaga code_action<CR>", { desc = "Code action", silent = true })
  keymap("n", "<Leader>rn", "<cmd>Lspsaga rename<CR>", { desc = "Rename", silent = true }) -- Removed <Leader>ra to avoid conflict
  keymap("n", "<Leader>lf", "<cmd>lua vim.lsp.buf.format({ async = true })<CR>", { desc = "Format", silent = true })
  keymap("n", "<Leader>ld", "<cmd>Trouble document_diagnostics<CR>", { desc = "Document diagnostics", silent = true })
  keymap("n", "<Leader>lw", "<cmd>Trouble workspace_diagnostics<CR>", { desc = "Workspace diagnostics", silent = true })
  keymap("n", "<Leader>ds", vim.diagnostic.setloclist, { desc = "LSP diagnostic loclist", silent = true })
end

-- Debugging (DAP)
if vim.g.astra_mode == "pro" then
  keymap("n", "<Leader>dt", "<cmd>lua require'dap'.toggle_breakpoint()<CR>", { desc = "Toggle breakpoint", silent = true })
  keymap("n", "<Leader>dc", "<cmd>lua require'dap'.continue()<CR>", { desc = "Continue", silent = true })
  keymap("n", "<Leader>du", "<cmd>lua require'dapui'.toggle()<CR>", { desc = "Toggle DAP UI", silent = true })
  keymap("n", "<Leader>ds", "<cmd>lua require'dap'.step_over()<CR>", { desc = "Step over", silent = true })
  keymap("n", "<Leader>di", "<cmd>lua require'dap'.step_into()<CR>", { desc = "Step into", silent = true })
  keymap("n", "<Leader>do", "<cmd>lua require'dap'.step_out()<CR>", { desc = "Step out", silent = true }) -- Removed <Leader>dO to avoid redundancy
end

-- Testing (Neotest)
if vim.g.astra_mode == "pro" then
  keymap("n", "<Leader>tt", "<cmd>Neotest run<CR>", { desc = "Run nearest test", silent = true })
  keymap("n", "<Leader>tf", "<cmd>Neotest run file<CR>", { desc = "Run test file", silent = true })
  keymap("n", "<Leader>ts", "<cmd>Neotest summary<CR>", { desc = "Test summary", silent = true })
end

-- Jupyter (Pro mode)
if vim.g.astra_mode == "pro" then
  keymap("n", "<Leader>jr", "<cmd>JupyterRunFile<CR>", { desc = "Run Jupyter file", silent = true })
  keymap("n", "<Leader>jc", "<cmd>JupyterConnect<CR>", { desc = "Connect to Jupyter", silent = true })
  keymap("n", "<Leader>jm", "<cmd>MagmaEvaluateOperator<CR>", { desc = "Evaluate with Magma", silent = true })
  keymap("v", "<Leader>jm", ":<C-u>MagmaEvaluateVisual<CR>", { desc = "Evaluate selection with Magma", silent = true })
end

-- Comment toggling
if vim.g.astra_mode ~= "beginner" then
  keymap("n", "<Leader>/", "gcc", { desc = "Toggle comment", remap = true })
  keymap("v", "<Leader>/", "gc", { desc = "Toggle comment", remap = true })
end

-- Terminal (using toggleterm instead of nvchad.term)
if vim.g.astra_mode == "pro" then
  keymap("t", "<C-x>", "<C-\\><C-N>", { desc = "Escape terminal mode", silent = true })
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