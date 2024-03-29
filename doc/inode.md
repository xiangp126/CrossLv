## inode

[Detailed Understanding of Linux Inodes with Example](https://linoxide.com/linux-command/linux-inode/#:~:text=Inode%20number%20is%20also%20known,such%20as%20ext3%20or%20ext4.)

<https://www.cyberciti.biz/tips/delete-remove-files-with-inode-number.html>

```bash
find . -inum [inode number] -exec rm -i {} \;
```

### How to delete Dir using its `inode number`
**Do Not Use iCloud Drive**

~~take directory `iCloud Drive (Archive) - 1/` for example~~

#### find inum(inode number)
```bash
ls -li

37196690 drwx------   5 corsair  staff   160 Aug 31 18:43 iCloud Drive (Archive)
37208628 drwx------   6 corsair  staff   192 Aug 31 20:42 iCloud Drive (Archive) - 1
37252422 drwx------   5 corsair  staff   160 Aug 31 20:50 iCloud Drive (Archive) - 2
```

#### find the specific file through inode number
```bash
$ find . -inum 37208628
./iCloud Drive (Archive) - 1
```

#### found and delete it
```bash
# try to delete the specific file
find . -inum 37208628 -exec rm -i {} \;
rm: ./iCloud Drive (Archive) - 1: is a directory

# add -i(interactive) for safe delete
find . -inum 37208628 -exec rm -ri {} \;
examine files in directory ./iCloud Drive (Archive) - 1? y
remove ./iCloud Drive (Archive) - 1/.DS_Store? y
examine files in directory ./iCloud Drive (Archive) - 1/Desktop? ^C

# success
find . -inum 37208628 -exec rm -rf {} \;
find: ./iCloud Drive (Archive) - 1: No such file or directory
corsair@Giggle:~$ ll
```