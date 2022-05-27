## cgdb
**Warning**: There is a bug of gdb. To avoid it, do not type ~~layout src~~ in gdb.

### Commonly Used
- [thread](#thread)
- [scheduler-locking](#locking)
- [follow-fork-mode](#fork)
- [reverse-next](#reverse-next)
- [finish](#finish)
- [break](#break)
- [unitl](#until)
- [condition](#condition)
- [info](#info)
- [logging](#logging)
- [set](#set)
    - [pagination](#pagination)

### Not Commonly Used
- [compile for debug](#compile)
- [debug with _core_ file](#core)
- [run with arguments](#run)

#### Basic `cgdb` Manipulation
- [horizontal or vertical?](#horizontal)
- [shortcut manipulation](#shortcut)

<a id=compile></a>
### compile source file for debugging

_compile source file for debugging_

- `-g3` must be assigned
- `-Onum` must all be removed (~~Shift + o, optimized for short~~)
- or change all `-O1`, `-O2`, ... etc to `-O0`

```bash
g++ -Wall -g3 main.cpp -o main
```

<a id=core></a>
### debug with `core` file
let Linux generate core

```bash
ulimit -c unlimited
```

run with `core`

```bash
cgdb ./main -c core.63522
```

<a id=run></a>
### run
> run with arguments after launching `gdb`

```bash
cgdb main
(cgdb) run arg1 arg2 ...
```

<a id=finish></a>
### finish
**continue until hit a `return`**

Upon return, the value returned is printed and put in the value history.

<a id=break></a>
### break
```bash
break main
break <Line_Number>

# break at a line of certain file
break /Full/path/to/service.cpp:45
```

help message

```
break [PROBE_MODIFIER] [LOCATION] [thread THREADNUM] [if CONDITION]

THREADNUM is the number from "info threads".
CONDITION is a boolean expression.

Multiple breakpoints at one place are permitted, and useful if their
conditions are different.
```

<a id=until></a>
### until
> Execute until the program reaches a source line **greater than** the current or a specified location (same args as break command) within the current frame

```bash
until +3
until <Line_Number>
```

<a id=condition></a>
### condition
> Specify breakpoint number `N` to break only if `COND` is true<br>
> `N` is an **integer**<br>
> `COND` is an **expression** to be evaluated whenever breakpoint `N` is reached

```bash
condition N COND
```

<a id=info></a>
### info

`Arg` can be:

> `LINENUM`, to list around that line in current file<br>
`FILE:LINENUM`, to list around that line in that file<br>
`FUNCTION`, to list around beginning of that function<br>
`FILE:FUNCTION`, to distinguish among like-named static functions<br>
Default is to describe the last source line that was listed<br>

```bash
# Core addresses of the code for a source line
info linke <Arg>
```

<a id=logging></a>
### logging
> You may want to save the output of GDB commands to a file. There are several commands to control GDB’s logging.

_logging - Example_

```vim
(gdb) set logging file ~/dpvs.log
(gdb) set logging on
(gdb) set trace-commands on
(gdb) show logging

(gdb) set logging on
Enable logging.

(gdb) set logging off
Disable logging.

(gdb) set logging file file
Change the name of the current logfile. The default logfile is gdb.txt.

(gdb) set logging overwrite [on|off]
By default, GDB will append to the logfile. Set overwrite if you want set logging on to overwrite the logfile instead.

(gdb) set logging redirect [on|off]
By default, GDB output will go to both the terminal and the logfile. Set redirect if you want output to go only to the log file.

(gdb) show logging
Show the current values of the logging settings.
```
---

<a id=set></a>
<a id=pagination></a>
### pagination
surpress pagination when print long messages, or it will keep asking you to type `q` or press `Enter`

```bash
set pagination off
```

<a id=reverse-next></a>
### reverse-next
> step program backward, proceeding through subroutine calls
<https://sourceware.org/gdb/wiki/ProcessRecord>
<https://stackoverflow.com/questions/7517236/how-do-i-enable-reverse-debugging-on-a-multi-threaded-program>

> for **multi-thread reverse debugging**
You need to active the **instruction-recording target**, by executing the command `record`

_reverse - Example_

```
(gdb) record
(gdb) next
(gdb) reverse-next
...
(gdb) record stop
```

<a id=thread></a>
### thread
```bash
info threads
thread ID
break thread_test.c:123 thread all
thread apply ID1 ID2 command
thread apply all command
```

<a id=locking></a>
### scheduler-locking
Set mode for locking scheduler during execution.

set scheduler-locking **on**

```ruby
off  == no locking (threads may preempt at any time)
on   == full locking (no thread except the current thread may run)
step == scheduler locked during every single-step operation
    In this mode, no other thread may run during a step command.
    Other threads may run while stepping over a function call ('next')
```

<a id=fork></a>
### follow-fork-mode
Set debugger response to a program call of `fork` or `vfork`.

By default, the debugger will follow the **parent** process.

set follow-fork-mode **parent**

```bash
A fork or vfork creates a new process.  follow-fork-mode can be:
  parent  - the original process is debugged after a fork
  child   - the new process is debugged after a fork
The unfollowed process will continue to run.
```

#### detach-on-fork
default **on**

set detach-on-fork **off**

```bash
Set whether gdb will detach the child of a fork.
Tells gdb whether to detach the child of a fork.
```

---
<a id=horizontal></a>
### horizontal or vertical?
> Jump to cgdb **source window**, like VIM, type command below to switch to horizontal split

`Alt + <Up/Down>` or `ESC`, switch to `source window`

then `:` into `configuration mode`

```bash
set winsplitorientation=vertical
set winsplitorientation=horizontal
```

<a id=shortcut></a>
### shortcut key
> only support `cgdb` version >= **v0.7.0**, refer to <http://cgdb.github.io/docs/cgdb.html>

```bash
# When you are in the source window, you are implicitly in CGDB mode.
# All of the below commands are available during this mode.

# Puts the user into GDB mode.
i

# Puts the user into scroll mode in the GDB mode.
s

# Opens a new tty for the debugged program.
Ctrl-T
```