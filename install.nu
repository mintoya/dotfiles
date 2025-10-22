try {
  ^yay --help 
} catch {
  print "installing yay "
  let yaydir = "~/yay" | path expand
  mkdir $yaydir

  git clone "https://aur.archlinux.org/yay.git" $yaydir
  cd $yaydir
  makepkg -si -D $yaydir
}
print "yay is installed "
print "installing some dependencies"

export def ensure-installed [...pkgs: string] {
  for pkg in $pkgs {
    if (^yay -Q $pkg | complete).exit_code != 0 {
      try { 
        ^yay -S --noconfirm $pkg
      } catch { 
        error make {msg: $"failed to install ($pkg)"}
      }
      print $"(ansi reset)($pkg) \t- (ansi green)installed(ansi reset)"
    } else {
      print $"(ansi reset)($pkg) \t- (ansi yellow)skipped(ansi reset)"
    }
  }
}


ensure-installed grep

$env.config.table.mode = "none" 
$env.NU_STRICT = true

  print "running install scripts"
( ^find (pwd) -type f | ^grep installs.nu | lines  )
  | each { open $in | from nuon }
  | flatten 
  | ensure-installed ...$in
  print "done "

