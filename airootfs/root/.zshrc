# --- AUTO-START VERSO INSTALLER ---

if [[ "$(tty)" == "/dev/tty1" ]]; then
    # 1. Vérifier/Configurer le réseau
    /usr/local/bin/verso-connect
    
    # 2. Si le réseau est OK, lancer l'installateur
    # (Le script verso-connect ne se termine que si internet est là)
    /usr/local/bin/install-verso
fi
