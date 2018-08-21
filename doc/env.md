## env

### LD_PRELOAD
```bash
LD_PRELOAD=/lib64/libc-2.12.so whoami
LD_PRELOAD=/lib64/libc-2.12.so ls -l
LD_PRELOAD=/lib64/libc-2.12.so ln -sf /lib64/libc-2.12.so /lib64/libc.so.6
```

### .bashrc
```bash
LD_LIBRARY_PATH=/usr/local/lib:/usr/local/lib64
PKG_CONFIG_PATH=/usr/local/lib/pkgconfig
```