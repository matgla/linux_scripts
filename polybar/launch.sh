#!/bin/bash

# Terminate all already running polybars
killall -q polybar

# Wait until termination have been done

while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

polybar top&
polybar bottom&
polybar top_external&
polybar bottom_external&
polybar bottom_usb&

echo "Polybar has been launched...."

