#!/bin/bash

VOLUME_STEP=0.05

case "$1" in
    up)
        playerctl volume "$VOLUME_STEP"+ -p spotify
        ;;
    down)
        playerctl volume "$VOLUME_STEP"- -p spotify
        ;;
    next)
        playerctl next -p spotify
        ;;
    prev)
        playerctl previous -p spotify
        ;;
    play-pause)
        playerctl play-pause -p spotify
        ;;
esac