#!/bin/zsh

mkdir -p /usr/local/bin
sudo -u $LOGIN_USER_NAME mkdir -p $HOME/Documents/Cidre-VM
sudo -u $LOGIN_USER_NAME git clone https://github.com/g-les/macho_similarity.git $HOME/Documents/Cidre-VM/macho_similarity
sudo -u $LOGIN_USER_NAME -H python3 -m venv $HOME/venv/macho_similarity
source $HOME/venv/macho_similarity/bin/activate
sudo -u $LOGIN_USER_NAME -H pip3 install -q -r $HOME/Documents/Cidre-VM/macho_similarity/requirements.txt
deactivate
show_log "macho_similarity is installed at $HOME/Documents/Cidre-VM/macho_similarity (Need to run in Python venv: $HOME/venv/macho_similarity/bin/activate)"
