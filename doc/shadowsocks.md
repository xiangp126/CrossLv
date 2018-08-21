## shadowsocks
### Local ShadowSocks (Preferred)
```bash
sudo apt-get update
sudo apt-get install shadowsocks
cp template/shadowsocks-local.json /etc/shadowsocks.json
```

> Edit certain fields and then

```bash
sslocal -c /etc/shadowsocks.json
```

1. Then from SwichyOmega import
OmegaProfile_ShadowSocks.pac

2. Add to Chrome Plugin: socks5 127.0.0.1 1080

### Or install using pip (Second choice)
```bash
sudo apt-get update
sudo apt-get install python-gevent python-pip

pip install shadowsocks
```