--
-- json.lua
--
-- Copyright (c) 2020 rxi
--
-- Permission is hereby granted, free of charge, to any person obtaining a copy of
-- this software and associated documentation files (the "Software"), to deal in
-- the Software without restriction, including without limitation the rights to
-- use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
-- of the Software, and to permit persons to whom the Software is furnished to do
-- so, subject to the following conditions:
--
-- The above copyright notice and this permission notice shall be included in all
-- copies or substantial portions of the Software.
--
-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
-- IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
-- FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
-- AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
-- LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
-- OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
-- SOFTWARE.
--

local json = { _version = "0.1.2" }

-------------------------------------------------------------------------------
-- Encode
-------------------------------------------------------------------------------

local encode

local escape_char_map = {
  ["\\"] = "\\",
  ["\""] = "\"",
  ["\b"] = "b",
  ["\f"] = "f",
  ["\n"] = "n",
  ["\r"] = "r",
  ["\t"] = "t",
}

local escape_char_map_inv = { ["/"] = "/" }
for k, v in pairs(escape_char_map) do
  escape_char_map_inv[v] = k
end


local function escape_char(c)
  return "\\" .. (escape_char_map[c] or string.format("u%04x", c:byte()))
end


local function encode_nil(val)
  return "null"
end


local function encode_table(val, stack)
  local res = {}
  stack = stack or {}

  -- Circular reference?
  if stack[val] then error("circular reference") end

  stack[val] = true

  if rawget(val, 1) ~= nil or next(val) == nil then
    -- Treat as array -- check keys are valid and it is not sparse
    local n = 0
    for k in pairs(val) do
      if type(k) ~= "number" then
        error("invalid table: mixed or invalid key types")
      end
      n = n + 1
    end
    if n ~= #val then
      error("invalid table: sparse array")
    end
    -- Encode
    for i, v in ipairs(val) do
      table.insert(res, encode(v, stack))
    end
    stack[val] = nil
    return "[" .. table.concat(res, ",") .. "]"
  else
    -- Treat as an object
    for k, v in pairs(val) do
      if type(k) ~= "string" then
        error("invalid table: mixed or invalid key types")
      end
      table.insert(res, encode(k, stack) .. ":" .. encode(v, stack))
    end
    stack[val] = nil
    return "{" .. table.concat(res, ",") .. "}"
  end
end


local function encode_string(val)
  return '"' .. val:gsub('[%z\1-\31\\"]', escape_char) .. '"'
end


local function encode_number(val)
  -- Check for NaN, -inf and inf
  if val ~= val or val <= -math.huge or val >= math.huge then
    error("unexpected number value '" .. tostring(val) .. "'")
  end
  return string.format("%.14g", val)
end


local type_func_map = {
  ["nil"] = encode_nil,
  ["table"] = encode_table,
  ["string"] = encode_string,
  ["number"] = encode_number,
  ["boolean"] = tostring,
}


encode = function(val, stack)
  local t = type(val)
  local f = type_func_map[t]
  if f then
    return f(val, stack)
  end
  error("unexpected type '" .. t .. "'")
end


function json.encode(val)
  return (encode(val))
end

-------------------------------------------------------------------------------
-- Decode
-------------------------------------------------------------------------------

local parse

local function create_set(...)
  local res = {}
  for i = 1, select("#", ...) do
    res[select(i, ...)] = true
  end
  return res
end

local space_chars  = create_set(" ", "\t", "\r", "\n")
local delim_chars  = create_set(" ", "\t", "\r", "\n", "]", "}", ",")
local escape_chars = create_set("\\", "/", '"', "b", "f", "n", "r", "t", "u")
local literals     = create_set("true", "false", "null")

local literal_map  = {
  ["true"] = true,
  ["false"] = false,
  ["null"] = nil,
}


local function next_char(str, idx, set, negate)
  for i = idx, #str do
    if set[str:sub(i, i)] ~= negate then
      return i
    end
  end
  return #str + 1
end


local function decode_error(str, idx, msg)
  local line_count = 1
  local col_count = 1
  for i = 1, idx - 1 do
    col_count = col_count + 1
    if str:sub(i, i) == "\n" then
      line_count = line_count + 1
      col_count = 1
    end
  end
  error(string.format("%s at line %d col %d", msg, line_count, col_count))
