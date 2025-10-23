def set-term-color [index color] {
    print -n $"(ansi escape)]4;($index);($color)(char bel)"
}

# Colors 0–15
set-term-color 0 "{color0}"
set-term-color 1 "{color1}"
set-term-color 2 "{color2}"
set-term-color 3 "{color3}"
set-term-color 4 "{color4}"
set-term-color 5 "{color5}"
set-term-color 6 "{color6}"
set-term-color 7 "{color7}"
set-term-color 8 "{color8}"
set-term-color 9 "{color9}"
set-term-color 10 "{color10}"
set-term-color 11 "{color11}"
set-term-color 12 "{color12}"
set-term-color 13 "{color13}"
set-term-color 14 "{color14}"
set-term-color 15 "{color15}"

# Background
print -n $"(ansi escape)]11;{background}(char bel)"

# Foreground
print -n $"(ansi escape)]10;{foreground}(char bel)"

# Cursor
print -n $"(ansi escape)]12;{cursor}(char bel)"
