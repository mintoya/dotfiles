nu link.nu
let return_directory = pwd 

try {
    ^yay --version | ignore
} catch {
    print "installing yay..."
    let yaydir = (mktemp -d "yay.XXXXXX" | path expand)
    git clone "https://aur.archlinux.org/yay.git" $yaydir
    cd $yaydir
    makepkg -si
}

print "yay is installed "
cd $return_directory

def ensure-exists [...files: string] {
  for file in $files {
    mkdir ( $file | path dirname )
    if ($file | path exists) {
      print $"skipping ($file)"
    } else {
      ""|save -a $file
    }
  }
}
def ensure-installed [...pkgs: string] {
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
def run_script [...scripts:string] {
  for s in $scripts {
    print $"running ($s)"
    nu --commands $s
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
print "ensuring files exist"
ensure-exists ...(
  $setups | get files
)
print "installing some dependencies "
ensure-installed ...(
  $setups | get requires
)
print "running post-install scripts"
run_script ...(
  $setups | get scripts
)
print "done "