end


local function codepoint_to_utf8(n)
  -- http://scripts.sil.org/cms/scripts/page.php?site_id=nrsi&id=iws-appendixa
  local f = math.floor
  if n <= 0x7f then
    return string.char(n)
  elseif n <= 0x7ff then
    return string.char(f(n / 64) + 192, n % 64 + 128)
  elseif n <= 0xffff then
    return string.char(f(n / 4096) + 224, f(n % 4096 / 64) + 128, n % 64 + 128)
  elseif n <= 0x10ffff then
    return string.char(f(n / 262144) + 240, f(n % 262144 / 4096) + 128,
      f(n % 4096 / 64) + 128, n % 64 + 128)
  end
  error(string.format("invalid unicode codepoint '%x'", n))
end


local function parse_unicode_escape(s)
  local n1 = tonumber(s:sub(1, 4), 16)
  local n2 = tonumber(s:sub(7, 10), 16)
  -- Surrogate pair?
  if n2 then
    return codepoint_to_utf8((n1 - 0xd800) * 0x400 + (n2 - 0xdc00) + 0x10000)
  else
    return codepoint_to_utf8(n1)
  end
end


local function parse_string(str, i)
  local res = ""
  local j = i + 1
  local k = j

  while j <= #str do
    local x = str:byte(j)

    if x < 32 then
      decode_error(str, j, "control character in string")
    elseif x == 92 then -- `\`: Escape
      res = res .. str:sub(k, j - 1)
      j = j + 1
      local c = str:sub(j, j)
      if c == "u" then
        local hex = str:match("^[dD][89aAbB]%x%x\\u%x%x%x%x", j + 1)
            or str:match("^%x%x%x%x", j + 1)
            or decode_error(str, j - 1, "invalid unicode escape in string")
        res = res .. parse_unicode_escape(hex)
        j = j + #hex
      else
        if not escape_chars[c] then
          decode_error(str, j - 1, "invalid escape char '" .. c .. "' in string")
        end
        res = res .. escape_char_map_inv[c]
      end
      k = j + 1
    elseif x == 34 then -- `"`: End of string
      res = res .. str:sub(k, j - 1)
      return res, j + 1
    end

    j = j + 1
  end

  decode_error(str, i, "expected closing quote for string")
end


local function parse_number(str, i)
  local x = next_char(str, i, delim_chars)
  local s = str:sub(i, x - 1)
  local n = tonumber(s)
  if not n then
    decode_error(str, i, "invalid number '" .. s .. "'")
  end
  return n, x
end


local function parse_literal(str, i)
  local x = next_char(str, i, delim_chars)
  local word = str:sub(i, x - 1)
  if not literals[word] then
    decode_error(str, i, "invalid literal '" .. word .. "'")
  end
  return literal_map[word], x
end


local function parse_array(str, i)
  local res = {}
  local n = 1
  i = i + 1
  while 1 do
    local x
    i = next_char(str, i, space_chars, true)
    -- Empty / end of array?
    if str:sub(i, i) == "]" then
      i = i + 1
      break
    end
    -- Read token
    x, i = parse(str, i)
    res[n] = x
    n = n + 1
    -- Next token
    i = next_char(str, i, space_chars, true)
    local chr = str:sub(i, i)
    i = i + 1
    if chr == "]" then break end
    if chr ~= "," then decode_error(str, i, "expected ']' or ','") end
  end
  return res, i
end


local function parse_object(str, i)
  local res = {}
  i = i + 1
  while 1 do
    local key, val
    i = next_char(str, i, space_chars, true)
    -- Empty / end of object?
    if str:sub(i, i) == "}" then
      i = i + 1
      break
    end
    -- Read key
    if str:sub(i, i) ~= '"' then
      decode_error(str, i, "expected string for key")
    end
    key, i = parse(str, i)
    -- Read ':' delimiter
    i = next_char(str, i, space_chars, true)
    if str:sub(i, i) ~= ":" then
      decode_error(str, i, "expected ':' after key")
    end
    i = next_char(str, i + 1, space_chars, true)
    -- Read value
    val, i = parse(str, i)
    -- Set
    res[key] = val
    -- Next token
    i = next_char(str, i, space_chars, true)
    local chr = str:sub(i, i)
    i = i + 1
    if chr == "}" then break end
    if chr ~= "," then decode_error(str, i, "expected '}' or ','") end
  end
  return res, i
