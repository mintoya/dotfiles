# My .files
zen requires a symlink to work
do this in the chrome folder
* Bash
`
ln -s ~/.config/zen/matugen.css matugen.css
`
* PowerShell: 
`
New-Item -ItemType SymbolicLink -Path .\matugen.css -Target "$HOME\.config\zen\matugen.css"
`
