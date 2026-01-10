#!/bin/bash
CLASS="verso_help"
FILE="$HOME/.config/verso_help.txt"

# 1. Si ouvert -> Fermer
if pgrep -f "kitty --class $CLASS" > /dev/null; then
    pkill -f "kitty --class $CLASS"
    exit 0
fi

# 2. Si fermé -> Ouvrir
# On lance kitty qui exécute 'less' sur ton fichier
# 'less +G' irait à la fin, ici on veut le début.
# On cache la barre de scroll latérale de kitty pour faire propre.
hyprctl dispatch exec "[float; size 600 700; center; pin; noanim] kitty --class $CLASS -e less  $FILE"
