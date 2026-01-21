#!/usr/bin/env bash

DIRECTORY="${1:-}"
[[ -z "$DIRECTORY" ]] && echo "expected directory as \$1" && exit 1
[[ ! -d "$DIRECTORY" ]] && echo "not a directory: $1" && exit 1

images=$(kanumi list --directories "$DIRECTORY" | head -5)
[[ -z "$images" ]] && exit 1

echo "$images" | while IFS= read -r img; do
    echo "$img" | rev | cut -d'/' -f1 | rev
    chafa -s 50x30 --format=symbols "$img" 2>/dev/null \
        || kitty +kitten icat --align=left "$img" 2>/dev/null \
        || echo "[Preview unavailable]"
done
