
alias restart = shutdown -r now

def set-background [
  --path (-p): string
] {
  let absPath = ($path|path expand)
  matugen --contrast 1 -m dark image $absPath -c ("~/.config/matugen/config.toml"|path expand)
}

def nufzf [
  --format (-f) : closure 
  --preview(-p) : closure 
  --fzflags     : list<string> = ["multi","ansi"]
  ] {
  let data = if ($in | is-empty) { ls } else { $in }
  let format  = if ($format  | is-empty) { {$in} } else { $format }
  let preview = if ($preview | is-empty) { {$in} } else { $preview }
  let flags = $fzflags | each { "--" + $in } 
  let previewCmd = $"\( {}|parse \"{value} __;__ {name}\"\).0.value|from nuon|do ( $preview |to nuon --serialize | from nuon)"
    #from nuon removes the quotes
  return (
    $data

    |each {|x| let formatted = do $format $x ; $"(($x | to nuon -r)) __;__ ($formatted)" }
    |to text
    |^fzf
      ...$flags
      --with-shell="nu -c"
      --with-nth=2
      --delimiter="__;__"
      --preview=$"($previewCmd)"
    |lines 
    |parse "{data} __;__ {name}" 
    |get -o data 
    |each {$in|from nuon}
  )
}
def setvi [
  folder:string
] {
  $env.NVIM_APPNAME = $folder
}


source $"($nu.cache-dir)/carapace.nu"
source $"($nu.cache-dir)/starsihp.nu"
source $"($nu.cache-dir)/zoxide.nu"
source $"($nu.cache-dir)/custom.nu"
# source $"~/.cache/cwal/colors.nu"
source ./yazi.nu

alias gs = ^lazygit
alias vi = ^nvim
alias q  = exit
alias md = mkdir
alias rd = rm -rf
alias c  = clear

alias clea = sl -G
# ^fastfetch -c examples/11.jsonc
^fastfetch
