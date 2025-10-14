# This file is used to override default Nushell settings, define
# (or import) custom commands, or run any other startup tasks.
# See https://www.nushell.sh/book/configuration.html
# See `help config nu` for more options




alias restart = shutdown -r now

alias reminder = echo "
buttercup, lobster, kew,
hyprctl keyword monitor eDP-1,preferred,auto,1,transform,1 ;
hyprctl keyword input:touchdevice:transform 1
"

def set-background [
  --path (-p): string
] {
  let absPath = ($path|path expand)
  matugen --contrast 1 -m dark image $absPath -c ("~/.config/matugen/config.toml"|path expand)
}
def nufzf [
  --format(-f)  : closure
  --preview(-p) : closure
  --fzflags     : list<string> = ["multi","ansi"]
] {
  let flags = $fzflags | each { "--" + $in } 
  let forcePreview = $preview|to nuon --serialize|from nuon
  return (
    $in 
    |each {|x| let formatted = do $format $x ; $"(($x | to nuon -r)) __;__ ($formatted)" }
    |str join "\n"
    |^fzf
      ...$flags
      --with-shell="nu -c"
      --with-nth=2
      --delimiter="__;__"
      --preview=$"\({}|parse \"{value} __;__ {name}\"\).0.value|from nuon|do ($forcePreview)"
    | lines 
    | parse "{data} __;__ {name}" 
    | get -o data 
    |each {$in|from nuon}
  )
}

source $"($nu.cache-dir)/carapace.nu"
source $"($nu.cache-dir)/starsihp.nu"
source $"($nu.cache-dir)/zoxide.nu"
source ./yazi.nu

alias gs = ^lazygit
alias vi = ^nvim
alias q  = exit
alias md = mkdir
alias rd = rm -rf
alias c  = clear
^fastfetch
