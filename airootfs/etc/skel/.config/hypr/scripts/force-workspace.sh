#!/bin/bash

WS=$1

if [ -z "$WS"; then
	echo "Usage: force-workspace.sh [numéro"
	exit 1
fi

# 1. Va au workspace
  hyprctl dispatch workspace $WS

# 2. Vérifie s\'il est vide
WINDOW_COUNT=$(hyprctl clients -j | jq "map(select(.workspace.id == $WS)) | length")

if [ "WINDOW_COUNT" -eq "o" ]; then
	echo "Workspace $WS vide - pourrait être nettoyé plus tard"
	# Passe au workspace suivant après délais sans interaction
	sleep 5 && hyprctl dispatch workspace next
fi
