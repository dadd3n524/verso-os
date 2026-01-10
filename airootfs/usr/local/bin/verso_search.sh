#!/bin/bash

# Fonction pour nettoyer l'écran et mettre un titre
header() {
    clear
    echo -e "\n 🔍 \033[1;36mVERSO SEARCH\033[0m\n"
}

header
# 1. Demander le NOM du fichier (ou une partie du nom)
echo -e "Entrez le nom du fichier à chercher :"
read -p "📝 > " FILENAME

header
# 2. Demander le DOSSIER (Entrée = Dossier personnel)
echo -e "Dans quel dossier ? (Laisser vide pour $HOME)"
read -e -p "📂 > " TARGET_DIR
# Si vide, on met le HOME
TARGET_DIR=${TARGET_DIR:-$HOME}

# Petit message d'attente
echo -e "\nRecherche de '$FILENAME' dans '$TARGET_DIR'..."

# 3. LA RECHERCHE INTELLIGENTE
# Explication de la commande complexe :
# - find : cherche partout
# - 2>/dev/null : cache les erreurs de permission
# - awk '{ print length, $0 }' : calcule la longueur du chemin (pour le tri)
# - sort -n -s : trie par longueur (les fichiers dans le dossier racine seront + courts donc en premier !)
# - cut : retire le nombre de longueur pour ne garder que le chemin
# - fzf : affiche le menu interactif

SELECTED=$(find "$TARGET_DIR" -iname "*$FILENAME*" 2>/dev/null \
    | awk '{ print length, $0 }' \
    | sort -n -s \
    | cut -d" " -f2- \
    | fzf --prompt="Resultats > " --height=100% --layout=reverse --border --info=inline)

# 4. OUVERTURE DU FICHIER
if [ -n "$SELECTED" ]; then
    # xdg-open ouvre le fichier avec l'app par défaut (PDF avec lecteur PDF, image avec viewer, etc)
    # nohup ... & permet de fermer la fenêtre de recherche sans fermer le fichier ouvert
    nohup xdg-open "$SELECTED" >/dev/null 2>&1 &
    exit 0
fi
