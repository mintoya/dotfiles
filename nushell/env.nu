# env.nu
#
# Installed by:
# version = "0.101.0"
#
# Previously, environment variables were typically configured in `env.nu`.
# In general, most configuration can and should be performed in `config.nu`
# or one of the autoload directories.
#
# This file is generated for backwards compatibility for now.
# It is loaded before config.nu and login.nu
#
# See https://www.nushell.sh/book/configuration.html
#
# Also see `help config env` for more options.
#
# You can remove these comments if you want or leave
# them for future reference.
$env.PATH = ($env.PATH | prepend "~/.npm-global/bin")
$env.PATH = ($env.PATH | prepend "~/.local/bin")

$env.CARAPACE_BRIDGES = 'zsh,fish,bash,inshellisense' # optional

mkdir $"($nu.cache-dir)"




carapace _carapace nushell | save --force $"($nu.cache-dir)/carapace.nu"
starship init nu           | save --force $"($nu.cache-dir)/starsihp.nu"
zoxide init nushell        | save --force $"($nu.cache-dir)/zoxide.nu"


$env.config.table.mode = 'none'
$env.config.show_banner = false
$env.config.shell_integration.osc133 = false
$env.config.buffer_editor = "nvim"
$env.EDITOR = "nvim"
$env.directory_editor = "yazi"
$env.config.edit_mode = 'vi'
$env.config.cursor_shape.vi_normal = 'block'
$env.config.cursor_shape.vi_insert = 'line'
$env.config.cursor_shape.emacs     = 'line'
$env.PROMPT_INDICATOR_VI_NORMAL = 'x '
$env.PROMPT_INDICATOR_VI_INSERT = '> '
