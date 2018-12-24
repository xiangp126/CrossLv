## tcpdump
tshark/wireshark/tcpdump

### [Remote Capture](#rcapture)
1. [using `ncat` - two commands, **nicest solution**](#ncat)
2. [using `ssh` command - **all in one**](#ssh)
3. [using `ssh` together with `fifo`](#fifo)

### [Capture Filter](#filter)
### [Explain Key Parameters](#explainkey)

<a id=rcapture></a>
<a id=ncat></a>
#### using ncat - two commands, nicest solution
> on server

redirect raw bytes of `tcpdump` to `ncat`, listening on specified port on server

```ruby
tcpdump -s 0 -U -n -w - -i eth0 | nc -l 8888
# with filter
tcpdump -s 0 -U -n -w - -i any ip host 192.168.10.11 | nc -l 8888
```

> on client

get the bytes from remote server and open them with `wireshark`

```ruby
nc 192.168.10.1 8888 | wireshark -k -i -
```

<a id=ssh></a>
#### using ssh - all in one
```bash
ssh -p 22 -l root 192.168.10.1 "sudo tcpdump -s 0 -U -n -w - -i eth0" | wireshark -k -i -
```

<a id=fifo></a>
#### using ssh together with fifo
recommend only used when no `ncat` on remote server

> on Server

```ruby
mkfifo /tmp/pcap
tcpdump -s 0 -U -n -w - -i eth0 > /tmp/pcap
# tcpdump -s 0 -U -n -w - -i eth0 not port 22 > /tmp/pcap
```

> on client

```ruby
ssh -p 22 -l root 192.168.10.1 "cat /tmp/pcap" | wireshark -k -i -
```

<a id=filter></a>
### Capture Filter
```ruby
# only capture IP packets for host 192.168.88.241
tcpdump -i any -nn ip host 192.168.88.241 -vv
# only capture IPv6 packets for host 192.168.88.241
tcpdump -i any -nn ip6 host 2001::220 -vv

tcpdump ip host 192.168.88.241 and ! 192.168.88.242
tcpdump -i eth0 src host 192.168.88.241
tcpdump -i eth0 dst host 192.168.88.248

# telnet: port 23
tcpdump -i eth0 tcp port 23 and host 192.168.88.241
tcpdump -i eth0 udp port 123
```

<a id=explainkey></a>
### Explain Key Parameters
* -s 0

Setting snaplen to **0** sets it to the default of 262144

```ruby
-s snaplen
--snapshot-length=snaplen
       Snarf  snaplen  bytes of data from each packet rather than the default of 262144 bytes.  Packets truncated because
       of a limited snapshot are indicated in the output with ``[|proto]'', where proto is the name of the protocol level
       at  which  the  truncation  has  occurred.  Note that taking larger snapshots both increases the amount of time it
       takes to process packets and, effectively, decreases the amount of packet buffering.  This may cause packets to be
       lost.   You  should  limit snaplen to the smallest number that will capture the protocol information you're inter-
       ested in.  Setting snaplen to 0 sets it to the default of 262144, for backwards compatibility  with  recent  older
       versions of tcpdump.
```

* -U

```ruby
-U
--packet-buffered
       If the -w option is not specified, make the printed packet output ``packet-buffered''; i.e., as the description of
       the contents of each packet is printed, it will be written to the standard output, rather than, when  not  writing
       to a terminal, being written only when the output buffer fills.

       If  the  -w  option  is  specified,  make the saved raw packet output ``packet-buffered''; i.e., as each packet is
       saved, it will be written to the output file, rather than being written only when the output buffer fills.

       The -U flag will not be supported if  tcpdump  was  built  with  an  older  version  of  libpcap  that  lacks  the
       pcap_dump_flush() function.
```

* -n

```ruby
-n     Don't convert addresses (i.e., host addresses, port numbers, etc.) to names.
```

* -w -

the second `-` means `stdout`

```ruby
-w file
       Write  the  raw  packets to file rather than parsing and printing them out.  They can later be printed with the -r
       option.  Standard output is used if file is ``-''.

       This output will be buffered if written to a file or pipe, so a program reading from the file or pipe may not  see
       packets  for  an arbitrary amount of time after they are received.  Use the -U flag to cause packets to be written
       as soon as they are received.

       The MIME type application/vnd.tcpdump.pcap has been registered with IANA for pcap files.  The  filename  extension
       .pcap  appears  to  be the most commonly used along with .cap and .dmp. Tcpdump itself doesn't check the extension
       when reading capture files and doesn't add an extension when writing them (it  uses  magic  numbers  in  the  file
       header  instead).  However,  many  operating  systems and applications will use the extension if it is present and
       adding one (e.g. .pcap) is recommended.
```

* -i eth0

```ruby
-i interface
 --interface=interface
```

* -vv

```ruby
-vv    Even  more  verbose  output. For example, additional fields are printed from NFS reply packets,
       and SMB packets are fully decoded.
```
