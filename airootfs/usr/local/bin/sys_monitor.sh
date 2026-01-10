#!/bin/bash

# Fichier temporaire pour se souvenir du mode actuel (cpu, mem, ou temp)
STATE_FILE="/tmp/verso_sys_state"

# --- 1. GESTION DU CLIC (CHANGEMENT DE MODE) ---
if [ "$1" == "toggle" ]; then
    CURRENT=$(cat "$STATE_FILE" 2>/dev/null || echo "cpu")
    
    # Cycle : CPU -> RAM -> TEMP -> CPU
    if [ "$CURRENT" == "cpu" ]; then
        echo "mem" > "$STATE_FILE"
    elif [ "$CURRENT" == "mem" ]; then
        echo "temp" > "$STATE_FILE"
    else
        echo "cpu" > "$STATE_FILE"
    fi
    
    # Signal spécial pour dire à Waybar de rafraîchir l'affichage TOUT DE SUITE
    pkill -RTMIN+8 waybar
    exit 0
fi

# --- 2. AFFICHAGE DES DONNÉES ---
MODE=$(cat "$STATE_FILE" 2>/dev/null || echo "cpu")

if [ "$MODE" == "cpu" ]; then
    # Récupère l'utilisation CPU (via top, méthode légère)
    # On additionne User + System pour avoir le total
    VAL=$(top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100 - $1}')
    VAL=$(printf "%.0f" $VAL) # Arrondi
    echo "{\"text\": \"$VAL% \", \"tooltip\": \"Processeur (Clic: Switch / Droit: Tasks)\", \"class\": \"cpu\"}"

elif [ "$MODE" == "mem" ]; then
    # Récupère la RAM utilisée
    VAL=$(free | grep Mem | awk '{print int($3/$2 * 100)}')
    echo "{\"text\": \"$VAL% \", \"tooltip\": \"Mémoire RAM (Clic: Switch / Droit: Tasks)\", \"class\": \"memory\"}"

else
    # Récupère la température (zone0 est souvent le CPU sur les laptops)
    VAL=$(cat /sys/class/thermal/thermal_zone*/temp 2>/dev/null | head -n1 | awk '{print int($1/1000)}')
    if [ -z "$VAL" ]; then VAL="??"; fi
    echo "{\"text\": \"$VAL°C \", \"tooltip\": \"Température (Clic: Switch / Droit: Tasks)\", \"class\": \"temp\"}"
fi
