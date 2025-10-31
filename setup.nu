export def ensure-dir-exists [ dirname:directory ] {
  if (not ($dirname | path expand | path dirname | path exists)) {
    ensure-dir-exists  ($dirname | path expand | path dirname)
  }
  do { mkdir -v ($dirname | path expand) }
}

export def ensure-file-exist [files: string] {
  if ($files | is-empty) { return }
  for file in $files {
    ^mkdir -p ( $file | path dirname )
    if ($file | path expand | path type) == "file" {
      ""|save -a $file
    }
  }
}
print "making required files"

let table = (
(^find -type f | ^grep setup.nu| lines ) 
  | where {($in | path dirname | path expand) != (pwd|path expand)} 
  | flatten | each {open -r ($in | path expand) | from nuon}
  | {
      files   : ($in | get -o files    | default []),
      commands: ($in | get -o commands | default [])
    }
)
$table | get files | each {
    $in | each {
      ensure-file-exist ($in)
    }
  }
$table | get commands | each {
    $in | each {
      ^nu -c ($in)
    }
  }

print "done "
