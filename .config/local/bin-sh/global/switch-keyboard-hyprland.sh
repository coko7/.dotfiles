#!/usr/bin/env bash

function notif() {
    local title=$1
    local body=$2
    local img="$HOME/Pictures/System/$3"
    local time=$4

    notify-send -u low "$title" "$body" \
        -i "$img" -t "$time" \
        -h string:x-canonical-private-synchronous:sw-kb --transient
}

function set_fr_azerty() {
    hyprkeyb.sh set-layout "fr" \
        && notif "Keyboard Layout" "AZERTY Baguette" "azerty_icon2.png" 2000
}

function set_us_qwerty() {
    echo "bye"
    hyprkeyb.sh set-layout "us" \
        && notif "Keyboard Layout" "QWERTY Burger" "kb_us_qwerty3.png" 2000
}

function set_fr_ergol() {
    echo "hello"
    hyprkeyb.sh set-layout "ergol" \
        && notif "Keyboard Layout" "Ergo-L Rocket" "ergol.png" 2000
}

# function set_us_dvorak() {
#     hyprkeyb.sh set-layout "dvorak" \
#         && notif "Keyboard Layout" "QWERTY Dvorak" "kb_us_dvorak.png" 2000
# }

if [ -n "$1" ]; then
    if [ "$1" == "ergol" ]; then
        set_fr_ergol
        exit 0
    fi
fi

current_layout=$(hyprkeyb.sh get-active-layout)

if [ "$current_layout" == "English (US)" ]; then
    echo "switch to erg"
    set_fr_ergol
# elif [ "$current_layout" == "English (Dvorak)" ]; then
#     set_us_qwerty
else
    echo "switch to qwert"
    set_us_qwerty
fi
