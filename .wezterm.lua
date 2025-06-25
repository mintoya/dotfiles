local wezterm = require("wezterm")
local config = wezterm.config_builder()
wezterm.font("Iosevka Nerd Font Propo", { weight = "Black", stretch = "Normal", style = "Italic" })

config.launch_menu = {
    { args = { "top" } },
    {
        label = "Git-Bash",
        args = { "C:\\Program Files\\Git\\bin\\bash.exe", "--login", "-i" },
    },
    {
        label = "wsl",
        args = { "wsl" },
    },
}
config.default_prog = { "nu.exe" }

config.color_scheme = "Catppuccin Mocha"

config.window_background_opacity = .1
config.window_decorations = "NONE|RESIZE"
config.adjust_window_size_when_changing_font_size = false
config.use_fancy_tab_bar = false
config.hide_tab_bar_if_only_one_tab = true
config.win32_system_backdrop = "Mica"

config.keys = {
    {
        key = "h",
        mods = "SHIFT|ALT|CTRL",
        action = wezterm.action.SplitVertical({ domain = "CurrentPaneDomain" }),
    },
    {
        key = "v",
        mods = "SHIFT|ALT|CTRL",
        action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }),
    },
    -- {
    --   key = 'm',
    --   mods = 'CMD',
    --   action = wezterm.action.DisableDefaultAssignment,
    -- },
}

return config
