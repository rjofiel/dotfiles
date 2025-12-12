#!/bin/sh

# systray battery icon
cbatticon -u 5 &
# systray volume
# feh background
feh --bg-scale $HOME/Pictures/Wallpapers/comfy_blue.png
sh ~/.config/scripts/feh-randomized.sh &
picom --config ~/.config/picom/picom.conf &
#bluez
blueberry-tray &
