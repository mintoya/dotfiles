use ../ensure-install.nu *

try { 
  ensure-installed starship zoxide fish carapace
  starship init nu    | save --force --progress ~/.config/nushell/starship.nu
  zoxide init nushell | save --force --progress ~/.config/nushell/zoxide.nu
} catch {
  error make {msg: "failed to set up nushell"}
}

