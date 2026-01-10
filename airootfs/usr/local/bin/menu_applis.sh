#!/bin/bash
# On définit la liste des options
CHOIX=$(echo -e "🚀 Lancer Steam\n📁 Gestionnaire de fichiers\n🌐 Navigateur\n🔧 Paramètres" | wofi --show dmenu --prompt "Outils")

# On définit les actions
case "$CHOIX" in
    "🚀 Lancer Steam") steam ;;
    "📁 Gestionnaire de fichiers") thunar ;; # ou dolphin/nautilus selon ton install
    "🌐 Navigateur") brave ;;
    "🔧 Paramètres") lxappearance ;;
esac
