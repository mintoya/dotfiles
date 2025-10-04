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

print "linking"
