#!/bin/zsh

mkdir -p /usr/local/bin
curl -L https://newosxbook.com/tools/disarm.tar | bsdtar xvf - -C /private/tmp
if [[ $ARCH == "arm64" ]]; then
    mv /private/tmp/binaries/disarm.AAPLSi /usr/local/bin/disarm
else
    mv /private/tmp/binaries/disarm.x86 /usr/local/bin/disarm
fi
rm -rf /private/tmp/binaries
show_log "disarm is installed at /usr/local/bin/disarm"
