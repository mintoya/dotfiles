print "running setup scripts"
(ls|where type == dir|get name) 
  | each { |x| ls $x|where name =~ "setup.nu" | get name } 
  |  flatten 
  | each { |x| print (do { nu $x }) }
print "done"
