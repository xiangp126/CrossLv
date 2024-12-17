#!/bin/bash
set -x

echo "Setting up bridge"
cd "$HOME"/Templates || exit
./create_bridge.sh

echo "Setting up vscode max user watches"
./vscode_max_user_watches.sh

echo "Setting up VNC server"
# How to adjust the resolution of a VNC session?
# Say your local resolution is 1920x1080(width x height)
# and you may need to set the VNC resolution to around 2060x1080 to fit your screen
# How to adjust?
# Keep the height of the resolution the same, and only change the width
# Start by adjusting the width from 1080 to 2060 or more, and choose the one that best fits your screen.
vncPort=5909
vnc_resolution=2060x1080
if lsof -i :$vncPort | grep --quiet LISTEN
then
    set +x
    echo "Port $vncPort is already in use. Stop setting up VNC server"
    # vncserver -kill :9
    set -x
else
    cd "$HOME"/.vnc || exit
    # vncserver :9
    vncserver :9 -geometry $vnc_resolution
fi

echo "Starting all vms"
start_all_vms

echo "Starting OpenGrok"
if command -v callIndexer &> /dev/null
then
    callIndexer -s
fi

echo "Reset the DNS Server"
sudo resolvectl dns enp0s31f6 172.16.100.80 172.16.100.100
