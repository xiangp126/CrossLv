# Establish SSH Reverse proxy
Note: Laptop has full Internet access, but Remote not

```bash
       ssh -vv -ND 8080 [Laptop_ip] -l [login_name on Laptop]
     --------------------------------------------------------------->>
Remote                                                                  Laptop
     <<---------------------------------------------------------------
       ssh -l [login_name on Server] [Server_ip]
```

## Use socks5 proxy on Remote
```bash
export http_proxy=socks5://127.0.0.1:8080
export https_proxy=socks5://127.0.0.1:8080
```
