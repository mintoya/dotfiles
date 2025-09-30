print "installing some dependencies"
use ./ensure-install.nu *
ensure-installed starship
$env.config.table.mode = "none" 
$env.NU_STRICT = true

(ls|where type == dir|get name) 
  | each { |x| ls $x|where name =~ "install.nu" | get name } 
  |  flatten 
  | each { |x| print (do { nu $x }) }

print "done "

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
