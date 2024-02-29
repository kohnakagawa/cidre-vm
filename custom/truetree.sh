#!/bin/zsh

mkdir -p /usr/local/bin
curl -L https://github.com/themittenmac/TrueTree/releases/download/v0.6/TrueTree -o /usr/local/bin/TrueTree
chmod +x /usr/local/bin/TrueTree
show_log "TrueTree is installed at /usr/local/bin/TrueTree"