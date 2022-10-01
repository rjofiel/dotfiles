#!/bin/bash
# show random picture
file=$(find $HOME/Pictures/Wallpapers/ -type f -print0 | shuf -z -n 1 | tr -d "\0")
feh --bg-scale $file
