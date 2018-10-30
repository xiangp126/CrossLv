#!/bin/bash
# When send a command, \r for it to execute
ssh_port="22"
ssh_user="root"
ssh_home="/root"
ssh_prompt="]# "
ssh_passwd=""

server_ip=(
# mark server list here, one per line
"127.0.0.1"
)

i=0
min_index=1
max_index=16
# loop to check #core ranges from [min_index, max_index]
for ((i = min_index; i <= $max_index ; ++i)); do
    ./conf.exp ${server_ip[0]} $ssh_port $ssh_user $ssh_home $ssh_prompt $ssh_passwd $i
    # Parallel executing, with &/wait
    # ./ssh.exp ${server_ip[$i]} $ssh_port $ssh_user $ssh_home $ssh_prompt $ssh_passwd &
done

wait
echo "All Done!"