end


local char_func_map = {
  ['"'] = parse_string,
  ["0"] = parse_number,
  ["1"] = parse_number,
  ["2"] = parse_number,
  ["3"] = parse_number,
  ["4"] = parse_number,
  ["5"] = parse_number,
  ["6"] = parse_number,
  ["7"] = parse_number,
  ["8"] = parse_number,
  ["9"] = parse_number,
  ["-"] = parse_number,
  ["t"] = parse_literal,
  ["f"] = parse_literal,
  ["n"] = parse_literal,
  ["["] = parse_array,
  ["{"] = parse_object,
}


parse = function(str, idx)
  local chr = str:sub(idx, idx)
  local f = char_func_map[chr]
  if f then
    return f(str, idx)
  end
  decode_error(str, idx, "unexpected character '" .. chr .. "'")
end


function json.decode(str)
  if type(str) ~= "string" then
    error("expected argument of type string, got " .. type(str))
  end
  local res, idx = parse(str, next_char(str, 1, space_chars, true))
  idx = next_char(str, idx, space_chars, true)
  if idx <= #str then
    decode_error(str, idx, "trailing garbage")
  end
  return res
end

local function terminalOutput(call)
  local handle = io.popen("bash -c '" .. call .. " 2>/dev/null'")
  if handle == nil then return nil end
  local out = handle:read("*a")
  handle:close()
  return out
end
local function status()
  local output = terminalOutput("playerctl status")
  if output == "" or output == nil then
    return nil
  else
    return string.find(output, "Playing") == 1
  end
end
local function media()
  local output = terminalOutput("playerctl metadata")
  local otable = {
    exists = not (output == "" or output == nil),
  }
  if (output == "" or output == nil) then return otable end
  otable.playing = status()
  for line in string.gmatch(output, "[^\n\r]+") do
    local key = ""
    local place = string.find(line, ":")
    place = place + 1
    while string.sub(line, place, place) ~= " " do
      key = key .. string.sub(line, place, place)
      place = place + 1
    end
    while string.sub(line, place, place) == " " do
      place = place + 1
    end
    local val = string.sub(line, place)
    otable[key] = val
  end
  return otable
end

local function workspacer()
  local workspaces = {}
  local out = terminalOutput("hyprctl -j workspaces")
  workspaces = json.decode(out)
  local wspaces = {}
  local max = 0
  for _, v in pairs(workspaces) do
    wspaces[v.id] = v
    if max < v.id then max = v.id end
  end
  for i = 1, max do
    if wspaces[i] == nil then
      wspaces[i] = {}
    end
  end
  out = terminalOutput("hyprctl -j activeworkspace")
  local activeWorkspace = json.decode(out)
  wspaces[activeWorkspace.id].active = true
  return wspaces
end
local Utils = {
  Bash = terminalOutput,
  Media = media,
  Workspaces = workspacer,
}

























local Astal = require("astal")
local Exec = Astal.exec
local App = require("astal.gtk3.app")
local Battery = Astal.require("AstalBattery")
-- local Time = require("astal.time")
local Gtk = require("astal.gtk3").Gtk
local Widget = require("astal.gtk3.widget")
local Anchor = require("astal.gtk3").Astal.WindowAnchor
local Wp = Astal.require("AstalWp")

