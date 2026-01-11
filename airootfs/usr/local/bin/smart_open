#!/bin/bash

CMD=$1

# 1. Compte le nombre de fenêtres sur le workspace actuel
# On utilise json pour être précis
WINDOW_COUNT=$(hyprctl activeworkspace -j | jq '.windows')

# 2. Logique de décision
if [ "$WINDOW_COUNT" -gt 0 ]; then
    # C'est OCCUPÉ !
    # On va vers le premier workspace vide
    hyprctl dispatch workspace empty
    # On lance l'app
    hyprctl dispatch exec "$CMD"
else
    # C'est LIBRE !
    # On lance juste l'app ici
    hyprctl dispatch exec "$CMD"
fi
