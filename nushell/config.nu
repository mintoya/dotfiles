# This file is used to override default Nushell settings, define
# (or import) custom commands, or run any other startup tasks.
# See https://www.nushell.sh/book/configuration.html
# See `help config nu` for more options

source ./starship.nu
source ./zoxide.nu

def --env y [...args] {
	let tmp = (mktemp -t "yazi-cwd.XXXXXX")
	yazi ...$args --cwd-file $tmp
	let cwd = (open $tmp)
	if $cwd != "" and $cwd != $env.PWD {
		cd $cwd
	}
	rm -fp $tmp
}



alias vi = nvim
alias e = yazi
alias ffetch = fastfetch --config examples/13
alias lgit = lazygit
alias restart = shutdown -r now
alias reminder = echo "
buttercup, lobster, kew,
nmcli device wifi connect "<ssid>" -- ask
hyprctl keyword monitor eDP-1,preferred,auto,1,transform,1 ;
hyprctl keyword input:touchdevice:transform 1
"
def fzl [
  --editor (-e): string  # Optional editor parameter
] {
  let pth = (ls | get name | str join "\n" | fzf)
  let ptht = ($pth | path type)
  let ed = if ($editor == null) {
    if ($ptht == "dir") {
      $env.directory_editor
    } else {
      $env.config.buffer_editor
    }
  } else {
    $editor
  }
  ^$ed $pth
}

def set-background [
  --path (-p): string
] {
    let absPath = ($path|path expand)
    matugen --contrast 1 -m dark image $absPath -c ("~/.config/matugen/config.toml"|path expand)
    if (not ($nu.os-info.name|str contains "windows")) {
      caelestia wallpaper -f $absPath
      caelestia scheme set -n dynamic -m dark
    } else {
      echo "not running caelestia commands"
    }
}

alias q = exit
fastfetch
