#!/bin/bash
# When send a command, \r for it to execute
ssh_port="22"
ssh_user="root"
ssh_home="/root"
ssh_prompt="]# "
# set login passwd here
ssh_passwd=""

server_ip=(
# mark server list here, one per line
# "127.0.0.1"
)

# NIC port to be used for DPDK
nic_port_name=(
# mark NIC port name here, one per line and corresponding to server_ip
# "enp7s0f0"
)

# server local ip
local_ip=(
# mark LIP of server here, one per line
# "127.0.0.1"
)

fstack_dst_dir=/root/myGit/f-stack
config_ini_path=$fstack_dst_dir/config.ini

i=0
for ((i = 0; i < ${#server_ip[@]}; ++i)); do
    sed -i "/addr=/c addr=${local_ip[$i]}" $config_ini_path
    # ./fstack.sh [ssh_ip] [ssh_port] [ssh_user] [ssh_home] [ssh_prompt] [ssh_passwd] [nic_port_name]
    ./fstack.exp ${server_ip[$i]} $ssh_port $ssh_user $ssh_home $ssh_prompt $ssh_passwd ${nic_port_name[$i]}
    # Parallel executing, with &/wait
    # ./fstack.exp ${server_ip[$i]} $ssh_port $ssh_user $ssh_home $ssh_prompt $ssh_passwd ${nic_port_name[$i]} &
done

wait
echo "All Done!"
