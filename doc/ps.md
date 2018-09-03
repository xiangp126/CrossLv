## ps
> Get the start time of certain process

### find pid
```bash
ps aux | grep -i tmux

corsair   1885  0.0  1.4 138336 14912 ?        Ss   Jul02   0:58 tmux -u
corsair  24702  0.0  0.1 119500  1408 pts/17   S+   08:10   0:00 tmux -u attach -t vultr
corsair  24704  0.0  0.0 112716  1008 pts/13   R+   08:10   0:00 grep -i --color=auto -i tmux
```

### get time according to pid
take 1885 for example

```bash
ps -A -opid,stime,etime,args | grep -i 1885

 1885 Jul02 28-00:01:31 tmux -u
24706 08:11       00:00 grep -i --color=auto -i 1885
```