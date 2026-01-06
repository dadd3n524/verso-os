#!/bin/bash

# --- COULEURS ---
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

clear
echo -e "${BLUE}=========================================${NC}"
echo -e "${BLUE} PATCH DE MISE À JOUR - VERSO OS V1 ${NC}"
echo -e "${BLUE}=========================================${NC}"
echo ""

# Une fois Verso OS installé, pour obtenir Brave et les derniers correctifs, tapez :
# wget https://github.com/dadd3n524/verso-os/releases/download/v1.0/patch-v1.sh
# chmod +x patch-v1.sh
# ./patch-v1.sh

# 1. Vérification : NE PAS LANCER EN ROOT
# (Car makepkg/yay refuse de tourner en root par sécurité)
if [ "$EUID" -eq 0 ]; then
  echo -e "${RED}Erreur : Ne lancez pas ce script avec 'sudo'.${NC}"
  echo "Lancez-le simplement : ./patch-v1.sh"
  echo "Le mot de passe sera demandé quand nécessaire."
  exit 1
fi

echo -e "${YELLOW}--> Mise à jour des bases de données...${NC}"
sudo pacman -Syu --noconfirm

# 2. Installation de YAY (Indispensable pour Brave & AUR)
if ! command -v yay &> /dev/null; then
    echo -e "${GREEN}--> Installation de l'assistant AUR (yay)...${NC}"
    # On s'assure d'avoir git et base-devel
    sudo pacman -S --needed --noconfirm git base-devel
    
    # On clone et compile yay
    git clone https://aur.archlinux.org/yay.git
    cd yay
    makepkg -si --noconfirm
    cd ..
    rm -rf yay
    echo -e "${GREEN}--> Yay installé avec succès !${NC}"
else
    echo -e "${GREEN}--> Yay est déjà installé.${NC}"
fi

# 3. Installation des logiciels manquants
echo -e "${YELLOW}--> Installation de Brave Browser...${NC}"
# On prend 'brave-bin' pour que ce soit rapide (pas de compilation)
yay -S --noconfirm brave-bin

# TU PEUX AJOUTER D'AUTRES LOGICIELS ICI :
# echo -e "${YELLOW}--> Installation de Autres trucs...${NC}"
# yay -S --noconfirm neofetch htop visual-studio-code-bin

# 4. Correctifs de configuration (Optionnel)
# Si tu as mis à jour tes dotfiles sur GitHub, tu peux les récupérer ici
# echo -e "${YELLOW}--> Mise à jour des configs...${NC}"
# git clone https://github.com/ton-nom/verso-os-configs.git temp_configs
# cp -r temp_configs/* ~/.config/
# rm -rf temp_configs

echo ""
echo -e "${BLUE}=========================================${NC}"
echo -e "${GREEN} PATCH TERMINÉ ! TOUT EST À JOUR. 🚀 ${NC}"
echo -e "${BLUE}=========================================${NC}"
