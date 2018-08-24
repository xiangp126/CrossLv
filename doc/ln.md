## ln
```bash
ll ~/.bashrc
-rwxr-xr-x  1 vbird  staff  5336 Jun 14 11:41 ~/.bashrc*

pwd
# ~/myGit
```

### hard link
```bash
ln ~/.bashrc .
```
```bash
ll .bashrc
-rwxr-xr-x  2 corsair  staff  5336 Jun 14 11:41 .bashrc*
```

### soft link
```bash
ln -s ~/.bashrc .
```
```bash
ll .bashrc
lrwxr-xr-x  1 vbird  staff  22 Aug 23 15:40 .bashrc@ -> ~/.bashrc
```