try {
  ^yay --help 
} catch {
  print "installing yay "
  let yaydir = "~/yay" | path expand
  mkdir $yaydir

  git clone "https://aur.archlinux.org/yay.git" $yaydir
  cd yay
  makepkg -si -D $yaydir
}
print "yay is installed "
print "installing some dependencies"

use ./ensure-install.nu *

ensure-installed grep

$env.config.table.mode = "none" 
$env.NU_STRICT = true

  print "running install scripts"
( ^find (pwd) -type f | ^grep installs.nu | lines  )
  | each { open $in | from nuon }
  | flatten 
  | ensure-installed ...$in
  print "done "

