-- ~/.config/nvim/lua/plugins/telescope.lua
-- Fuzzy finder configuration

require("telescope").setup({
    defaults = {
      prompt_prefix = "🔍 ",
      selection_caret = "➤ ",
      layout_strategy = "horizontal",
      layout_config = {
        horizontal = { width = 0.9, preview_width = 0.6 },
      },
      mappings = {
        i = {
          ["<C-j>"] = require("telescope.actions").move_selection_next,
          ["<C-k>"] = require("telescope.actions").move_selection_previous,
        },
      },
    },
  })
  require("telescope").load_extension("fzf")