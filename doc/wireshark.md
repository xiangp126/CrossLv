## wireshark

wireshark tcpdump tshark

### Remote Capture
> With one command and simple

```bash
# Note: change eth0 to the right port
ssh -p server_port -l user server_ip "sudo tcpdump -s 0 -U -n -w - -i eth0" | wireshark -k -i -
```

### Step by step | robust
1. Login to server

```bash
ssh -p server_port -l user server_ip
```

2. On server

```bash
mkfifo /tmp/pcap
tcpdump -s 0 -U -n -w - -i eth0 > /tmp/pcap
# tcpdump -s 0 -U -n -w - -i eth0 not port 22 > /tmp/pcap
```

3. On client

```bash
ssh -p server_port -l user server_ip "cat /tmp/pcap" | wireshark -k -i -
```