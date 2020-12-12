#!/bin/bash

wifi_card_name="wlp7s0"

quality=$(grep $wifi_card_name /proc/net/wireless | awk '{ print int($3 * 100 / 70) }')

printf "<span font='Font Awesome'></span>"

if [[ -z "$quality" ]]; then 
    printf "<span color='#DD0000'> </span>\n"
fi

if [[ $quality -ge 80 ]]; then
    printf "<span color='#00BB00'>"
elif [[ $quality -ge 60 ]]; then
    printf "<span color='#FFF600'>"
elif [[ $quality -ge 40 ]]; then
    printf "<span color='#FFAE00'>"
else 
    printf "<span color='#DD0000'>"
fi

printf " $quality%%</span>\n"
