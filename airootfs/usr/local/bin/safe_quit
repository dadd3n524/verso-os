# 1. On récupère la "classe" de la fenêtre active (ex: kitty, steam_app_2340, brave)
ACTIVE_WINDOW=$(hyprctl activewindow -j)
CLASS=$(echo "$ACTIVE_WINDOW" | jq -r ".class")

# 2. Liste noire : Si le nom contient "steam_app", c'est un jeu Steam -> ON NE TOUCHE PAS
if [[ "$CLASS" == *"steam_app"* ]] || [[ "$CLASS" == "gamescope" ]]; then
    notify-send -t 2000 "⚠️ Sécurité" "Fermeture bloquée (Jeu détecté)"
    exit 0
fi

# 3. Si ce n'est pas un jeu, on tue la fenêtre
hyprctl dispatch killactive
