#!/bin/bash

# --- CONFIGURATION ---
SAVED_TERM=$(stty -g)
cleanup() {
    tput cnorm
    stty "$SAVED_TERM"
    clear
    exit
}
trap cleanup SIGINT SIGTERM EXIT
tput civis
stty -echo
clear

# --- FONCTION CENTRAGE ---
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
    # 1. Récupération des données (Upower & PowerProfiles)
    # On cherche la batterie (souvent BAT0 ou BAT1)
    BAT=$(upower -e | grep BAT | head -n 1)
    
    STATUS=$(upower -i $BAT | grep "state" | awk '{print $2}')
    PERCENT=$(upower -i $BAT | grep "percentage" | awk '{print $2}')
    TIME=$(upower -i $BAT | grep "time to" | awk -F: '{print $2}' | xargs) # xargs retire les espaces
    if [ -z "$TIME" ]; then TIME="Calcul en cours..."; fi
    
    # Consommation en Watts (Parfois appelé energy-rate)
    WATTS=$(upower -i $BAT | grep "energy-rate" | awk '{print $2, $3}')
    
    # Profil actuel (performance, balanced, power-saver)
    PROFILE=$(powerprofilesctl get)

    # Couleurs dynamiques
    COLOR_PROF="\033[1;34m" # Bleu par défaut
    if [ "$PROFILE" == "power-saver" ]; then COLOR_PROF="\033[1;32m"; fi # Vert
    if [ "$PROFILE" == "performance" ]; then COLOR_PROF="\033[1;31m"; fi # Rouge

    # 2. Calculs Position
    LINES=$(tput lines)
    START_Y=$(( (LINES - 11) / 2 )) # Interface plus haute (11 lignes)
    if [[ $START_Y -lt 0 ]]; then START_Y=0; fi

    # 3. Affichage
    print_centered $((START_Y + 0)) "\033[1;33m⚡ VERSO POWER CENTER\033[0m"
    print_centered $((START_Y + 1)) "---------------------"
    
    print_centered $((START_Y + 3)) "Batterie : $PERCENT ($STATUS)"
    print_centered $((START_Y + 4)) "Autonomie : $TIME"
    print_centered $((START_Y + 5)) "Conso. : $WATTS"
    
    print_centered $((START_Y + 7)) "Profil Actuel : ${COLOR_PROF}${PROFILE}\033[0m"
    
    print_centered $((START_Y + 9)) "[1] Éco [2] Normal [3] Perf"
    print_centered $((START_Y + 10)) "\033[1mq\033[0m : Quitter"
}

# --- BOUCLE PRINCIPALE ---
while true; do
    draw_ui
    read -rsn1 key
    
    case "$key" in
        "1") powerprofilesctl set power-saver ;;
        "2") powerprofilesctl set balanced ;;
        "3") powerprofilesctl set performance ;;
        "q"|"Q") cleanup ;;
        *) ;;
    esac
    
    # Petit délai pour laisser le temps à upower de se mettre à jour si on débranche
    sleep 0.1 
done
