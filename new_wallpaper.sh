#!/bin/sh

WALLPAPERS=$1
INTERVAL=$2

while true; do
    feh --bg-scale -R 1 --randomize $WALLPAPERS
    sleep $INTERVAL
done 
