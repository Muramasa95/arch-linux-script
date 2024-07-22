#!/bin/bash

echo -ne '

  ___  ______  _____  _   _   _     _____ _   _ _   ___   __
 / _ \ | ___ \/  __ \| | | | | |   |_   _| \ | | | | \ \ / /
/ /_\ \| |_/ /| /  \/| |_| | | |     | | |  \| | | | |\ V / 
|  _  ||    / | |    |  _  | | |     | | | . ` | | | |/   \ 
| | | || |\ \ | \__/\| | | | | |_____| |_| |\  | |_| / /^\ \
\_| |_/\_| \_| \____/\_| |_/ \_____/\___/\_| \_/\___/\/   \/
                                                            
                                                                                                                                             
'

DIR=$PWD

echo "***** The script will now backup the config files *****"
cp -fr $HOME/.zshrc $DIR 
cp -fr $HOME/.zsh_history $DIR 
cp -fr $HOME/.config/mpv $DIR 
cp -fr $HOME/.config/MangoHud $DIR 
cp -fr $HOME/.config/jellyfin-mpv-shim $DIR 
echo
