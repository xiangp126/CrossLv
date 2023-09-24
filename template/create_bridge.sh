#!/bin/bash

# Define the bridge creation function
create_bridge() {
    local bridge_name="$1"
    local bridge_ip="$2"

    if bridge_exists "$bridge_name"; then
        echo "$bridge_name already exists, skipping..."
    else
        sudo brctl addbr "$bridge_name"
        sudo brctl stp "$bridge_name" on
        sudo ip addr add "$bridge_ip" dev "$bridge_name"
        sudo ip link set "$bridge_name" up
        echo "Created $bridge_name with IP $bridge_ip"
    fi
}

# Define the bridge_exists function
bridge_exists() {
    local bridge_name="$1"
    if sudo ifconfig -a | grep -q "$bridge_name"; then
        return 0  # Bridge exists
    else
        return 1  # Bridge does not exist
    fi
}

# Create bridges
create_bridge "br1" "192.168.101.254/24"
create_bridge "br2" "192.168.102.254/24"
create_bridge "br3" "192.168.103.254/24"
create_bridge "br4" "192.168.104.254/24"

# sudo brctl showstp br1
# sudo ip link show

# demo to delete the bridge
# sudo ip link set br3 down
# sudo brctl delbr br3
