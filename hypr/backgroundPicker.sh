#!/bin/bash

pathFile=$(mktemp -t "yazi-cwd.XXXXXX")

matugenCommand="matugen --contrast 1 -m dark image"
cwalCommand="cwal --contrast 1.1 --img"
swwwCommand=" swww img --transition-type center"

ghostScript=$(mktemp)
cat > "$ghostScript" <<EOF


yazi ~/Pictures --chooser-file "$pathFile"

$swwwCommand \$(cat "$pathFile")
$cwalCommand \$(cat "$pathFile")
$matugenCommand \$(cat "$pathFile")

rm -fp $pathFile

EOF

chmod +x "$ghostScript"

hyprctl dispatch exec "[float] ghostty -e bash -c $ghostScript"