local fgColor = "rgba(144,144,255,1)"
local bgColor = "rgba(32,32,64,1)"
local cssA = {
  tbg = [[
  background-color: transparent;
  ]],
  fround = "border-radius:999px;",
  text = [[
    font-size: 20px;
    font-weight:bold;
    color:]] .. fgColor .. [[;
    background-color:transparent;
    ]],
  button = [[
    background:]] .. bgColor .. [[;
    color:black;
    padding : 2px;
    box-shadow:none;
    text-shadow:none;
    border-width: 2px;
    border-color: ]] .. fgColor .. [[ ;
    border-radius :10px;
    ]],
}
local stateTable = {
  actionCenter = Astal.Variable(false),
  media = Astal.Variable(Utils.Media()):poll(
    500,
    Utils.Media
  ),
  workspaces = Astal.Variable(Utils.Workspaces()):poll(
    500,
    Utils.Workspaces
  ),
}

local function workspaces()
  return Widget.Box(
    {
      Widget.Button({
        css = cssA.button .. cssA.fround,
        Widget.Label({
          css = cssA.text .. [[
          margin-left:5px;
          ]],
          label = Astal.bind(stateTable.workspaces):as(function(data)
            local st = ""
            for i, v in ipairs(data) do
              if v.active == true then
                st = st .. ' '
              else
                st = st .. ' '
              end
            end
            return st
          end)
        })
      }),
    }
  )
end
local function Left()
  return
      Widget.Box({
        halign = Gtk.Align.START,
        Widget.Button({
          css = cssA.button,
          on_click_release = function()
            stateTable.actionCenter:set(not stateTable.actionCenter:get())
          end,
          Widget.Label({
            css = cssA.text ..
                [[
            font-size: 24px;
            margin-left: 9px;
            ]],
            label = "󰣇 ",
          }),
        }),
        Widget.Button({
          css = cssA.button .. cssA.fround ..
              [[
              min-width:35px;
              margin-right :5px;
              margin-left:5px;
              ]],
          on_click_release = function()
            Exec("bash -c 'rofi -show drun' ")
          end,
          Widget.Label({
            css = cssA.text ..
                [[
            font-size: 24px;
            margin-right:2px;
            ]],
            label = "󱗼"
          }),
        }),
        workspaces(),
      })
end
local function Right()
  local BatteryIcons = {
    '', '', '', '', '',
  }
  local time = Astal.Variable(""):poll(
    1000,
    function()
      return os.date("%a %b %d %X")
    end
  )
  local battery = Astal.Variable(""):poll(
    1000,
    function()
      local bState = Battery.get_default()
      if not (bState["is-present"]) then return " " end
      local batteryPercentage = math.floor(100 * bState["percentage"])
      local bicon = BatteryIcons[math.floor(batteryPercentage / 20) + 1]
      if (bState["state"] == "CHARGING") then
        bicon = bicon .. " 󱐋 "
      else
        bicon = bicon .. "   "
      end
      return (bicon .. batteryPercentage .. "%")
    end
  )
  return
      Widget.Box({
        css = cssA.tbg,
        halign = Gtk.Align.END,
        Widget.Button({
          css = cssA.button .. [[
          padding-left:9px;
          padding-right:9px;
          margin-left:5px;
          margin-right:5px;
          ]],
          Widget.Label({
            css = cssA.text,
            label = Astal.bind(battery):as(function(st)
              return st
            end),
          }),
        }),
        Widget.Button({
          css = cssA.button,
          Widget.Label({
            css = cssA.text,
            label = Astal.bind(time):as(tostring),
          }),
        }),
        on_destroy = function()
          time:drop()
          battery:drop()
        end
      })
end
local function Center()
  local button = [[
      background:]] .. fgColor .. [[;
      color:black;
      box-shadow:none;
      text-shadow:none;
      border-width: 0px;
      font-size: 20px;
      font-weight:bold;
      margin-left: 2px;
      margin-right:2px;
      border-radius :5px;
      ]]
  return
      Widget.Box({
        halign = Gtk.Align.END,
        on_destroy = stateTable.media.drop,
        vertical = false,
        visible = Astal.bind(stateTable.media):as(function(t)
          return t.exists
        end),
        Widget.Button({
          css = button,
          label = "",
          on_click_release = function()
            Exec("bash -c 'playerctl previous'")
          end
        }),
        Widget.Button({
          css = button,
          label = Astal.bind(stateTable.media):as(function(t)
            if not t.exists then return "" end
            if (not t.playing) then
              return ""
            else
              return ""
            end
          end),
          on_click_release = function()
            Exec("bash -c 'playerctl play-pause'")
          end
        }),
        Widget.Button({
          css = button,
          label = "",
          on_click_release = function()
            Exec("bash -c 'playerctl next'")
          end
        }),
        Widget.Label({
          css = button .. [[
          padding-left:5px;
          padding-right:5px;
          ]],
          label = Astal.bind(stateTable.media):as(function(t)
            if not t.exists then return "" end
            return t.title:sub(1, 25)
          end),
        })
      })
