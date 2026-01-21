#!/usr/bin/env bash

APP_URL="$1"
[[ -z "$APP_URL" ]] && echo "APP_NAME required!" && exit 1

DATA_DIR="$2"
[[ -z "$DATA_DIR" ]] && echo "DATA_DIR required!" && exit 1

VIMIUM_EXT_ID='dbepggeogbaibhgnhhndojpepiihcmeb'
VIMIUM_VERSION='2.3.1_0'
CHROMIUM_EXT_PATH="$XDG_CONFIG_HOME/chromium/Default/Extensions"

VIMIUM_EXT_PATH="$CHROMIUM_EXT_PATH/$VIMIUM_EXT_ID/$VIMIUM_VERSION"

/usr/bin/chromium \
    --app="$APP_URL" \
    --disable-features=WaylandWpColorManagerV1 \
    --user-data-dir="$XDG_CONFIG_HOME/chromium-work-outlook" \
    --load-extension="$VIMIUM_EXT_PATH"
