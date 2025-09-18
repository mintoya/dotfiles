# This file is used to override default Nushell settings, define
# (or import) custom commands, or run any other startup tasks.
# See https://www.nushell.sh/book/configuration.html
# See `help config nu` for more options

source ./starship.nu
source ./zoxide.nu

def --env y [...args] {
	let tmp = (mktemp -t "yazi-cwd.XXXXXX")
	yazi ...$args --cwd-file $tmp
	let cwd = (open $tmp)
	if $cwd != "" and $cwd != $env.PWD {
		cd $cwd
	}
	rm -fp $tmp
}


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
# completion 

let fish_completer = {|spans|
    fish --command $"complete '--do-complete=($spans | str replace --all "'" "\\'" | str join ' ')'"
    | from tsv --flexible --noheaders --no-infer
    | rename value description
    | update value {|row|
      let value = $row.value
      let need_quote = ['\' ',' '[' ']' '(' ')' ' ' '\t' "'" '"' "`"] | any {$in in $value}
      if ($need_quote and ($value | path exists)) {
        let expanded_path = if ($value starts-with ~) {$value | path expand --no-symlink} else {$value}
        $'"($expanded_path | str replace --all "\"" "\\\"")"'
      } else {$value}
    }
}

let carapace_completer = {|spans: list<string>|
    carapace $spans.0 nushell ...$spans
    | from json
    | if ($in | default [] | where value =~ '^-.*ERR$' | is-empty) { $in } else { null }
}

$env.config = {
    # ...
    completions: {
        external: {
            enable: true
            completer: $fish_completer 
        }
    }
    # ...
}
# completion

alias vi = nvim
alias q = exit
alias md = mkdir
alias rd = rm -rf
alias c = clear
fastfetch
