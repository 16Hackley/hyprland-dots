#!/bin/sh

get_icon() {
    case $1 in
        01d) icon="";;    # Clear sky day
        01n) icon="";;    # Clear sky night
        02d) icon="";;    # Few clouds day
        02n) icon="";;    # Few clouds night
        03*) icon="";;    # Scattered clouds
        04*) icon="";;    # Broken clouds
        09d) icon="";;    # Shower rain day
        09n) icon="";;    # Shower rain night
        10d) icon="";;    # Rain day
        10n) icon="";;    # Rain night
        11d) icon="";;    # Thunderstorm day
        11n) icon="";;    # Thunderstorm night
        13d) icon="";;    # Snow day
        13n) icon="";;    # Snow night
        50d) icon="";;    # Mist day
        50n) icon="";;    # Mist night
        *) icon="";;     # Unknown
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

    echo "{\"text\":\"$(get_icon "$weather_icon") $weather_temp$SYMBOL\", \"tooltip\":\"$weather_description\"}"
fi
