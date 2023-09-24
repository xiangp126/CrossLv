#!/bin/bash

# Define the clone_virtual_machine function
clone_virtual_machine() {
    local original_name="$1"
    local target_name="$2"

    if [ -z "$original_name" ] || [ -z "$target_name" ]; then
        echo "Usage: clone_virtual_machine <original_name> <target_name>"
        return 1
    fi

    sudo virt-clone \
        --original="$original_name" \
        --name="$target_name" \
        --file="/usr/local/vms/ubuntu20-$target_name.qcow2"

    echo "Cloned virtual machine: $target_name"
}

# Example usage:
# clone_virtual_machine "client2" "client1"
# This will clone the VM named "client2" to "client1" and create a qcow2 file in /usr/local/vms/ directory.

# Call the clone_virtual_machine function with your desired original and target VM names.
clone_virtual_machine "client2" "client1"
