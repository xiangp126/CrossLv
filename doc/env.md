## env

### LD_PRELOAD
```bash
LD_PRELOAD=/lib64/libc-2.12.so whoami
LD_PRELOAD=/lib64/libc-2.12.so ls -l
LD_PRELOAD=/lib64/libc-2.12.so ln -sf /lib64/libc-2.12.so /lib64/libc.so.6
```

### .bashrc = ~/.bashrc

```bash
LD_LIBRARY_PATH=/usr/local/lib:/usr/local/lib64
PKG_CONFIG_PATH=/usr/local/lib/pkgconfig
```

### /etc/bashrc

```bashrc
# System-wide .bashrc file for interactive bash(1) shells.
if [ -z "$PS1" ]; then
   return
fi

PS1='\h:\W \u\$ '
# Make bash check its window size after a process completes
shopt -s checkwinsize

[ -r "/etc/bashrc_$TERM_PROGRAM" ] && . "/etc/bashrc_$TERM_PROGRAM"
```