## sftp

<https://unix.stackexchange.com/questions/7004/uploading-directories-with-sftp>

### Local Side
- start conversation

```bash
sftp root@ip
```

- list resources

```bash
# add a 'l' (means local) before the originally standard command
# ls -> lls, cd -> lcd
lls -l
lcd
```

- Note that **`source/`** was on remote server

```bash
put -r source/
```

### Remote Side

```bash
ls -l
cd
# mkdir source
get xx
```