### Windows

#### Capture packets from remote host, and launch wireshark locally

- Open a cmd terminal
- Run the following command

```bash
ssh client2 "sudo tcpdump -i enp6s0 -s 0 -U -n -w -" | "C:\Program Files\Wireshark\Wireshark.exe" -k -i -

# If Wireshark install dir is already added into the system path, then the following command is enough
ssh client2 "sudo tcpdump -i enp6s0 -s 0 -U -n -w -" | Wireshark -k -i -
```

- for client1:

```bash
ssh client1 "sudo tcpdump -i enp6s0 -s 0 -U -n -w -" | Wireshark -k -i -
```

- for client3:

```bash
ssh client3 "sudo tcpdump -i enp6s0 -s 0 -U -n -w -" | Wireshark -k -i -
```