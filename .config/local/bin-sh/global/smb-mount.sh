#!/usr/bin/env bash

source "$SCRIPTS/bash-colors.sh"

echo "SMntB" | figlet | lolcat -S 42

server_ip=$(gum input --prompt="Server IP> ") || exit 1

if ! gum spin --title="Pinging $server_ip..." -- ping -c1 "$server_ip"; then
    echo -e "💀 ${FG_RED}Failed to ping: $server_ip"
    exit 1
fi

smb_username=$(gum input --prompt="Username> ") || exit 1
smb_password=$(gum input --prompt="Password> " --password) || exit 1

smb_shares_raw=$(gum spin --title="Connecting to smb://$server_ip..." \
    -- smbclient -L "$server_ip" --user="$smb_username" --password="$smb_password")
if [[ $? -ne 0 ]]; then
    echo -e "💀 ${FG_RED}Failed to connect to: smb://$server_ip"
    exit 1
fi

smb_shares=$(echo "$smb_shares_raw" \
    | grep 'Disk' | cut -d' ' -f1 \
    | awk '{$1=$1; print}' | sort)

echo -e "✨ ${FG_GREEN}Connected to: smb://$server_ip!"
share_pick=$(echo "$smb_shares" | gum choose --header="Select SMB share:") || exit 1
smb_mount_path="/mnt/smbshare/$server_ip/$share_pick"

if mountpoint -q "$smb_mount_path"; then
    echo "⛰️ $share_pick is already mounted at: $smb_mount_path"
    if gum confirm "Do you want to unmount it?"; then
        sudo umount "$smb_mount_path"
        echo -e "❎ ${FG_GREEN}'$share_pick' has been unmounted"
    fi

    exit 0
fi

smb_mount_path=$(gum input --prompt="⛰️ Mount point for $share_pick> " --value="$smb_mount_path") || exit 1
if ! gum confirm "Mount $share_pick to: $smb_mount_path?"; then
    exit 0
fi

unix_user=$(whoami)

sudo -v || exit 1

# uid is needed to correctly setup file permissions and allow the current user to edit the remote files
gum spin --title="Mounting $share_pick to $smb_mount_path..." \
    -- sudo mount --mkdir -t cifs "//$server_ip/$share_pick" "$smb_mount_path" \
    -o "uid=$unix_user,username=$smb_username,password=$smb_password,vers=2.0"

echo -e "✅ ${FG_GREEN}'$share_pick' has been mounted!"
