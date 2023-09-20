#!/bin/bash
sudo virt-install \
  --check path_in_use=off \
  --name=client1 \
  --description='ubuntu20' \
  --ram=2048 \
  --vcpus=1 \
  --disk size=10,format=qcow2,path=/usr/local/vms/ubuntu20-client1.qcow2 \
  --cdrom /usr/local/share/ubuntu-20.04.6-live-server-amd64.iso \
  --graphics vnc

