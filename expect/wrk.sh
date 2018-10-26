#!/bin/bash
# used for installing wrk
ssh_port="22"
ssh_user="root"
ssh_home="/root"
ssh_prompt="]# "
# set login passwd here
ssh_passwd=""

client_ip=(
# mark server list here, one per line
)

for client in ${client_ip[@]}; do
    ./wrk.exp $client $ssh_port $ssh_user $ssh_home $ssh_prompt $ssh_passwd $D
    # ./wrk.exp $client $ssh_port $ssh_user $ssh_home $ssh_prompt $ssh_passwd $D &
done

wait
echo "All Done!"
