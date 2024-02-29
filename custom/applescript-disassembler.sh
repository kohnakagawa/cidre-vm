#!/bin/zsh

sudo -u $LOGIN_USER_NAME mkdir -p $HOME/Documents/Cidre-VM
sudo -u $LOGIN_USER_NAME git clone https://github.com/Jinmo/applescript-disassembler.git $HOME/Documents/Cidre-VM/applescript-disassembler
show_log "applescript-disassembler is installed at $HOME/Documents/Cidre-VM/applescript-disassembler"