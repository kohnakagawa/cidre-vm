#!/bin/zsh

mkdir -p /usr/local/bin
curl -L https://github.com/themittenmac/TrueTree/releases/download/V0.8/TrueTree.zip | bsdtar xvf - -C /usr/local/bin/
chmod +x /usr/local/bin/TrueTree
show_log "TrueTree is installed at /usr/local/bin/TrueTree"
