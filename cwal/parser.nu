export def nuPtemplater [
  --filepath (-f): string,  # path to the template file
  --input    (-c): record   # record of variables to inject
] {
  open -r $filepath
  | lines
  | each {|line|
      let parsed = ($line | parse "{start}%nu%{middle}%nu%{end}")
      if ($parsed | is-empty) {
        $line
      } else {
        let start = $parsed.start.0
        let middle = $parsed.middle.0
        let end = $parsed.end.0

        let result = ( nu -c $"($input)| do ($middle)" )
        $'($start)($result)($end)'
      }
    }
  | str join "\n"
}

