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

