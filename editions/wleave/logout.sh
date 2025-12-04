#!/usr/bin/env bash
hyprctl dispatch exit
sleep 1
systemctl --user restart sddm 2>/dev/null || systemctl restart sddm 2>/dev/null || loginctl terminate-session "$XDG_SESSION_ID" 2>/dev/null

