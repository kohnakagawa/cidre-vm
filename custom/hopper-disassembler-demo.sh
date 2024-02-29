#!/bin/zsh

sudo -u $LOGIN_USER_NAME curl -L -A "Mozilla/5.0" https://www.hopperapp.com/downloader/hopperv4/Hopper-5.14.2-demo.dmg -o $HOME/Downloads/Hopper-5.14.2-demo.dmg
sudo -u $LOGIN_USER_NAME mkdir -p /tmp/mnt
sudo -u $LOGIN_USER_NAME hdiutil attach $HOME/Downloads/Hopper-5.14.2-demo.dmg -mountpoint /tmp/mnt
sudo -u $LOGIN_USER_NAME cp -R /tmp/mnt/Hopper\ Disassembler\ v4.app /Applications/
sudo -u $LOGIN_USER_NAME hdiutil detach /tmp/mnt
show_log "Hopper Disassembler is installed at /Applications/Hopper Disassembler v4.app"