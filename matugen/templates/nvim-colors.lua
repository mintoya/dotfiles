--[[
-- Generated with Matugen
--]]

local Colors = {
  <* for name, value in colors *>
      {{name}} = "{{value.default.hex}}",
  <* endfor *>
}

return Colors
