#!/bin/zsh

show_log "Clearing quarantine attributes"
sudo xattr -rc $homebrew_root/Caskroom/*

show_log "Adding OpenJDK path"
sudo -u $LOGIN_USER_NAME printf 'export PATH="%s/opt/openjdk@17/bin:$PATH"\n' $homebrew_root | sudo -u $LOGIN_USER_NAME tee -a $HOME/.zshrc

show_log "Adding /usr/local/bin path"
sudo -u $LOGIN_USER_NAME echo 'export PATH="/usr/local/bin:$PATH"' | sudo -u $LOGIN_USER_NAME tee -a $HOME/.zshrc

show_log "Showing hidden files in Finder"
defaults write com.apple.finder AppleShowAllFiles TRUE
killall Finder

if command -v gktool > /dev/null 2>&1; then
    show_log "Scanning app bundles using gktool"
    find /Applications -name "*.app" -print0 | xargs -0 -L1 -I{} gktool scan {} > /dev/null
fi
