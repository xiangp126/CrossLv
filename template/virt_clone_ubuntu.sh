#!/bin/bash

# Define the clone_virtual_machine function
clone_virtual_machine() {
    local vm_name="$1"
    local cloned_name="$2"

    if [ -z "$vm_name" ] || [ -z "$cloned_name" ]; then
        echo "Usage: ./$0 <vm_name> <cloned_name>"
        sudo virsh list --all
        return 1
    fi

    sudo virt-clone \
        --check path_exists=off \
        --original="$vm_name" \
        --name="$cloned_name" \
        --file="/usr/local/vms/ubuntu20-$cloned_name.qcow2"

    if [ $? -ne 0 ]; then
        echo "Failed to clone virtual machine: $vm_name"
        return 1
    fi

    echo "Cloned virtual machine: $cloned_name"
    echo "To change the VNC port for $cloned_name, run the following command:"
    echo "sudo virsh edit $cloned_name"

}

# Example usage:
# clone_virtual_machine "client2" "client1"
# This will clone the VM named "client2" to "client1" and create a qcow2 file in /usr/local/vms/ directory.

# Call the clone_virtual_machine function with your desired original and target VM names.
clone_virtual_machine $1 $2
