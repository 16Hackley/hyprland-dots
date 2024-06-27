#!/usr/bin/env sh

# Check if wlogout is already running
if pgrep -x "wlogout" > /dev/null
then
    pkill -x "wlogout"
    exit 0
fi

# Set file variables
confDir="$HOME/.config/hypr/themes/catppuccin"
wlogoutStyle=${wlogoutStyle:-1}  # Default to 1 if not set
wLayout="${confDir}/wlogout/layout"
wlTmplt="${confDir}/wlogout/style.css"

if [ ! -f "${wLayout}" ] || [ ! -f "${wlTmplt}" ]; then
    echo "ERROR: Config ${wlogoutStyle} not found..."
    wlogoutStyle=1
    wLayout="${confDir}/wlogout/layout"
    wlTmplt="${confDir}/wlogout/style.css"
fi

# Detect monitor resolution
x_mon=$(hyprctl -j monitors | jq '.[] | select(.focused==true) | .width')
y_mon=$(hyprctl -j monitors | jq '.[] | select(.focused==true) | .height')
hypr_scale=$(hyprctl -j monitors | jq '.[] | select(.focused==true) | .scale' | sed 's/\.//')

# Validate hypr_scale
if [ -z "$hypr_scale" ] || ! echo "$hypr_scale" | grep -q '^[0-9]*$'; then
    echo "ERROR: Invalid hypr_scale detected"
    exit 1
fi

# Scale config layout and style
case "${wlogoutStyle}" in
    1)
        wlColms=6
        mgn=$(( y_mon * 28 / hypr_scale ))
        hvr=$(( y_mon * 23 / hypr_scale ))
        export mgn hvr
        ;;
    2)
        wlColms=2
        x_mgn=$(( x_mon * 35 / hypr_scale ))
        y_mgn=$(( y_mon * 25 / hypr_scale ))
        x_hvr=$(( x_mon * 32 / hypr_scale ))
        y_hvr=$(( y_mon * 20 / hypr_scale ))
        export x_mgn y_mgn x_hvr y_hvr
        ;;
    *)
        echo "ERROR: Invalid wlogoutStyle"
        exit 1
        ;;
esac

# Scale font size
fntSize=$(( y_mon * 2 / 100 ))
export fntSize

# Evaluate hypr border radius
hypr_border=${hypr_border:-1}  # Default to 1 if not set
active_rad=$(( hypr_border * 5 ))
button_rad=$(( hypr_border * 8 ))
export active_rad button_rad

# Evaluate config files
wlStyle=$(envsubst < "$wlTmplt")

# Launch wlogout
wlogout -b "${wlColms}" -c 0 -r 0 -m 0 --layout "${wLayout}" --css <(echo "${wlStyle}") --protocol layer-shell
