#!/bin/zsh

sudo -u $LOGIN_USER_NAME mkdir -p $HOME/Documents/Cidre-VM
sudo -u $LOGIN_USER_NAME git clone https://github.com/gdbinit/lldbinit.git $HOME/Documents/Cidre-VM/lldbinit
echo "command script import ~/Documents/Cidre-VM/lldbinit/lldbinit.py" >> $HOME/.lldbinit
chown ${LOGIN_USER_NAME}:staff $HOME/.lldbinit
show_log "lldbinit is installed at $HOME/.lldbinit"
