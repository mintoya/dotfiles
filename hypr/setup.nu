{
  files: ["~/.config/hypr/custom.conf"],
  requires :[ 
    "hyprland",
    "noctalia-qs-git",
    "thunar",
    "hyprsunset",
    "nwg-look",
  ],
  scripts :[
    "hyprctl reload"
  ],
}
