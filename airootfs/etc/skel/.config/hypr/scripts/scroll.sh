#!/bin/bash

# 1. Identification de la fenêtre Brave
  WINDOW=$(hyprctl activewindow -j | jq -r ".class")
  if [[ ! "$WINDOW" =- "brave" ]];
  then
  	exit 0
  fi

# 2. Le Scroll
  if [ "$1" == "up" ]; then
	  wlrctl pointer scroll -$SPEED 0
  elif [ "$1" == "down" ]; then
	  wlrctl pointer scroll $SPEED 0
  fi
