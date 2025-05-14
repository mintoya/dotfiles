
# monitor=,1920x1080,auto,1,bitdepth,8
# monitor=,preferred,auto,1,mirror,eDP-1,bitdepth,8
#
#!/usr/bin/env zsh

if [[ "$(hyprctl monitors)" =~ "\sDP-[0-9]+" ]]; then
  if [[ $1 == "open" ]]; then
    hyprctl keyword monitor "eDP-1,1920x1080,2560x0,1"
  else
    hyprctl keyword monitor "eDP-1,disable"
  fi
fi
