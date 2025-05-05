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
    file_sorter = require("telescope.sorters").get_fuzzy_file, -- Better file sorting
    file_previewer = require("telescope.previewers").vim_buffer_cat.new, -- Enable file preview
  },
})
require("telescope").load_extension("fzf")
