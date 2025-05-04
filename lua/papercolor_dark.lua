-- Copyright (c) 2020-2021 shadmansaleh
-- MIT license, see LICENSE for more details.
-- Modified to match TokyoNight color scheme with Command mode in orange
-- stylua: ignore
local colors = {
  bg_dark    = '#1a1b26', -- Darkest background (TokyoNight night background)
  bg_light   = '#24283b', -- Lighter background for sections
  fg_light   = '#c0caf5', -- Light foreground for text
  blue       = '#7aa2f7', -- Blue for normal mode
  green      = '#9ece6a', -- Green for insert mode
  purple     = '#bb9af7', -- Purple for visual mode
  red        = '#f7768e', -- Red for replace mode
  gray       = '#565f89', -- Muted gray for inactive sections
  orange     = '#ff9e64', -- Orange for command mode
}

return {
  normal = {
    a = { fg = colors.bg_dark, bg = colors.blue, gui = 'bold' }, -- Blue background for normal mode
    b = { fg = colors.fg_light, bg = colors.bg_light },
    c = { fg = colors.fg_light, bg = colors.bg_dark },
  },
  insert = {
    a = { fg = colors.bg_dark, bg = colors.green, gui = 'bold' }, -- Green background for insert mode
    b = { fg = colors.fg_light, bg = colors.bg_light },
  },
  visual = {
    a = { fg = colors.bg_dark, bg = colors.purple, gui = 'bold' }, -- Purple background for visual mode
    b = { fg = colors.fg_light, bg = colors.bg_light },
  },
  replace = {
    a = { fg = colors.bg_dark, bg = colors.red, gui = 'bold' }, -- Red background for replace mode
    b = { fg = colors.fg_light, bg = colors.bg_light },
  },
  command = {
    a = { fg = colors.bg_dark, bg = colors.orange, gui = 'bold' }, -- Orange background for command mode
    b = { fg = colors.fg_light, bg = colors.bg_light },
    c = { fg = colors.fg_light, bg = colors.bg_dark },
  },
  inactive = {
    a = { fg = colors.gray, bg = colors.bg_dark, gui = 'bold' }, -- Muted gray for inactive sections
    b = { fg = colors.gray, bg = colors.bg_dark },
    c = { fg = colors.gray, bg = colors.bg_dark },
  },
}
