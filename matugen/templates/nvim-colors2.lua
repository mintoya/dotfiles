local c = {
  bg = "{{colors.background.default.hex}}",
  fg = "{{colors.on_surface.default.hex}}",
  cursor = "{{colors.primary.default.hex}}",
  border = "{{colors.primary.default.hex}}",
  -- selection-background = {{colors.secondary_container.default.hex}},
  -- selection-foreground = {{colors.on_secondary_container.default.hex}},
  color0 = "{{colors.surface_container_high.default.hex}}",
  color1 = "{{colors.error.default.hex}}",
  color2 = "{{colors.primary.default.hex}}",
  color3 = "{{colors.tertiary.default.hex}}",
  color4 = "{{colors.secondary.default.hex}}",
  color5 = "{{colors.primary_fixed.default.hex}}",
  color6 = "{{colors.secondary_fixed.default.hex}}",
  color7 = "{{colors.on_surface_variant.default.hex}}",
  color8 = "{{colors.outline.default.hex}}",
  color9 = "{{colors.error_container.default.hex}}",
  color10 = "{{colors.primary_container.default.hex}}",
  color11 = "{{colors.tertiary_container.default.hex}}",
  color12 = "{{colors.secondary_container.default.hex}}",
  color13 = "{{colors.inverse_primary.default.hex}}",
  color14 = "{{colors.outline_variant.default.hex}}",
  color15 = "{{colors.on_surface.default.hex}}",
}
local colorfn = require "special".color

---@param hex string hex color
---@param percent number less than 1
---@return string hex color
local function darkenHex(hex, percent)
  percent   = percent or 10
  local hsv = colorfn.hsv(colorfn.str2rgb(hex))
  hsv.v     = hsv.v * (1 - percent)
  -- hsv.s     = math.min(1, hsv.s * (1.1))
  return colorfn.rgb2str(colorfn.rgb(hsv))
end
c.bg = "none"

local M = {}

M.highlights = {
  ColorColumn    = { bg = c.color0 },
  Cursor         = { fg = c.bg, bg = c.cursor },
  CursorColumn   = { bg = darkenHex(c.color1, .5) },
  CursorLine     = { bg = darkenHex(c.color1, .5) },
  CursorLineNr   = { fg = c.color8 },
  DiffAdd        = { bg = c.color2, bold = true },
  DiffChange     = { bg = c.color3, italic = true },
  DiffDelete     = { fg = c.color1, bg = "none", bold = true },
  DiffText       = { bg = c.color4, bold = true },
  Directory      = { fg = c.color15 },
  ErrorMsg       = { fg = c.color1, bg = c.color0, bold = true },
  FoldColumn     = { fg = c.color8, bg = c.bg },
  Folded         = { bg = darkenHex(c.color12, .8), italic = true },
  IncSearch      = { fg = c.color0, bg = c.color3, bold = true },
  LineNr         = { fg = c.color8 },
  MatchParen     = { fg = c.color6, bold = true },
  MoreMsg        = { fg = c.color4 },
  NonText        = { fg = c.color8 },
  Normal         = { fg = c.fg, bg = c.bg },
  NormalNC       = { fg = c.fg, bg = c.bg },
  Float          = { fg = c.color13, bg = "none" },
  FloatBorder    = { fg = c.color13, bg = "none" },
  NormalFloat    = { fg = c.color13, bg = "none" },
  Pmenu          = { fg = c.color13, bg = "none" },
  PmenuSel       = { fg = c.color12, bg = c.color0, bold = true },
  PmenuSbar      = { bg = c.cursor },
  PmenuThumb     = { bg = c.cursor },
  Question       = { fg = c.color6 },
  Search         = { fg = c.color0, bg = c.color3, bold = true },
  SignColumn     = { fg = c.fg, bg = c.bg },
  StatusLine     = { fg = c.fg, bg = "none" },
  StatusLineNC   = { fg = c.color8, bg = "none" },
  Title          = { fg = c.color4, bold = true },
  Underlined     = { underline = true },
  VertSplit      = { fg = c.color8, bg = c.bg },
  Visual         = { bg = c.color14, fg = "black" },
  WarningMsg     = { fg = c.color11, bold = true },
  WildMenu       = { fg = c.color7, bg = c.color3, bold = true },
  -- Language syntax
  Boolean        = { fg = c.color3 },
  Character      = { fg = c.color7 },
  Comment        = { fg = c.color2, italic = true },
  Conditional    = { fg = c.color5 },
  Constant       = { fg = c.color3, bold = true },
  Define         = { fg = c.color10 },
  Error          = { fg = c.color1, bg = c.color0, bold = true },
  Function       = { fg = c.color4 },
  Identifier     = { fg = c.color9 },
  Keyword        = { fg = c.color5, italic = true },
  Label          = { fg = c.color3 },
  Number         = { fg = c.color7 },
  Operator       = { fg = c.color9, bold = true },
  PreCondit      = { fg = c.color6 },
  PreProc        = { fg = c.color12, italic = true },
  Repeat         = { fg = c.color4 },
  Special        = { fg = c.color14, bold = true },
  SpecialComment = { fg = c.color13, italic = true },
  SpecialKey     = { fg = c.color6 },
  SpellBad       = { fg = c.color1, underline = true },
  SpellCap       = { fg = c.color11 },
  SpellRare      = { fg = c.color8 },
  SpellLocal     = { fg = c.color12 },
  Statement      = { fg = c.color11, bold = true },
  StorageClass   = { fg = c.color14 },
  String         = { fg = c.color10, italic = true },
  Structure      = { fg = c.color7 },
  Tag            = { fg = c.color3, bold = true },
  Todo           = { fg = c.color15, bg = c.color0, bold = true, italic = true },
  Type           = { fg = c.color10, bold = true },
  MiniJump       = { undercurl = true },

  -- Pick           = { fg = c.color1, bg = "none" },
}

vim.g.colors_name = "cwal"
vim.cmd("highlight clear")
vim.cmd("set background=dark")
vim.cmd("syntax reset")

for group, opts in pairs(M.highlights) do
  vim.api.nvim_set_hl(0, group, opts)
end

return M
