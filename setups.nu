nu -c link.nu
let return_directory = pwd 

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
cd $return_directory

export def ensure-exists [...files: string] {
  for file in $files {
    mkdir ( $file | path dirname )
    ""|save -a $file
  }
}
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
print "making required files"
let setups = ^fd . (pwd) --type file 
  | lines 
  | where {$in | path basename | $in == setup.nu}  
  | each {open -r $in| from nuon}
  | { 
      requires:($in|get -o requires | where {describe | $in != nothing}| flatten),
      files   :($in|get -o    files | where {describe | $in != nothing}| flatten),
      scripts :($in|get -o  scripts | where {describe | $in != nothing}| flatten),
    }
ensure-exists ...(
  $setups | get scripts
)
ensure-installed ...(
  $setups | get requires
)
print "done "
