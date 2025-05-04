-- ~/.config/nvim/lua/plugins/alpha.lua
-- Dashboard configuration

local alpha = require("alpha")
local dashboard = require("alpha.themes.dashboard")

dashboard.section.header.val = {
  "          🌌 N E O V I M   I D E 🌌          ",
  "  ╔═══════════════════════════════════╗  ",
  "  ║ ███╗   ██╗███████╗ ██████╗ ██╗   ║  ",
  "  ║ ████╗  ██║██╔════╝██╔═══██╗██║   ║  ",
  "  ║ ██╔██╗ ██║█████╗  ██║   ██║██║   ║  ",
  "  ║ ██║╚██╗██║██╔══╝  ██║   ██║██║   ║  ",
  "  ║ ██║ ╚████║███████╗╚██████╔╝██║   ║  ",
  "  ║ ╚═╝  ╚═══╝╚══════╝ ╚═════╝ ╚═╝   ║  ",
  "  ╚═══════════════════════════════════╝  ",
  "      Powered by xAI - May 2025 🚀      ",
}
dashboard.section.header.opts.hl = "Title"

dashboard.section.buttons.val = {
  dashboard.button("e", "📝 New File", ":ene <BAR> startinsert<CR>"),
  dashboard.button("f", "🔍 Find File", ":Telescope find_files<CR>"),
  dashboard.button("r", "🕒 Recent Files", ":Telescope oldfiles<CR>"),
  dashboard.button("q", "🚪 Quit", ":qa<CR>"),
}
dashboard.section.footer.val = "🌌 Code with Speed and Clarity"
dashboard.section.footer.opts.hl = "Comment"

alpha.setup(dashboard.opts)