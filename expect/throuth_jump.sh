#!/bin/bash
# When send a command, \r for it to execute
# template for through a jump machine and copy host key to dest machine
ssh_port="22"
ssh_user="root"
# ssh_user="root"
ssh_home="/root"
ssh_prompt="]# "
ssh_passwd=""

server_ip=(
# mark server list here, one per line
)

i=0
for ((i = 0; i < ${#server_ip[@]}; ++i)); do
    ./throuth_jump.exp ${server_ip[$i]} $ssh_port $ssh_user $ssh_home $ssh_prompt $ssh_passwd
    # Parallel executing, with &/wait
    # ./throuth_jump.exp ${server_ip[$i]} $ssh_port $ssh_user $ssh_home $ssh_prompt $ssh_passwd &
done

wait
echo "All Done!"
