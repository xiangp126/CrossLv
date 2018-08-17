## sftp

refer <https://unix.stackexchange.com/questions/7004/uploading-directories-with-sftp>

### Quick Start
```bash
sftp root@ip
```

> Remote Side

```bash
ls -l
cd
mkdir source
```

> Local Side

```bash
lls -l
lcd
```

> Note that **`source/`** must exists on remote server

```bash
put -r source/
```
