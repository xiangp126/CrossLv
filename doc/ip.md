## ip

- [ipv6 commands](#ipv6)
- [ipv4 commands](#ipv4)

<a id=ipv6></a>
### IPv6
#### add
```bash
ip -6 addr del 2001::76 dev enp7s0f0
```

#### show
```bash
ip -6 addr show
```

--
<a id=ipv4></a>
### IPv4
#### add
add them to **/etc/rc.local** for permanent

```bash
sudo ip addr del 10.124.10.103/24 dev eth0
sudo ip addr add 10.124.10.103/24 dev eth0
sudo ip route add default via 10.124.10.1
# or
sudo ifconfig eth0 10.123.18.129/20
sudo route del default gw 10.123.31.254
sudo route add default gw 10.123.31.1
```

#### ip route

```bash
# temporary add one static route
ip route add 192.168.2.0/24 via 192.168.10.100

# del
ip route del 192.168.2.0/24 via 192.168.10.100
# or
ip route del 192.168.2.0/24
```

#### route command
- Add one route

```bash
sudo route add 192.168.2.0 netmask 255.255.255.0 gw 192.168.10.100

# add one route permanently
sudo route -p add 192.168.2.0 netmask 255.255.255.0 gw 192.168.10.100
```

- Del one route (Not recommended)

```bash
sudo route del -net 192.168.2.0
```

#### Ubuntu
- permanent modify

```bash
sudo vim /etc/network/interfaces

auto eth0
iface eth0 inet static
    address 1.1.1.1
    netmask 255.255.255.0
    gateway 1.1.1.254
    dns-nameservers 8.8.8.8
    # dns-nameservers 64.104.123.144
```

#### CentOS
- static

```bash
cd /etc/sysconfig/network-scripts

DEVICE='eth0'
TYPE=Ethernet
BOOTPROTO=static
ONBOOT='yes'
IPADDR=1.1.1.1
NETMASK=255.255.255.0
GATEWAY=1.1.1.254
NM_CONTROLLED='no'
DNS1=8.8.8.8
```

#### ifup / ifdown
```bash
sudo ifup eth0
sudo ifdown eth0 && sudo ifup eth0
```

#### neighbour | neighbor
```bash
ip neighbor
```
