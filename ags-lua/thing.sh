your_command="lua init.lua"
w_dir = "$HOME/.config/ags-lua"

$your_command &
PID=$!
inotifywait -m -r "$HOME/.config/ags-lua" \
  | while read path action file; do
    if [[ "$action" == "MODIFY" ]]; then
      echo "$action on $file"
      echo "Killing.."
      kill $PID
      $your_command &
      PID=$!
    fi
  done
# luastatic init.lua -o testo  -llu
# command to bundle the file
