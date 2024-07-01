#!/bin/bash

main() {
    wofi --show drun -c ~/.config/hypr/themes/catppuccin/wofi/config -s ~/.config/hypr/themes/catppuccin/wofi/style.css
}

# Check if wofi is already running
if pidof wofi >/dev/null; then
    killall wofi
    exit 0
else
    main
fi