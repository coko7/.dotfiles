#!/usr/bin/env bash

SWWW_ANIM="random"

pick=$(kanumi list | rev | cut -d'/' -f2- | rev | sort -u \
    | fzf-rofi.sh --prompt='Directory> ' \
    --preview-window 'right:60%:wrap' --preview='fzf-img-dir-preview.sh {}' \
    --delimiter='/' --with-nth=6..)
[[ -z "$pick" ]] && exit 1

monitor_names=$(hyprctl monitors all -j | jq '.[].name' | tr -d '"')
for monitor in $monitor_names; do
    img=$(kanumi list --directories "$pick" | shuf | head -n 1)
    swww img -o "$monitor" "$img" -t $SWWW_ANIM
done
