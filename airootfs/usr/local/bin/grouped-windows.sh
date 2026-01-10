#!/bin/bash
#
# Vérifie si jq est install
  if ! command -v jq &> /dev/null; then
  	echo "jq n'est pas installé. Installe-le avec: sudo pacman -S jq"
  	exit 1
  fi
# Récupère les fenêtres groupées
  WINDOWS=$(hyprctl clients -j | jq -r '
  .[] |
	  select(.grouped == true) |
	  "F \(.workspace.name) - \(.class) - (.title)"' 2>/dev/null)
  if [ -z "$WINDOWS" ]; then
	  WINDOWS="Aucune fenêtre groupée pour le moment"
  fi
# Affiche avec rofi
  echo -e "$WINDOWS" | rofi -dmenu -p "Fenêtres groupées" -theme ~/.config/rofi/launchers/type-1/style-1.rasi

