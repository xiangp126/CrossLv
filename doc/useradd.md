## useradd

### add
```bash
# sudo useradd -m -s "/bin/bash" vbird
sudo passwd vbird
su - vbird
```

### delete
```bash
sudo userdel -r vbird
```

### appendix

- if you want to change the default shell and it's impossible for you to change `/etc/passwd`

```bash
set -x
if [ "$SHELL" != "/bin/bash" ]
then
    export SHELL="/bin/bash"
    exec /bin/bash -l    # -l: login shell again
fi
```