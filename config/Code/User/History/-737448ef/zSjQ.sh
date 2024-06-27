#!/bin/sh

get_icon() {
    case $1 in
        01d) icon="";;  # day clear sky
        01n) icon="";;  # night clear sky
        02d) icon="";;  # day few clouds
        02n) icon="";;  # night few clouds
        03*) icon="";;  # day and night scattered clouds
        04*) icon="";;  # day and night broken clouds
        09d) icon="";;  # day shower rain
        09n) icon="";;  # night shower rain
        10d) icon="";;  # day rain
        10n) icon="";;  # night rain
        11d) icon="";;  # day thunderstorm
        11n) icon="";;  # night thunderstorm
        13d) icon="";;  # day snow
        13n) icon="";;  # night snow
        50d) icon="";;  # day mist
        50n) icon="";;  # night mist
        *) icon="";;   # unknown
    esac

    echo $icon
}

KEY="e434b5435a979de6e155570590bee89b"
CITY="Kharkiv"
UNITS="metric"
SYMBOL="°"
API="https://api.openweathermap.org/data/2.5"

if [ -n "$CITY" ]; then
    if [ "$CITY" -eq "$CITY" ] 2>/dev/null; then
        CITY_PARAM="id=$CITY"
    else
        CITY_PARAM="q=$CITY"
    fi

    weather=$(curl -sf "$API/weather?appid=$KEY&$CITY_PARAM&units=$UNITS")
else
    location=$(curl -sf https://location.services.mozilla.com/v1/geolocate?key=geoclue)

    if [ -n "$location" ]; then
        location_lat="$(echo "$location" | jq '.location.lat')"
        location_lon="$(echo "$location" | jq '.location.lng')"

        weather=$(curl -sf "$API/weather?appid=$KEY&lat=$location_lat&lon=$location_lon&units=$UNITS")
    fi
fi

if [ -n "$weather" ]; then
    weather_temp=$(echo "$weather" | jq ".main.temp" | cut -d "." -f 1)
    weather_icon=$(echo "$weather" | jq -r ".weather[0].icon")
    weather_description=$(echo "$weather" | jq -r ".weather[0].description")

    # Вывод для Waybar
    echo "$(get_icon "$weather_icon") $weather_temp$SYMBOL"
    
    # Вывод для tooltip
    echo "$weather_description" > ~/.config/hypr/themes/catppuccin/scripts/weather_tooltip.txt
fi
