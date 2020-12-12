#!/bin/bash
dir=$(dirname "$0")
music_name=$($dir/../i3blocks-contrib/mediaplayer/mediaplayer)
echo $music_name

printf "<span font='Font Awesome'>♪</span>"
printf "<span color='#00BB00'> $music_name</span>\n"
