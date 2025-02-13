local function status()
  local handle = io.popen("bash -c 'playerctl status 2>/dev/null'")

  if (handle == nil) then return { exists = false } end

  local output = handle:read("*a") -- Read all output
  handle:close()
  if output == "" then
    return nil
  else
    return string.find(output, "Playing") == 1
  end
end
local function Media()
  local handle = io.popen("bash -c 'playerctl metadata 2>/dev/null'")

  if (handle == nil) then return { exists = false } end

  local output = handle:read("*a") -- Read all output
  handle:close()
  local otable = {
    exists = not (output == ""),
  }
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
  tbg = "background-color: transparent;",
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
  actionCenter = Astal.Variable(false)
}
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
  local media = Astal.Variable(Media()):poll(
    500,
    Media
  )
  return
      Widget.Box({
        halign = Gtk.Align.END,
        on_destroy = media.drop,
        vertical = false,
        visible = Astal.bind(media):as(function(t)
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
          label = Astal.bind(media):as(function(t)
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
          label = Astal.bind(media):as(function(t)
            if not t.exists then return "" end
            return t.title:sub(1, 15)
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
