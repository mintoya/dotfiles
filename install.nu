print "installing some dependencies"
use ./ensure-install.nu *
ensure-installed starship yazi zoxide ttc-iosevka
$env.config.table.mode = "none" 
$env.NU_STRICT = true
print "running install scripts"
(ls|where type == dir|get name) 
  | each { |x| ls $x|where name =~ "install.nu" | get name } 
  |  flatten 
  | each { |x| print (do { nu $x }) }
print "done "

print "running setup scripts"
(ls|where type == dir|get name) 
  | each { |x| ls $x|where name =~ "setup.nu" | get name } 
  |  flatten 
  | each { |x| print (do { nu $x }) }
print "done"

let src = ( pwd|path expand ) 
let dest = ( "~/.config"|path expand )

ls --full-paths $src 
| each {|f|
  let target = ($dest | path expand | path join ($f.name| path basename))
  let source = ($f.name | path expand)
  if ($target | path type ) == "symlink" {
    print $"($target) \t(ansi red) deleted(ansi reset)"
    rm $target
  }
  if ($target | path exists) {
    mv $target ($target + ".bak"| path expand)
    print $"($target) \t(ansi yellow) backed up(ansi reset)"
  }
  ln -s $source $target
}

print "done installing"

print "adding colorschemes"
matugen --contrast 1 -m dark color hex "#5687ff" -c ( pwd | path join "matugen/config.toml" |path expand)

print "done"
