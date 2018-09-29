## wireshark

- wireshark
- tcpdump
- tshark

### Remote Capture
> with one command and simple

```bash
# set ssh user here
ssh_port=22
ssh_user=root
# set server ip here
server_ip=
# change eth0 to the right port
port_name=eth0
ssh -p $ssh_port -l $ssh_user $server_ip "sudo tcpdump -s 0 -U -n -w - -i $port_name" | wireshark -k -i -
```

### Step by step | robust
> Login to server

```bash
ssh_port=22
ssh_user=root
# set server ip here
server_ip=
ssh -p $ssh_port -l $ssh_user $server_ip
```

> On server

```bash
mkfifo /tmp/pcap
tcpdump -s 0 -U -n -w - -i eth0 > /tmp/pcap
# tcpdump -s 0 -U -n -w - -i eth0 not port 22 > /tmp/pcap
```

> On client

```bash
ssh_port=22
ssh_user=root
# set server ip here
server_ip=
ssh -p $ssh_port -l $ssh_user $server_ip "cat /tmp/pcap" | wireshark -k -i -
```