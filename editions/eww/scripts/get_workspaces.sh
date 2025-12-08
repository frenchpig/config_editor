#!/bin/bash
# Script para obtener workspaces de Hyprland para EWW

hyprctl workspaces -j | jq -c '[.[] | {id: .id, name: .name, windows: .windows}] | sort_by(.id) | .[:10]'
