#!/bin/bash
CLASS="verso_taskmanager"

# 1. Vérification : Si le processus existe...
if pgrep -f "kitty --class $CLASS" > /dev/null; then
    # ... ALORS on le tue.
    pkill -f "kitty --class $CLASS"
    exit 0
fi
# (C'est ce "then" à la fin de la ligne "if" qui manquait probablement)

# 2. Sinon, on le lance avec la méthode magique
hyprctl dispatch exec "[float; size 800 500; center; pin; noanim] kitty --class $CLASS -e btop"
