## rsync
rsync - faster, flexible replacement for rcp

### SYNOPSIS

       rsync [OPTION]... SRC [SRC]... DEST
       -a, --archive               archive mode; same as -rlptgoD (no -H)
       -z, --compress              compress file data during the transfer
       -n, --dry-run               show what would have been transferred
       -P                          same as --partial --progress
        --progress                 show progress during transfer
        --partial                  keep partially transferred files
       -v, --verbose               increase verbosity
       -r, --recursive             recurse into directories

### **!! Must run Dry Mode before actually syncing !!**

With the **-n** flag enabled, it did not actually copy the files.

```bash
# -n, --dry-run | show what would have been transferred
rsync -azP -n /var/www/example.com/ root@108.175.12.239:/var/www/example.com/
       Local:  rsync [OPTION...] SRC... [DEST]

       Access via remote shell:
         Pull: rsync [OPTION...] [USER@]HOST:SRC... [DEST]
         Push: rsync [OPTION...] SRC... [USER@]HOST:DEST
```

### Comparation & Explanation
- Syntax 1 - Commonly Used

```bash
# 文件夹里面每个文件的比对与拷贝
# 直接把example.com文件夹里面的所有内容拷贝到目标文件夹里面
rsync -azP /var/www/example.com/ root@108.175.12.239:/var/www/example.com/
                               ^
#                              | Take care of the difference with this '/'
```

- Syntax 2

```bash
# 文件夹整体的比对与拷贝
# 会在目标文件夹里面新建一个全新的example.com文件夹，并拷贝example.com里面的所有文件
rsync -azP /var/www/example.com root@108.175.12.239:/var/www/
                               ^
#                              | Take care of the difference without a '/' here

```

### Exclude hidden files
```bash
# exclude syntax
--exclude="PATTERN"       exclude files matching PATTERN
```

Here, the pattern for hidden files is **--exclude=".*"**

```
$ rsync -arzP -nv --exclude=".*" /Volumes/misc/RAWVV-NoDel/ /Volumes/Dust/RAWVV-DustNoDel
building file list ...
40 files to consider
./

sent 2743 bytes  received 26 bytes  1846.00 bytes/sec
total size is 69244723857  speedup is 25007123.10

```

### Bi-directional sync
```bash
# On Side A
$ rsync -arzP -nv --exclude=".*" /Volumes/misc/RAWVV-NoDel/ /Volumes/Dust/RAWVV-DustNoDel
building file list ...
40 files to consider
./

sent 2743 bytes  received 26 bytes  1846.00 bytes/sec
total size is 69244723857  speedup is 25007123.10

# On Side B
$ rsync -arzP -nv --exclude=".*" /Volumes/Dust/RAWVV-DustNoDel/ /Volumes/misc/RAWVV-NoDel/
building file list ...
50 files to consider
./
The Act- Trailer (Official) #200 A Hulu Original.mp4

sent 3440 bytes  received 86 bytes  7052.00 bytes/sec
total size is 82513746216  speedup is 23401516.23
```

### If Not port 22
```bash
# rsync not at port 22
rsync -azP -n "-e ssh -p 23" user@server-ip:/opt/o-source/ /opt/o-source
```


### Usage Example
- Remote delete

```bash
# Delete remote files that were not in the local machine.
rm dir1/file99
rsync -azP -n --delete dir1/ user@server:~/dir2
sending incremental file list
./
deleting file99

sent 831 bytes  received 15 bytes  564.00 bytes/sec
total size is 0  speedup is 0.00 (DRY RUN)

rsync -azP --delete dir1/ user@server:~/dir2
```

- Remote sync
```bash
rsync -azP dir1/ user@server:~/dir2
```

- Local sync
Refer <https://www.digitalocean.com/community/tutorials/how-to-use-rsync-to-sync-local-and-remote-directories-on-a-vps>

```bash
# Notice there are 2 dots in total, create 100 files consecutive
touch file{1..100}

# If not leave '/' after dir1, will put dir1 into dir2, or will send files under dir1
rsync -anv dir1/ dir2

rsync -a --progress dir1/ dir2
    --progress              show progress during transfer
```