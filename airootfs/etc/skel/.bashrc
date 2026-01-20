#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias edit-verso='micro ~/.backup/bin/install-verso'
alias edit-hyprland='micro ~/.config/hypr/hyprland.conf'
alias edit-waybar='micro ~/.config/waybar/config'
alias edit-waybar-style='micro ~/.config/waybar/style.css'
alias edit-kitty='micro ~/.config/kitty/kitty.conf'
alias edit-welcome='micro ~/.backup/bin/verso-welcome'
alias edit-update='micro ~/.backup/bin/verso-update'
alias edit-pkglist='micro ~/verso-iso/airootfs/pkglist.txt'
alias edit-packages='micro ~/verso-iso/packages.x86_64'
alias edit-commandes='micro ~/.bashrc'
alias edit-menu='micro /usr/local/bin/menu_applis'
alias alfred='/usr/local/bin/alfred'
alias edit-alfred='micro /usr/local/bin/alfred'
alias edit-alfred-style='micro ~/llama.cpp/tools/cli/cli.cpp'
alias edit-help='micro ~/verso-iso/airootfs/etc/skel/.config/verso_help.txt'
alias commandes='cat ~/.bashrc'
PS1='[\u@\h \W]\$ '
