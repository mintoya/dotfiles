
export def ensure-exists [...files: string] {
  for file in $files {
    mkdir ( $file | path dirname )
    ""|save -a $file
  }
}
print "making required files"
( ^find (pwd) -type f | ^grep installs.nu | lines  )
  | each { open $in | from nuon }
  | flatten 
  | ensure-exists ...$in.files
  | nu -c ...$in.commands
  print "done "
