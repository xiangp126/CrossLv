#!/bin/bash

sudo brctl addbr br1
sudo brctl stp br1 on
# sudo brctl showstp br1
# sudo ip link show
sudo ip addr add 192.168.101.254/24 dev br1
sudo ip link set br1 up

sudo brctl addbr br2
sudo brctl stp br2 on
sudo ip addr add 192.168.102.254/24 dev br2
sudo ip link set br2 up

# setup vnc server
cd $HOME/.vnc
vncserver :9
