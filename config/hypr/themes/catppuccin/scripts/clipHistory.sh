#!/bin/bash

# wofi window config (in %)
WIDTH=30
HEIGHT=40

# WOFI STYLES
CONFIG="$HOME/.config/hypr/themes/catppuccin/wofi/config"
STYLE="$HOME/.config/hypr/themes/catppuccin/wofi/style.css"
COLORS="$HOME/.config/hypr/themes/catppuccin/wofi/colors"

## Wofi Command
wofi_command="wofi --show dmenu \
            --prompt Clipboard \
            --conf $CONFIG --style $STYLE --color $COLORS \
            --width=$WIDTH% --height=$HEIGHT% \
            --cache-file=/dev/null \
            --hide-scroll --no-actions \
            --matching=fuzzy"

main() {
    # Use cliphist to get the clipboard history
    choice=$(cliphist list | ${wofi_command} | cliphist decode | wl-copy)
}

# Check if wofi is already running
if pidof wofi >/dev/null; then
    killall wofi
    exit 0
else
    main
fi
