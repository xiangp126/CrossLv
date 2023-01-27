## ps
Get the start time of certain process

### find pid
```bash
ps aux
ps aux | grep -i tmux

corsair   1885  0.0  1.4 138336 14912 ?        Ss   Jul02   0:58 tmux -u
corsair  24702  0.0  0.1 119500  1408 pts/17   S+   08:10   0:00 tmux -u attach -t vultr
corsair  24704  0.0  0.0 112716  1008 pts/13   R+   08:10   0:00 grep -i --color=auto -i tmux
```

### get the time according to pid
take PID `1885` for example

```bash
ps -A -opid,stime,etime,args | grep -i 1885

 1885 Jul02 28-00:01:31 tmux -u
24706 08:11       00:00 grep -i --color=auto -i 1885
```

### read the output of `ps` command
ps -> process status

```bash
man ps

     state     The state is given by a sequence of characters, for example, ``RWNA''.  The first character indicates the run
               state of the process:

               I       Marks a process that is idle (sleeping for longer than about 20 seconds).
               R       Marks a runnable process.
               S       Marks a process that is sleeping for less than about 20 seconds.
               T       Marks a stopped process.
               U       Marks a process in uninterruptible wait.
               Z       Marks a dead process (a ``zombie'').

               Additional characters after these, if any, indicate additional state information:

               +       The process is in the foreground process group of its control terminal.
               <       The process has raised CPU scheduling priority.
               >       The process has specified a soft limit on memory requirements and is currently exceeding that limit; such
                       a process is (necessarily) not swapped.
               A       the process has asked for random page replacement (VA_ANOM, from vadvise(2), for example, lisp(1) in a
                       garbage collect).
               E       The process is trying to exit.
               L       The process has pages locked in core (for example, for raw I/O).
               N       The process has reduced CPU scheduling priority (see setpriority(2)).
               S       The process has asked for FIFO page replacement (VA_SEQL, from vadvise(2), for example, a large image
                       processing program using virtual memory to sequentially address voluminous data).
               s       The process is a session leader.
               V       The process is suspended during a vfork(2).
               W       The process is swapped out.
               X       The process is being traced or debugged.

```