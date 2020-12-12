#!/bin/bash

battery_name="Battery 0"

battery_level=$(acpi | grep "$battery_name" | awk '{print(int($4))}')
battery_status=$(acpi | grep "$battery_name" | awk '{print($3)}')

printf "<span font='Font Awesome'>"
if [[ $battery_level -ge 75 ]]; then
    printf "<span color='#00BB00'>"
elif [[ $battery_level -ge 50 ]]; then
    printf "<span color='#00BB00'>"
elif [[ $battery_level -ge 25 ]]; then
    printf "<span color='#FF7000'>"
elif [[ $battery_level -ge 10 ]]; then
    printf "<span color='#FFF600'>"
else 
    printf "<span color='#DD0000'>"
fi

printf " $battery_level%%</span></span>"

if [[ $battery_status =~ ^[Cc]harging ]]; then
    printf "<span font='Font Awesome'><span color='#FFF600'> </span></span>"
elif [[ $battery_status =~ ^[Ff]ull ]];then
    printf "<span font='Font Awesome'> </span>"
fi

printf "\n"
