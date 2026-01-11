#!/bin/bash
CLASS="verso_mixer"

# 1. Gestion du Toggle (Fermer si ouvert) - On ne change rien ici
if pgrep -f "kitty --class $CLASS" > /dev/null; then
    pkill -f "kitty --class $CLASS"
    exit 0
fi

# 2. LE LANCEMENT MAGIQUE (V3)
# On utilise "hyprctl dispatch exec" pour que ce soit le compositeur qui lance l'app.
# L'argument entre crochets [ ... ] applique les règles INSTANTANÉMENT (sans délai, sans script complexe).
# Le "noanim" évite l'effet de zoom désagréable pour un menu.

hyprctl dispatch exec "[float; size 600 300; center; pin; noanim] kitty --class $CLASS -e pulsemixer"
