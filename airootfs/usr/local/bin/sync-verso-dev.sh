#!/bin/bash

# ==============================================================================
# 🔄 SYNC-VERSO-DEV : SYNCHRONISATION DEV -> ISO
# ==============================================================================

# --- CONFIGURATION ---
ISO_DIR="$HOME/verso-iso"
AIROOTFS="$ISO_DIR/airootfs"
SKEL="$AIROOTFS/etc/skel"
SKEL_CONFIG="$SKEL/.config"
BIN_DEST="$AIROOTFS/usr/local/bin"

# --- COULEURS ---
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

# --- LISTE DES SCRIPTS (/usr/local/bin) ---
SCRIPTS_TO_SYNC=(
    "alfred"
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
    "hypr" "waybar" "kitty" "micro" "gtk-3.0" "dconf"
    "btop" "menus" "volumeicon" "mimeapps.list" "dolphinrc"
    "verso_help.txt"
)

# ==============================================================================
# 🚀 DÉBUT DU TRAITEMENT
# ==============================================================================
clear
echo -e "${BLUE}=========================================${NC}"
echo -e "${BLUE} SYNCHRONISATION VERSO OS (DEV -> ISO) ${NC}"
echo -e "${BLUE}=========================================${NC}"

if [ ! -d "$AIROOTFS" ]; then
    echo -e "${RED}ERREUR : Dossier airootfs introuvable dans $ISO_DIR${NC}"
    exit 1
fi

# 1. SCRIPTS
echo -e "${YELLOW}--> Synchronisation des scripts...${NC}"
mkdir -p "$BIN_DEST"
for item in "${SCRIPTS_TO_SYNC[@]}"; do
    if [ -f "/usr/local/bin/$item" ]; then
        cp -f "/usr/local/bin/$item" "$BIN_DEST/"
        echo -e " ✅ $item"
    else
        echo -e "${RED} ⚠️ MANQUANT : $item${NC}"
    fi
done
cp -f "$0" "$BIN_DEST/sync-verso-dev.sh"
chmod +x "$BIN_DEST/"*

# 2. CONFIGS
echo ""
echo -e "${YELLOW}--> Synchronisation des configs...${NC}"
mkdir -p "$SKEL_CONFIG"
for item in "${CONFIGS_TO_SYNC[@]}"; do
    SRC="$HOME/.config/$item"
    DEST="$SKEL_CONFIG/$item"
    if [ -e "$SRC" ]; then
        rm -rf "$DEST"
        cp -r "$SRC" "$DEST"
        echo -e " ✅ $item"
    fi
done

# 3. IA LOCALE
echo ""
echo -e "${YELLOW}--> Intégration Alfred/Llama...${NC}"
LLAMA_SRC="$HOME/llama.cpp/tools/cli/cli.cpp"
LLAMA_DEST_DIR="$SKEL/llama.cpp/tools/cli"
if [ -f "$LLAMA_SRC" ]; then
    mkdir -p "$LLAMA_DEST_DIR"
    cp "$LLAMA_SRC" "$LLAMA_DEST_DIR/"
    echo -e " ✅ cli.cpp"
fi

# 4. BRAVE
echo ""
echo -e "${YELLOW}--> Exportation Brave (Clean)...${NC}"
BRAVE_SRC="$HOME/.config/BraveSoftware/Brave-Browser"
BRAVE_DEST="$SKEL_CONFIG/BraveSoftware/Brave-Browser"
if [ -d "$BRAVE_SRC" ]; then
    mkdir -p "$BRAVE_DEST/Default"
    [ -f "$BRAVE_SRC/Local State" ] && cp "$BRAVE_SRC/Local State" "$BRAVE_DEST/"
    [ -f "$BRAVE_SRC/Default/Preferences" ] && cp "$BRAVE_SRC/Default/Preferences" "$BRAVE_DEST/Default/"
    echo -e " ✅ Paramètres Brave copiés"
fi

# 5. TERMINAL
echo ""
echo -e "${YELLOW}--> Bashrc & Profil...${NC}"
[ -f "$HOME/.bashrc" ] && cp "$HOME/.bashrc" "$SKEL/.bashrc" && echo " ✅ .bashrc"
[ -f "$HOME/.bash_profile" ] && cp "$HOME/.bash_profile" "$SKEL/.bash_profile" && echo " ✅ .bash_profile"

# ---------------------------------------------------------
# 6. EXTRACTION DES LISTES DE PAQUETS (NOUVEAU)
# ---------------------------------------------------------
echo ""
echo -e "${YELLOW}--> Génération des listes de paquets...${NC}"

# Paquets officiels (Explicites)
pacman -Qneq > "$ISO_DIR/pkglist_dev_native.txt"
echo -e " 📦 Liste Native sauvegardée : $ISO_DIR/pkglist_dev_native.txt"

# Paquets AUR
pacman -Qmeq > "$ISO_DIR/pkglist_dev_aur.txt"
echo -e " 📦 Liste AUR sauvegardée : $ISO_DIR/pkglist_dev_aur.txt"

echo ""
echo -e "💡 INFO : Copie le contenu de 'pkglist_dev_native.txt' dans 'pkglist.txt'"
echo -e " si tu veux mettre à jour l'ISO (attention aux drivers Nvidia !)."

echo ""
echo -e "${BLUE}=========================================${NC}"
echo -e "${GREEN} SYNCHRONISATION TERMINÉE ! 🚀 ${NC}"
echo -e "${BLUE}=========================================${NC}"
