#!/bin/bash

# --- CONFIGURATION ---
IMG="/usr/share/backgrounds/verso_banner.jpg"
LOCKFILE="$HOME/.config/verso-setup-done"

# Si le fichier témoin existe, on arrête tout
if [ -f "$LOCKFILE" ]; then
    exit 0
fi

# Attend que Hyprland soit bien chargé
sleep 2

# --- BOUCLE DE DEMANDE DE MOT DE PASSE ---
while true; do
    # 1. Fenêtre de demande
    PASS=$(yad --entry \
        --title="Bienvenue sur Verso OS" \
        --window-icon="system-software-update" \
        --image="$IMG" \
        --image-on-top \
        --text="Configuration initiale.\nVeuillez choisir votre mot de passe:" \
        --hide-text \
        --button="Annuler:1" \
        --button="Valider:0" \
        --width=500 --center)

    RET=$? # Récupère le code du bouton cliqué

    # 2. Gestion de l'annulation (Si l'utilisateur clique sur Annuler ou ferme la fenêtre)
    if [ $RET -ne 0 ]; then
        notify-send "Verso OS" "Configuration annulée. Vous pourrez la relancer plus tard."
        exit 0
    fi

    # 3. Vérification du mot de passe
    # Teste 'sudo' avec le mot de passe fourni.
    # -S : lit le mdp depuis l'echo
    # -v : valide seulement (ne lance pas de commande)
    # -k : force l'oubli du cache précédent pour être sûr de tester ce mot de passe
    # 2> /dev/null : cache les messages d'erreur techniques
    if echo "$PASS" | sudo -S -v -k 2> /dev/null; then
        # APPROUVÉ : Le mot de passe est confirmé
        break
    else
        # REFUSÉ : Affiche une erreur et la boucle recommence
        yad --error \
            --title="Erreur d'authentification" \
            --text="<b>Mot de passe incorrect !</b>\nVeuillez réessayer." \
            --width=300 --center \
            --button="OK:0"
    fi
done

# --- LANCEMENT DE LA MISE À JOUR ---
(
    echo "10" ; sleep 1
    echo "# Vérification de la connexion internet..." ; sleep 1
    
    echo "20"
    echo "# Mise à jour des dépôts..."
    # On utilise le mot de passe validé pour lancer pacman
    echo "$PASS" | sudo -S pacman -Sy --noconfirm
    
    echo "40"
    echo "# Installation des correctifs..."
    # Exemple : Installation de yay si nécessaire
    # echo "$PASS" | sudo -S pacman -S --noconfirm git base-devel
    
    echo "80"
    echo "# Nettoyage du système..."
    sleep 1
    
    echo "100"
    echo "# Verso OS est prêt à l'emploi !"
    sleep 2
) | yad --progress \
    --title="Initialisation Verso OS" \
    --image="$IMG" \
    --image-on-top \
    --percentage=0 \
    --width=500 --center \
    --no-buttons \
    --auto-close

# --- FINALISATION ---
# Création du fichier témoin pour ne plus jamais lancer ce script
touch "$LOCKFILE"

notify-send "Verso OS" "Configuration terminée avec succès !"
