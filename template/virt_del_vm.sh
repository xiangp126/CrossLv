#!/bin/bash

# Check if a VM name is provided as an argument
if [ $# -ne 1 ]; then
    echo "Usage: ./$0 <vm_name>"
    sudo virsh list --all
    exit 1
fi

vm_name="$1"

# Check if the VM exists
if ! virsh list --all | grep -q " $vm_name "; then
    echo "Error: VM '$vm_name' does not exist."
    exit 1
fi

# Get the path of the VM's disk image using awk
disk_image=$(virsh domblklist "$vm_name" | awk '/vda|hda/{print $2}')

# Shutdown the VM if it is running
if virsh list --state-running | grep -q " $vm_name "; then
    echo "Shutting down VM: $vm_name"
    virsh shutdown "$vm_name"

    # Wait for the VM to completely shut down
    while virsh list --state-running | grep -q " $vm_name "; do
        sleep 1
    done
fi

# Undefine (delete) the VM
echo "Deleting VM: $vm_name"
virsh undefine "$vm_name"

# Check if the disk image path is not empty
if [ -n "$disk_image" ]; then
    # Delete the VM's disk image
    echo "Deleting disk image: $disk_image"
    rm -f "$disk_image"
fi

echo "VM '$vm_name' and its associated disk image have been deleted."
