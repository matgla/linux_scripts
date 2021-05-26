#!/bin/bash

# Terminate all already running polybars
killall -q polybar

# Wait until termination have been done

while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

sleep 2;

polybar top -c ~/.config/polybar/config.ini &
polybar bot -c ~/.config/polybar/config.ini &
# polybar bottom&

external_monitor=$(xrandr --query | grep 'DisplayPort-0')
if [[ $external_monitor = DisplayPort-0\ connected* ]]; then 
    echo "Found external screen"
    #polybar secondary -c ~/.config/polybar/config.ini &
fi

echo "Polybar has been launched...."

