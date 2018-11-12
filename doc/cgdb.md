## cgdb
~~warning: do not type **layout src**, there was bug for gdb~~

### Contents
- [compile for debug](#compile)
- [run](#run)
- [reverse-next](#reverse-next)
- [finish](#finish)
- [break](#break)
- [unitl](#until)
- [condition](#condition)
- [info](#info)
- [logging](#logging)
- [shortcut](#shortcut)
- [cgdbusage](#cgdbusage)

<a id=compile></a>
### compile source file for debugging

_compile source file for debugging_

- `-g3` must be assigned
- `-O` must all be removed (~~Shift + o, optimized for short~~)

```bash
$ g++ -Wall -g3 main.cpp -o main

```

<a id=run></a>
### run
run with arguments after launching gdb

```bash
$ cgdb maini
(cgdb) run arg1 arg2 ...
```

<a id=finish></a>
### finish
> continue until hit a return

Upon return, the value returned is printed and put in the value history.

<a id=break></a>
### break
```
break main
break 334
```

<a id=until></a>
### until
> can be used to jump out of function

```
until + 3
until <Line_Number>

Execute until the program reaches a source line greater than the current
or a specified location (same args as break command) within the current frame))
```

<a id=condition></a>
### condition
> (gdb) help condition
Specify breakpoint number N to break only if COND is true.
Usage is `condition N COND', where N is an integer and COND is an
expression to be evaluated whenever breakpoint N is reached.

```vim
break <Function>
info breakpoints
condition 3 i == 3
```

<a id=info></a>
### info
```vim
info line
info line -- Core addresses of the code for a source line
```

<a id=logging></a>
### logging
> You may want to save the output of GDB commands to a file. There are several commands to control GDB’s logging.

#### logging - Example
```vim
set logging file ~/dpvs.log
set logging on
set trace-commands on
show logging

set logging on
Enable logging.

set logging off
Disable logging.

set logging file file
Change the name of the current logfile. The default logfile is gdb.txt.

set logging overwrite [on|off]
By default, GDB will append to the logfile. Set overwrite if you want set logging on to overwrite the logfile instead.

set logging redirect [on|off]
By default, GDB output will go to both the terminal and the logfile. Set redirect if you want output to go only to the log file.

show logging
Show the current values of the logging settings.
```

<a id=shortcut></a>
### shortcut key
> only support >= v0.7.0, refer <http://cgdb.github.io/docs/cgdb.html>

```
When you are in the source window, you are implicitly in CGDB mode. All of the below commands are available during this mode.
i
Puts the user into GDB mode.

s
Puts the user into scroll mode in the GDB mode.

Ctrl-T
Opens a new tty for the debugged program.
```

<a id=cgdbusage></a>
### cgdb usage
> Jump to cgdb source window, like VIM, type command below to switch to horizontal split

```
set winsplitorientation=vertical
set winsplitorientation=horizontal
```

<a id=reverse-next></a>
### reverse-next
> Step program backward, proceeding through subroutine calls
<https://sourceware.org/gdb/wiki/ProcessRecord>
<https://stackoverflow.com/questions/7517236/how-do-i-enable-reverse-debugging-on-a-multi-threaded-program>

For multi-thread reverse debugging
You need to active the instruction-recording target, by executing the command record

#### reverse - Example

```vim
record
next
reverse-next

record stop
```