#!/bin/bash

# Check if both FortiGate VM name and qcow2 path are provided as arguments
if [ $# -lt 2 ]; then
    echo "Usage: $0 <vm_name> <qcow2_path>"
    echo "Example: $0 fgt1 /var/lib/libvirt/images/fgt1.qcow2"
    echo "Example: $0 fpx1 /var/lib/libvirt/images/fpx1.qcow2"
    exit 1
fi

# Set the provided FortiGate VM name and qcow2 path as variables
FGT_NAME="$1"
FGT_QCOW2_PATH="$2"
FGT_DESCRIPTION="FortiGate VM"
FGT_RAM="2048"  # in MB
FGT_VCPUS="1"
FGT_DISK_SIZE="10"  # in GB

# Create the FortiGate VM using virt-install
sudo virt-install \
    --check path_in_use=off \
    --name="$FGT_NAME" \
    --description="$FGT_DESCRIPTION" \
    --ram="$FGT_RAM" \
    --vcpus="$FGT_VCPUS" \
    --disk "path=$FGT_QCOW2_PATH,format=qcow2,size=$FGT_DISK_SIZE" \
    --graphics "vnc" \
    --import

# Check the exit status of virt-install
if [ $? -eq 0 ]; then
    echo "FortiGate VM '$FGT_NAME' has been installed successfully."
else
    echo "Error: Failed to install FortiGate VM."
fi

# Print information about the created FortiGate VM using cat
cat << _EOF
FortiGate VM '$FGT_NAME' has been created with the following configuration:
Name: $FGT_NAME
Description: $FGT_DESCRIPTION
RAM: $FGT_RAM MB
vCPUs: $FGT_VCPUS
Disk Size: $FGT_DISK_SIZE GB
Qcow2 Path: $FGT_QCOW2_PATH
_EOF
