let colors = ( open -r ( "~/.cache/cwal/flat.json" |path expand) |from json)

$colors|to nuon
