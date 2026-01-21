#!/usr/bin/env bash

DIRECTORY=$1

[[ -z $DIRECTORY ]] && DIRECTORY="$HOME/Downloads"
[[ ! -d $DIRECTORY ]] && echo "error: not a directory '$DIRECTORY'" && exit 1

mapfile -t selected_files < <(find "$DIRECTORY" -type f -printf '%T@ %p\n' \
    | sort -nr \
    | cut -d' ' -f2- \
    | fzf --height 80% \
    --delimiter '/' --with-nth 5.. --multi \
    --header 'CTRL-O to open in Web browser / CTRL-Y to yank to clipboard' \
    --bind 'ctrl-o:execute-silent(xdg-open {})' \
    --bind 'ctrl-y:execute-silent(wl-copy {})' \
    --preview="fzf-preview.sh {}")

[[ ${#selected_files[@]} -eq 0 ]] && exit 0

for file in "${selected_files[@]}"; do
    [[ ! -f $file ]] && echo "error: no such file '$file'" && exit 1
    mv "$file" . && echo "🪝 moved '$file' to '$(pwd)'"
done

