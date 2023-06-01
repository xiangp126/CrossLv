## rsync
rsync - faster, flexible replacement for rcp

### Use Scenario of DRDU
```bash
cd Document
rsync -arzP -v DRDU/ /Volumes/Dust/DRDU\ Official\ -\ SRCFCPX\ -\ NoDel/ --delete -n

# confirm and then
rsync -arzP -v DRDU/ /Volumes/Dust/DRDU\ Official\ -\ SRCFCPX\ -\ NoDel/ --delete
```

Here's a breakdown of the command:

- `rsync`: The command to initiate the synchronization process.
- `-arzP`: The options used:
  - `-a`: Archive mode, which preserves permissions, ownership, timestamps, etc.
  - `-r`: Recursively syncs files and directories.
  - `-z`: Enables compression during the transfer, reducing the network bandwidth usage.
  - `-P`: Equivalent to `--partial --progress`. Displays progress information during the transfer and allows resumable transfers.
- `-v`: Verbose mode, which provides detailed output during the synchronization process.
- `DRDU/`: The source directory you want to synchronize. Ensure that the directory exists and that you have the necessary permissions. **The trailing slash / ensures that the contents of the directory synchronized rather than the directory itself.**
- `/Volumes/Dust/DRDU\ Official\ -\ SRCFCPX\ -\ NoDel/`: The destination directory where you want to synchronize the files. The path is specified with the necessary escaping of spaces using backslashes.
- `--delete`: This option tells `rsync` to delete any files in the destination directory that are not present in the source directory.
- `-n`: The dry-run option, which performs a trial run without making any actual changes. It shows what actions `rsync` would take but does not actually sync or delete any files.

With the `-n` option, the command will display the actions it would perform, including what files would be synchronized and deleted, but it won't make any changes to the directories.

Make sure to review the output carefully before running the command without the `-n` option to ensure that it will perform the desired synchronization and deletion actions.

### Use Scenario of DRDU
```bash
cd /Volumes/misc
rsync -arzP -v RAWVV-NoDel/ /Volumes/Dust/RAWVV-DustNoDel/ --delete -n
# confirm and then
rsync -arzP -v RAWVV-NoDel/ /Volumes/Dust/RAWVV-DustNoDel/ --delete
```

Your `rsync` command seems correct for synchronizing the `RAWVV-NoDel/` source directory to the `/Volumes/Dust/RAWVV-DustNoDel/` destination directory while preserving permissions, ownership, timestamps, and using compression. It also includes the `--delete` option to remove any files in the destination that do not exist in the source.

If you are looking for suggestions to enhance or modify the command, here are a few:

1. Dry Run: Before running the actual synchronization, you can add the `-n` option to perform a dry run. This will simulate the synchronization process and display the actions `rsync` would take without actually making any changes. It allows you to preview the results before proceeding.

2. Excluding Files or Directories: If you want to exclude specific files or directories from the synchronization, you can use the `--exclude` option followed by the file or directory patterns you want to exclude. For example, `--exclude="*.txt"` excludes all text files from the synchronization.

3. SSH Remote Sync: If the destination directory is on a remote machine accessible via SSH, you can use the `ssh` syntax to specify the remote host and destination directory. For example:
   ```
   rsync -arzPv RAWVV-NoDel/ user@remote_host:/Volumes/Dust/RAWVV-DustNoDel/ --delete
   ```

Remember to replace `user` with the appropriate username and `remote_host` with the hostname or IP address of the remote machine.

These suggestions can help you customize the `rsync` command based on your specific requirements. Please ensure you have a backup of your data and exercise caution while running any synchronization or deletion operations.

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
       --delete                delete extraneous files from dest dirs

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
# The trailing slash / ensures that the contents of the directory are
# synchronized rather than the directory itself.
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
$ rsync -arzP -v --exclude=".*" /Volumes/misc/RAWVV-NoDel/ /Volumes/Dust/RAWVV-DustNoDel -n
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
