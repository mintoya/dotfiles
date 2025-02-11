local Astal = require("astal")
local Exec = Astal.exec
local App = require("astal.gtk3.app")
local Battery = Astal.require("AstalBattery")
-- local Time = require("astal.time")
local Gtk = require("astal.gtk3").Gtk
local Widget = require("astal.gtk3.widget")
local Anchor = require("astal.gtk3").Astal.WindowAnchor
-- sleep: systemctl suspend
--[[ example for executing file
local out, err = exec("/path/to/script")

if err ~= nil then
    print(err)
else
    print(out)
end

exec_async({ "bash", "-c", "/path/to/script.sh" }, function(out, err)
    if err ~= nil then
        print(err)
    else
        print(out)
    end
end)
]]

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
  local count = Astal.Variable(0)
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
            label = Astal.bind(count):as(function(st)
              return "󱗼"
            end),
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
    10000,
    function()
      -- print(Battery.get_default()["is-present"])
      local batteryPercentage = math.floor(100 * Battery.get_default()["percentage"])
      local bicon = BatteryIcons[math.floor(batteryPercentage / 20) + 1]
      return (bicon .. "   " .. batteryPercentage .. "%")
    end
  )
  return
      Widget.Box({
        css = "background-color: transparent;",
        halign = Gtk.Align.END,
        Widget.Button({
          css = cssA.button ..
              [[
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
  local count = Astal.Variable(0)
  return
      Widget.Button({
        halign = Gtk.Align.END,
        css = cssA.button,
        Widget.Label({
          css = cssA.text,
          label = "middle",
        }),
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
        end,
        Widget.Label({
          css = "margin-right:5px;",
          label = '󰍃',
        })
      }),
    })
  end
  return Widget.Box({
    css = cssA.button ..
        [[
        margin-top: 10px;
        padding:5px;
        ]],
    halign = Gtk.Align.START,
    actions(),
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
      Left(),
      Center(),
      Right(),
    }),
    --?
    modals(monitor),
  })
end

App:start({
  main = function()
    Bar(0)
  end
})