end
local function actionCenter()
  local function actions()
    local button = [[
      background:]] .. fgColor .. [[;
      color:black;
      padding : 2px;
      box-shadow:none;
      text-shadow:none;
      border-width: 0px;
      font-size: 20px;
      font-weight:bold;
      padding:10px;
      margin-left: 2px;
      margin-right:2px;
      border-radius :5px;
      ]]

    return Widget.Box({
      css = "margin:3px;",
      Widget.Button({
        css = button,
        on_click_release = function()
          print("shutdown")
          Exec("bash -c 'shutdown now'")
        end,
        Widget.Label({
          css = "margin-right:5px;",
          label = '',
        })
      }),
      Widget.Button({
        css = button,
        on_click_release = function()
          print("reboot")
          Exec("bash -c 'reboot'")
        end,
        Widget.Label({
          css = "margin-right:5px;",
          label = '',
        })
      }),
      Widget.Button({
        css = button,
        on_click_release = function()
          print("suspend")
          Exec("bash -c 'systemctl suspend'")
        end,
        Widget.Label({
          css = "margin-right:5px;",
          label = '',
        })
      }),
      Widget.Button({
        css = button,
        on_click_release = function()
          print("logout")
          Exec("bash -c 'pkill -u $(whoami)'")
        end,
        Widget.Label({
          css = "margin-right:5px;",
          label = '󰍃',
        })
      }),
    })
  end
  local function sliders()
    local speaker = Wp.get_default().audio.default_speaker
    local function setBrightness(percentBrightness)
      local _, err = Exec("bash -c 'brightnessctl set " .. math.floor(100 * percentBrightness) .. "'")
      if err ~= nil then
        print(err)
      end
    end
    local function getBrightness()
      local out, err = Exec("bash -c 'brightnessctl get' ")
      if err ~= nil then
        print(err)
      else
        return (tonumber(out))
      end
      return 0
    end
    local brightness = Astal.Variable(getBrightness())
    return
        Widget.Box({
          vertical = true,
          Widget.Slider({
            css = cssA.button,
            hexpand = true,
            on_dragged = function(self) speaker.volume = self.value end,
            value = Astal.bind(speaker, "volume"),
          }),

          Widget.Slider({
            hexpand = true,
            css = cssA.button,
            on_dragged = function(self) setBrightness(self.value) end,
            value = Astal.bind(brightness),
          })
        })
  end
  return
      Widget.Box({
        Widget.Box({
          css = [[
          margin-top:10px;
          padding:2px;
          margin:2px;
          border-radius: 10px;
          background-color:]] .. fgColor .. [[
          ]],
          hexpand = false,
          Widget.Box({
            css = cssA.button .. [[
            padding:5px;
            ]],
            halign = Gtk.Align.START,
            vertical = true,
            sliders(),
            actions(),
          })
        })
      })
end

local function modals(monitor)
  return
      Widget.Window({
        monitor = monitor,
        anchor = Anchor.TOP + Anchor.LEFT + Anchor.RIGHT,
        visible = Astal.bind(stateTable.actionCenter),
        css = cssA.tbg,
        actionCenter(),
      })
end
local function Bar(monitor)
  return Widget.Window({
    monitor = monitor,
    anchor = Anchor.TOP + Anchor.LEFT + Anchor.RIGHT,
    exclusivity = "EXCLUSIVE",
    css = cssA.tbg,
    Widget.CenterBox({
      css = [[
      margin-top:10px;
      ]],
      vertical = false,
      Left(),
      Center(),
      Right(),
      modals(monitor),
    }),
    --?
  })
end

App:start({
  main = function()
    Bar(0)
  end
})
