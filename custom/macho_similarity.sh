#!/bin/zsh

mkdir -p /usr/local/bin
sudo -u $LOGIN_USER_NAME mkdir -p $HOME/Documents/Cidre-VM
sudo -u $LOGIN_USER_NAME git clone https://github.com/g-les/macho_similarity.git $HOME/Documents/Cidre-VM/macho_similarity
pip3 install -r $HOME/Documents/Cidre-VM/macho_similarity/requirements.txt
show_log "macho_similarity is installed at $HOME/Documents/Cidre-VM/macho_similarity"
