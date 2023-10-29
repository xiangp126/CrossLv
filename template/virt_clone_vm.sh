#!/bin/bash

vm_location="/usr/local/vms"

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
        --file="$vm_location/$cloned_name.qcow2"

    if [ $? -ne 0 ]; then
        echo "Failed to clone virtual machine: $vm_name"
        return 1
    fi

    # check the user of the qcow2 file, if not libvirt-qumu and the group not kvm, change them
    local qcow2_file="$vm_location/$cloned_name.qcow2"
    local qcow2_user=$(stat -c '%U' "$qcow2_file")
    local qcow2_group=$(stat -c '%G' "$qcow2_file")
    if [ "$qcow2_user" != "libvirt-qemu" ] || [ "$qcow2_group" != "kvm" ]; then
        echo "Changing the owner of $qcow2_file to libvirt-qemu:kvm"
        sudo chown libvirt-qemu:kvm "$qcow2_file"
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
