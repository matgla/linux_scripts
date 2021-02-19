#!/bin/bash

# Terminate all already running polybars
killall -q polybar

# Wait until termination have been done

while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

sleep 2;

polybar top -c ~/.config/polybar/config.ini &
# polybar bottom&

echo "Polybar has been launched...."

