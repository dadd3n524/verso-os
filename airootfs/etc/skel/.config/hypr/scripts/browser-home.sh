#!/bin/bash
PLEX_URL="https://app.plex.tv/desktop"
echo "Bouton HomeBrowser pressé..."
echo "Ouverture de Plex dans Workspace 8..."
brave "$PLEX_URL" &
BRAVE_PID=$!
echo "Attente du navigateur Brave..."
for i in {1..10}; do
	if hyprctl clients -j | grep -qi "brave"; then
		echo "Démarrage du navigateur Brave... ($i/10)"
		break
	fi
	sleep 0.5
done

echo "Déplacement sur workspace 8..."
hyprctl dispatch movetoworkspace 8, class:brave-browser
sleep 0.3
hyprctl dispatch focuswindow class:brave-browser
if command -v notify-send &> /dev/null; then
	notify-send "Plex" "Ouvert sur workspace 8" -i video-display
fi

echo "Plex prêt sur workspace 8 !"
