#!/bin/bash
hyprctl dispatch workspace r+1
sleep 0.2
hyprctl dispatch focuswindow ""
sleep 0.1
hyprctl dispatch workspace current
