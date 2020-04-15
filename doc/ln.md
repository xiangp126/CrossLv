## ln
### SYNOPSIS
```
SYNOPSIS
     ln [-Ffhinsv] source_file [target_file]
     ln [-Ffhinsv] source_file ... target_dir
     link source_file target_file
```

### make hard link
```bash
ln ~/.bashrc .

ll .bashrc
-rwxr-xr-x  2 corsair  staff  5336 Jun 14 11:41 .bashrc*
```

### make soft link
```bash
ln -s ~/.bashrc .

ll .bashrc
lrwxr-xr-x  1 vbird  staff  22 Aug 23 15:40 .bashrc@ -> ~/.bashrc
```