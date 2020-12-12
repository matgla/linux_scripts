#!/bin/bash

cpu_usage=$(mpstat 1 1 | awk 'FNR == 5 {print(int(100-$12))}')

printf "<span font='Font Awesome'></span>"

if [[ $cpu_usage -ge 98 ]]; then
    printf "<span color='#DD0000'>"
elif [[ $cpu_usage -ge 80 ]]; then
    printf "<span color='#FFAE00'>"
elif [[ $cpu_usage -ge 70 ]]; then
    printf "<span color='#FFF600'>"
else 
    printf "<span color='#00BB00'>"
fi

printf " $cpu_usage%%</span>\n"
