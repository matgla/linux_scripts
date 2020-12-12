#!/bin/bash

ram_usage=$(free -m | awk 'FNR == 2 {printf(int($3/$2*100))}')

printf "<span font='Font Awesome'></span>"

if [[ $ram_usage -ge 98 ]]; then
    printf "<span color='#DD0000'>"
elif [[ $ram_usage -ge 80 ]]; then
    printf "<span color='#FFAE00'>"
elif [[ $ram_usage -ge 70 ]]; then
    printf "<span color='#FFF600'>"
else 
    printf "<span color='#00BB00'>"
fi

printf " $ram_usage%%</span>\n"
