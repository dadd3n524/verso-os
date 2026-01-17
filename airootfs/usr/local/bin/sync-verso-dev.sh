#!/bin/bash

# ==============================================================================
# 🔄 SYNC-VERSO-DEV : SYNCHRONISATION DEV -> ISO
# ==============================================================================

# --- CONFIGURATION ---
ISO_DIR="$HOME/verso-iso" # Chemin vers ton projet ISO
AIROOTFS="$ISO_DIR/airootfs" # La racine du système Live
SKEL="$AIROOTFS/etc/skel" # Le dossier "modèle" pour le /home/user
SKEL_CONFIG="$SKEL/.config" # Les configs utilisateur
BIN_DEST="$AIROOTFS/usr/local/bin" # Les scripts système

# --- COULEURS ---
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

# --- LISTE DES SCRIPTS (/usr/local/bin) ---
SCRIPTS_TO_SYNC=(
    "alfred" # Ton assistant IA
    "browser-home"
    "grouped-windows.sh"
    "menu_applis"
    "reload_interface"
    "safe_quit"
    "scroll"
    "smart_open"
    "sys_monitor"
    "toggle_audio"
    "toggle_backlight"
    "toggle_help"
    "toggle_power"
    "toggle_tasks"
    "verso_backlight_ui"
    "verso-browser"
    "verso-install-brave"
    "verso-loading"
    "verso_power_ui"
    "verso_search"
    "verso-update"
    "verso-welcome"
    "zapping.sh"
)

# --- LISTE DES DOSSIERS DE CONFIG (~/.config) ---
CONFIGS_TO_SYNC=(
    "hypr"
    "waybar"
    "kitty"
    "micro"
    "gtk-3.0"
    "dconf"
    "btop"
    "menus"
    "volumeicon"
    "mimeapps.list"
    "dolphinrc"
    "verso_help.txt"
)

# ==============================================================================
# 🚀 DÉBUT DU TRAITEMENT
# ==============================================================================
clear
echo -e "${BLUE}=========================================${NC}"
echo -e "${BLUE} SYNCHRONISATION VERSO OS (DEV -> ISO) ${NC}"
echo -e "${BLUE}=========================================${NC}"

# Vérification de sécurité
if [ ! -d "$AIROOTFS" ]; then
    echo -e "${RED}ERREUR CRITIQUE : Dossier airootfs introuvable dans $ISO_DIR${NC}"
    exit 1
fi

# ---------------------------------------------------------
# 1. COPIE DES SCRIPTS (BIN)
# ---------------------------------------------------------
echo ""
echo -e "${YELLOW}--> Synchronisation des scripts (/usr/local/bin)...${NC}"
mkdir -p "$BIN_DEST"

for item in "${SCRIPTS_TO_SYNC[@]}"; do
    if [ -f "/usr/local/bin/$item" ]; then
        cp -f "/usr/local/bin/$item" "$BIN_DEST/"
        echo -e " ✅ $item"
    else
        echo -e "${RED} ⚠️ SCRIPT MANQUANT : $item${NC}"
    fi
done

# Copie du script de sync lui-même (Backup)
cp -f "$0" "$BIN_DEST/sync-verso-dev.sh"
chmod +x "$BIN_DEST/"*

# ---------------------------------------------------------
# 2. COPIE DES CONFIGURATIONS (.config)
# ---------------------------------------------------------
echo ""
echo -e "${YELLOW}--> Synchronisation des configs (~/.config)...${NC}"
mkdir -p "$SKEL_CONFIG"

for item in "${CONFIGS_TO_SYNC[@]}"; do
    SRC="$HOME/.config/$item"
    DEST="$SKEL_CONFIG/$item"

    if [ -e "$SRC" ]; then
        rm -rf "$DEST"
        cp -r "$SRC" "$DEST"
        echo -e " ✅ $item"
    else
        echo -e "${RED} ⚠️ CONFIG MANQUANTE : $item${NC}"
    fi
done

# ---------------------------------------------------------
# 3. GESTION SPÉCIALE : IA LOCALE (Alfred & Llama)
# ---------------------------------------------------------
echo ""
echo -e "${YELLOW}--> Intégration de l'IA Locale (Alfred)...${NC}"

# Configuration de l'interface IA (cli.cpp)
LLAMA_SRC="$HOME/llama.cpp/tools/cli/cli.cpp"
LLAMA_DEST_DIR="$SKEL/llama.cpp/tools/cli"

if [ -f "$LLAMA_SRC" ]; then
    mkdir -p "$LLAMA_DEST_DIR"
    cp "$LLAMA_SRC" "$LLAMA_DEST_DIR/"
    echo -e " ✅ Config IA copiée : ~/llama.cpp/tools/cli/cli.cpp"
else
    echo -e "${RED} ⚠️ FICHIER IA MANQUANT : $LLAMA_SRC${NC}"
fi

# ---------------------------------------------------------
# 4. GESTION SPÉCIALE DE BRAVE
# ---------------------------------------------------------
echo ""
echo -e "${YELLOW}--> Exportation propre de Brave Browser...${NC}"

BRAVE_SRC="$HOME/.config/BraveSoftware/Brave-Browser"
BRAVE_DEST="$SKEL_CONFIG/BraveSoftware/Brave-Browser"

if [ -d "$BRAVE_SRC" ]; then
    mkdir -p "$BRAVE_DEST/Default"
    # Paramètres globaux
    [ -f "$BRAVE_SRC/Local State" ] && cp "$BRAVE_SRC/Local State" "$BRAVE_DEST/" && echo -e " ✅ Local State"
    # Paramètres UI (Dark mode, etc) - Sans mots de passe
    [ -f "$BRAVE_SRC/Default/Preferences" ] && cp "$BRAVE_SRC/Default/Preferences" "$BRAVE_DEST/Default/" && echo -e " ✅ Preferences"
else
    echo -e "${RED} ⚠️ Dossier Brave introuvable.${NC}"
fi

# ---------------------------------------------------------
# 5. FICHIERS TERMINAL (.bashrc, etc)
# ---------------------------------------------------------
echo ""
echo -e "${YELLOW}--> Synchronisation du Terminal (Bashrc)...${NC}"

# .bashrc (Essentiel pour les couleurs, les alias, le prompt)
if [ -f "$HOME/.bashrc" ]; then
    cp "$HOME/.bashrc" "$SKEL/.bashrc"
    echo -e " ✅ .bashrc (Alias et Prompt)"
else
    echo -e "${RED} ⚠️ .bashrc introuvable !${NC}"
fi

# .bash_profile (Souvent nécessaire pour lancer startx ou charger .bashrc)
if [ -f "$HOME/.bash_profile" ]; then
    cp "$HOME/.bash_profile" "$SKEL/.bash_profile"
    echo -e " ✅ .bash_profile"
fi

echo ""
echo -e "${BLUE}=========================================${NC}"
echo -e "${GREEN} SYNCHRONISATION TERMINÉE ! 🚀 ${NC}"
echo -e "${BLUE}=========================================${NC}"
