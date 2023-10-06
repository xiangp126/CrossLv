#!/bin/bash
set -x

cd $HOME/Templates
# setup bridge
./create_bridge.sh

./vscode_max_user_watches.sh

# setup vnc server
vncPort=5909
if lsof -i :$vncPort | grep --quiet LISTEN
then
    set +x
    echo "Port $vncPort is already in use. Stop setting up VNC server"
    # vncserver -kill :9
    set -x
else
    cd $HOME/.vnc
    vncserver :9
fi

# start all vms
start_all_vms
