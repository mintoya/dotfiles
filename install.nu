$env.config.table.mode = "none" 
$env.NU_STRICT = true

(ls|where type == dir|get name) |each { |x| ls $x|where name =~ "install.nu"|get name } | flatten |each {|x| nu ( $x ) }



let src = ( pwd|path expand )
let dest = ( "~/.config"|path expand )

ls --full-paths $src | each {|f|
  let target = ($dest | path expand | path join ($f.name| path basename))
  let source = ($f.name | path expand)
  if ($target | path type ) == "symlink" {
    print $"($target) is a symlink, deleting it now"
    rm $target
  }
  if ($target | path exists) {
    mv $target ($target + ".bak"| path expand)
    print $"backed up ($target)"
  }
  ln -s $source $target
  print $"linked ($source) → ($target)"
}

print "done"
