export def ensure-installed [...pkgs: string] {
  for pkg in $pkgs {
    if (yay -Q $pkg | complete).exit_code != 0 {
      try { 
        ^yay -S --noconfirm $pkg
      } catch { 
        error make {msg: $"failed to install ($pkg)"}
      }
      ^yay -S --noconfirm $pkg
    } else {
      print $"($pkg) already installed"
    }
  }
}

