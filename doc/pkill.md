## pkill

find or signal process by name, then kill the process

### who
```bash
who

vbird  pts/12        2018-07-05 14:51 (ip address)
vbird  pts/9        2018-07-05 14:51 (ip address)
```

### kill tty
take pts/12 for example

```
pkill -kill -t pts/12
```
