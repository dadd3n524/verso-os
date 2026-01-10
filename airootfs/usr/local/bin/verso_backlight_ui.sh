#!/bin/bash

# --- CONFIGURATION BLINDÉE ---
# 1. On sauvegarde l'état du terminal pour le remettre normal après
SAVED_TERM=$(stty -g)

# 2. Fonction de nettoyage (S'exécute quand on quitte)
cleanup() {
    tput cnorm # Remet le curseur
    stty "$SAVED_TERM" # Remet le terminal normal (Affiche les touches)
    clear # Nettoie tout en sortant
    exit
}
trap cleanup SIGINT SIGTERM EXIT

# 3. MODE SILENCIEUX (C'est la clé du fix !)
tput civis # Cache le curseur
stty -echo # EMPÊCHE L'AFFICHAGE DES TOUCHES (Stop ^[[A)

# --- MOTEUR GRAPHIQUE ---
clear # On efface une seule fois au début

print_centered() {
    local row=$1
    local text="$2"
    local clean_text=$(echo -e "$text" | sed "s/\x1B\[[0-9;]*[a-zA-Z]//g")
    local len=${#clean_text}
    local cols=$(tput cols)
    local col=$(( (cols - len) / 2 ))
    if [[ $col -lt 0 ]]; then col=0; fi

    tput cup $row $col
    echo -e "$text"
}

draw_ui() {
    PERC=$(brightnessctl -m | cut -d, -f4 | tr -d %)
    
    # Barre de chargement
    BLOCKS=$((PERC / 5))
    BAR=""
    for ((i=0; i<BLOCKS; i++)); do BAR="${BAR}█"; done
    for ((i=BLOCKS; i<20; i++)); do BAR="${BAR}░"; done

    # Calcul position verticale
    LINES=$(tput lines)
    START_Y=$(( (LINES - 8) / 2 ))
    if [[ $START_Y -lt 0 ]]; then START_Y=0; fi

    # Affichage
    print_centered $((START_Y + 0)) "\033[1;33m☀ VERSO DISPLAY\033[0m"
    print_centered $((START_Y + 1)) "-------------------"
    print_centered $((START_Y + 3)) "Luminosité : $PERC% " # Espaces pour effacer si ça réduit (100 -> 99)
    print_centered $((START_Y + 4)) "[${BAR}]"
    print_centered $((START_Y + 6)) "\033[1m↑\033[0m : Plus \033[1m↓\033[0m : Moins"
    print_centered $((START_Y + 7)) "\033[1mq\033[0m : Quitter"
}

# --- BOUCLE PRINCIPALE ---
while true; do
    draw_ui
    
    # Lecture silencieuse
    read -rsn1 key
    
    # Gestion des flèches (Escape sequences)
    if [[ "$key" == $'\x1b' ]]; then
        read -rsn2 -t 0.1 key # Petit timeout pour éviter de bloquer
        case "$key" in
            '[A') key="+" ;;
            '[B') key="-" ;;
        esac
    fi

    case "$key" in
        "+"|"=") brightnessctl s +5% > /dev/null ;;
        "-"|"_") brightnessctl s 5%- > /dev/null ;;
        "q"|"Q") cleanup ;; # Appelle la fonction de sortie propre
        *) ;;
    esac
done
