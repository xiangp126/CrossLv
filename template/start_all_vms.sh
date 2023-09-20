#!/bin/bash
for vm in $(virsh list --all --name)
do
    sudo virsh start $vm
done
