## Squid
wget did not support ssh socks5 proxy

```bash
sudo yum install squid -y
```

### Help Page
```bash
> which squid
/usr/sbin/squid

> squid -h
Usage: squid [-cdhvzCFNRVYX] [-s | -l facility] [-f config-file] [-[au] port] [-k signal]
       -a port   Specify HTTP port number (default: 3128).
       -d level  Write debugging to stderr also.
       -f file   Use given config-file instead of
                 /etc/squid/squid.conf
       -h        Print help message.
       -k reconfigure|rotate|shutdown|interrupt|kill|debug|check|parse
                 Parse configuration file, then send signal to
                 running copy (except -k parse) and exit.
       -s | -l facility
                 Enable logging to syslog.
       -u port   Specify ICP port number (default: 3130), disable with 0.
       -v        Print version.
       -z        Create missing swap directories and then exit.
       -C        Do not catch fatal signals.
       -D        OBSOLETE. Scheduled for removal.
       -F        Don't serve any requests until store is rebuilt.
       -N        No daemon mode.
       -R        Do not set REUSEADDR on port.
       -S        Double-check swap during rebuild.
       -X        Force full debugging.
       -Y        Only return UDP_HIT or UDP_MISS_NOFETCH during fast reload.
```

### Start Squid on Server
```bash
> squid -N -d 1
# Default listen port is 3128
> netstat -tulnp | grep -i squid
tcp        0      0 10.123.18.129:4965      66.194.253.19:443       ESTABLISHED 12863/squid
tcp6       0      0 :::3128                 :::*                    LISTEN      12863/squid
tcp6       0      0 10.123.18.129:3128      10.123.16.47:44946      ESTABLISHED 12863/squid
udp        0      0 0.0.0.0:21835           0.0.0.0:*                           12863/squid
udp6       0      0 :::17176                :::*                                12863/squid
```

### Use Proxy on Client
> let's assume `10.123.18.129` is the ip of `server`

```bash
proxy_ip=10.123.18.129
export http_proxy=http://$proxy_ip:3128/
export https_proxy=http://$proxy_ip:3128/
```