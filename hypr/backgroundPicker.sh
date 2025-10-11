#!/bin/bash

# File to store chosen image
pathFile=$(mktemp -t "yazi-cwd.XXXXXX")

# Your command template
matugenCommand="matugen --contrast 1 -m dark image"
swwwCommand=" swww img --transition-type center"
# Build a script that runs inside the floating terminal
ghostScript=$(mktemp)
cat > "$ghostScript" <<EOF
#!/bin/bash
# Run yazi to pick a file
yazi ~/Pictures --chooser-file "$pathFile"
# After yazi exits, run matugen with chosen file
$matugenCommand \$(cat "$pathFile")
$swwwCommand \$(cat "$pathFile")
rm -fp $pathFile
EOF

chmod +x "$ghostScript"

hyprctl dispatch exec "[float] ghostty -e bash -c $ghostScript"




