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

i=0
for ((i = 0; i < ${#server_ip[@]}; ++i)); do
    # ./login.sh [ssh_ip] [ssh_port] [ssh_user] [ssh_home] [ssh_prompt] [ssh_passwd]
    ./login.exp ${server_ip[$i]} $ssh_port $ssh_user $ssh_home $ssh_prompt $ssh_passwd
    # Parallel executing, with &/wait
    # ./login.exp ${server_ip[$i]} $ssh_port $ssh_user $ssh_home $ssh_prompt $ssh_passwd &
done

wait
echo "All Done!"
