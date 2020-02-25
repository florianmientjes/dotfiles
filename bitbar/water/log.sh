#!/usr/bin/env bash

LASTWATER=$(cat ~/.dotfiles/bitbar/water/log)

# osascript -e "display notification \"1 hour without water $LASTWATER\" with title \"WATER\""

echo "$(date +"%s")000" >> ~/.dotfiles/bitbar/water/log
