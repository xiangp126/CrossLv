#!/bin/bash
ssh_port="22"
ssh_user="root"
ssh_home="/root"
ssh_prompt="]# "
ssh_passwd=""
# D="2s"
D="60s"

client_ip=(
# mark server list here, one per line
)

for client in ${client_ip[@]}; do
    # ./client.exp $client $ssh_port $ssh_user $ssh_home $ssh_prompt $ssh_passwd $D
    ./client.exp $client $ssh_port $ssh_user $ssh_home $ssh_prompt $ssh_passwd $D &
done

wait
echo "All Done!"
# print date
date
