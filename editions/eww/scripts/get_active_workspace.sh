#!/bin/bash
# Script para obtener el workspace activo de Hyprland para EWW

hyprctl monitors -j | jq '.[0].activeWorkspace.id'
