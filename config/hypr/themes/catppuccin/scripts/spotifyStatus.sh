#!/bin/sh

status=$(playerctl -p spotify status 2> /dev/null)

if [ "$status" = "Playing" ]; then
    title_artist=$(playerctl metadata --format "{{ title }} by {{ artist }}" -p spotify)
    if [ ${#title_artist} -gt 60 ]; then
        title_artist=${title_artist:0:60}
        title_artist+=" ..."
    fi
    duration_seconds=$(playerctl -p spotify metadata mpris:length | awk '{printf("%.0f", $1 / 1000000)}')
    if [ "$duration_seconds" -ge 3600 ]; then
        duration_formatted=$(printf "%02d:%02d:%02d" $(($duration_seconds/3600)) $(($duration_seconds%3600/60)) $(($duration_seconds%60)))
    else
        duration_formatted=$(printf "%02d:%02d" $(($duration_seconds/60)) $(($duration_seconds%60)))
    fi

    echo " $title_artist $duration_formatted"
elif [ "$status" = "Paused" ]; then
    title_artist=$(playerctl metadata --format "{{ title }} by {{ artist }}" -p spotify)
    if [ ${#title_artist} -gt 60 ]; then
        title_artist=${title_artist:0:60}
        title_artist+=" ..."
    fi
    duration_seconds=$(playerctl -p spotify metadata mpris:length | awk '{printf("%.0f", $1 / 1000000)}')
    if [ "$duration_seconds" -ge 3600 ]; then
        duration_formatted=$(printf "%02d:%02d:%02d" $(($duration_seconds/3600)) $(($duration_seconds%3600/60)) $(($duration_seconds%60)))
    else
        duration_formatted=$(printf "%02d:%02d" $(($duration_seconds/60)) $(($duration_seconds%60)))
    fi
    
    echo " $title_artist $duration_formatted"
else
    echo ""
fi