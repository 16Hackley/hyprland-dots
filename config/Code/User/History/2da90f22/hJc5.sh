#!/bin/bash

# WALLPAPERS PATH
DIR=$HOME/.config/hypr/themes/catppuccin/wallpapers

# Transition config (type swww img --help for more settings)
FPS=60
TYPE="simple"
DURATION=3

# wofi window config (in %)
WIDTH=20
HEIGHT=30

SWWW_PARAMS="--transition-fps $FPS --transition-type $TYPE --transition-duration $DURATION"

PICS=($(ls ${DIR} | grep -e ".jpg$" -e ".jpeg$" -e ".png$" -e ".gif$"))

RANDOM_PIC=${PICS[ $RANDOM % ${#PICS[@]} ]}
RANDOM_PIC_NAME="${#PICS[@]}. random"

# WOFI STYLES
CONFIG="$HOME/.config/hypr/themes/catppuccin/wofi/wallSelector/config"
STYLE="$HOME/.config/hypr/themes/catppuccin/wofi/wallSelector/style.css"
COLORS="$HOME/.config/hypr/themes/catppuccin/wofi/wallSelector/colors"

# to check if swaybg is running
if [[ $(pidof swaybg) ]]; then
  pkill swaybg
fi

## Wofi Command
wofi_command="wofi --show dmenu \
			--prompt choose... \
			--conf $CONFIG --style $STYLE --color $COLORS \
			--width=$WIDTH% --height=$HEIGHT% \
			--cache-file=/dev/null \
			--hide-scroll --no-actions \
			--matching=fuzzy"

menu() {
    # Loop through the PICS array
    for i in ${!PICS[@]}; do
        if [[ -z $(echo ${PICS[$i]} | grep .gif$) ]]; then
            printf "$i. $(echo ${PICS[$i]} | cut -d. -f1)\n"
        else
            printf "$i. ${PICS[$i]}\n"
        fi
    done

    printf "$RANDOM_PIC_NAME"
}

swww query || swww-daemon

update_hyprpaper_conf() {
    local pic_path=$1
    local conf_file="$HOME/.config/hypr/hyprpaper.conf"
    
    # Check if the conf file exists, if not create it
    if [ ! -f "$conf_file" ]; then
        touch "$conf_file"
    fi
    
    # Update the preload line
    if grep -q "^preload" "$conf_file"; then
        sed -i "s|^preload.*|preload = $pic_path|" "$conf_file"
    else
        echo "preload = $pic_path" >> "$conf_file"
    fi

    # Update the wallpaper lines
    if grep -q "^wallpaper" "$conf_file"; then
        sed -i "s|^wallpaper.*|wallpaper = HDMI-A-1,$pic_path|" "$conf_file"
    else
        echo "wallpaper = HDMI-A-1,$pic_path" >> "$conf_file"
    fi
}

main() {
    choice=$(menu | ${wofi_command})

    # No choice case
    if [[ -z $choice ]]; then return; fi

    # Random choice case
    if [ "$choice" = "$RANDOM_PIC_NAME" ]; then
        pic_path="${DIR}/${RANDOM_PIC}"
        swww img "$pic_path" $SWWW_PARAMS
        update_hyprpaper_conf "$pic_path"
        return
    fi
    
    pic_index=$(echo $choice | cut -d. -f1)
    pic_path="${DIR}/${PICS[$pic_index]}"
    swww img "$pic_path" $SWWW_PARAMS
    update_hyprpaper_conf "$pic_path"
}

# Check if wofi is already running
if pidof wofi >/dev/null; then
    killall wofi
    exit 0
else
    main
fi

# Uncomment to launch something if a choice was made
# if [[ -n "$choice" ]]; then
    # Restart Waybar
# fi
