## ldd

- for MAC

  use `otool` in place of `ldd`

```bash
otool -L
```

- for Linux

  ```bash
  DESCRIPTION         top
  
         ldd prints the shared objects (shared libraries) required by each
         program or shared object specified on the command line.  An example
         of its use and output is the following:
  
           $ ldd /bin/ls
                   linux-vdso.so.1 (0x00007ffcc3563000)
                   libselinux.so.1 => /lib64/libselinux.so.1 (0x00007f87e5459000)
                   libcap.so.2 => /lib64/libcap.so.2 (0x00007f87e5254000)
                   libc.so.6 => /lib64/libc.so.6 (0x00007f87e4e92000)
                   libpcre.so.1 => /lib64/libpcre.so.1 (0x00007f87e4c22000)
                   libdl.so.2 => /lib64/libdl.so.2 (0x00007f87e4a1e000)
                   /lib64/ld-linux-x86-64.so.2 (0x00005574bf12e000)
                   libattr.so.1 => /lib64/libattr.so.1 (0x00007f87e4817000)
                   libpthread.so.0 => /lib64/libpthread.so.0 (0x00007f87e45fa000)
  ```

  