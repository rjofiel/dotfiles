#!/bin/bash
ls $HOME/Desktop/work | rofi -show -dmenu | xargs -I_ code $HOME/Desktop/work/_
