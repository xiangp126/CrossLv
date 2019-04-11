## parted
for harddisk larger than 2T, you have to use `parted` instead of `fdisk`.

And format `GPT` instead of `MBR`

## show info of partion 
```bash
lsblk
fdisk -l
df -TH
```

## Follow Steps
take **/dev/sdb** for example

```bash
parted /dev/sdb
parted (GNU parted) 3.1
Welcome to GNU Parted! Type 'help' to view a list of commands.
```

### help message
```bash
(parted) help
  check NUMBER                             do a simple check on the file system
  cp [FROM-DEVICE] FROM-NUMBER TO-NUMBER   copy file system to another partition
  help [COMMAND]                           prints general help, or help on COMMAND
  mklabel,mktable LABEL-TYPE               create a new disklabel (partition table)
  mkfs NUMBER FS-TYPE                      make a FS-TYPE file system on partititon NUMBER
  mkpart PART-TYPE [FS-TYPE] START END     make a partition
  mkpartfs PART-TYPE FS-TYPE START END     make a partition with a file system
  move NUMBER START END                    move partition NUMBER
  name NUMBER NAME                         name partition NUMBER as NAME
  print [free|NUMBER|all]                  display the partition table, a partition, or all devices
  quit                                     exit program
  rescue START END                         rescue a lost partition near START and END
  resize NUMBER START END                  resize partition NUMBER and its file system
  rm NUMBER                                delete partition NUMBER
  select DEVICE                            choose the device to edit
  set NUMBER FLAG STATE                    change the FLAG on partition NUMBER
  toggle [NUMBER [FLAG]]                   toggle the state of FLAG on partition NUMBER
  unit UNIT                                set the default unit to UNIT
  version                                  displays the current version of GNU Parted and copyright information
```

### make label `GPT`
```bash
# 建立磁盘标签
(parted) mklabel GPT
# 如果没有任何分区，它查看磁盘可用空间，当分区后，它会打印出分区情况
(parted) print
# 创建两个主分区，容量各占整个磁盘的50%
(parted) mkpart primary 0% 50%
(parted) mkpart primary 50% 100%

#  分区完后，直接 quit 即可，不像 fdisk 分区的时候，还需要保存一下，这个不用
(parted) quit

# 让内核知道添加新分区
partprobe

# 格式化
mkfs.ext4 /dev/sdb1
mkfs.ext4 /dev/sdb2

# 挂载分区
mkdir /mnt/sdb1
mkdir /mnt/sdb2

mount /dev/sdb1 /mnt/sdb1
mount /dev/sdb2 /mnt/sdb2

# 设置开机自动挂载磁盘
vim /etc/fstab
/dev/sdb2    /data    ext4    defaults    0    0
/dev/sdb2    /data    ext4    defaults    0    0

# fdisk 命令无法使用可以用 parted
fdisk -l
parted -l

# parted 有 2 种模式，使用命令行模式方便自动化
 命令行模式: parted [option] device [command]
交互模式: parted [option] device

```