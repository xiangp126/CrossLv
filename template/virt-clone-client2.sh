#!/bin/bash
sudo virt-clone \
    --original=client1 \
    --name=client2 \
    --file=/usr/local/vms/ubuntu20-client2.qcow2

