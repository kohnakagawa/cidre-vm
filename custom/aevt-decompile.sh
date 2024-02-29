#!/bin/zsh

mkdir -p /usr/local/bin
sudo -u $LOGIN_USER_NAME mkdir -p $HOME/Documents/Cidre-VM
sudo -u $LOGIN_USER_NAME git clone https://github.com/SentineLabs/aevt_decompile.git $HOME/Documents/Cidre-VM/aevt_decompile
sudo -u $LOGIN_USER_NAME clang -O3 -framework Foundation $HOME/Documents/Cidre-VM/aevt_decompile/aevt_decompile/main.m -o /tmp/aevt_decompile
cp /tmp/aevt_decompile /usr/local/bin/aevt_decompile
show_log "aevt_decompile is installed at /usr/local/bin/aevt_decompile"