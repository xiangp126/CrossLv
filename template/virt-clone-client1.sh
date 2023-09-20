#!/bin/bash
sudo virt-clone \
    --original=client2 \
    --name=client1 \
    --file=/usr/local/vms/ubuntu20-client1.qcow2

