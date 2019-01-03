## Tutorial
### Contents for Key Skills
- [mount remote server to local disk](#sshfs)
- [`YCM` auto-compeltion config how-to](#ycm)
    - [config for calling DPDK functions](#dpdk)
    - [config for calling Linux Kernel functions](#kernel)
- [debug guide for `keepalived` - fork mode](#keepalived)
- [debug guide for multi-thread mode](#multithread)

<a id=ycm></a>
### YCM auto-compeltion config how-to
#### .ycm\_extra\_conf.py
```ruby
# full path: ~/.ycm\_extra\_conf.py
flags = [
'-Wall',
'-Wextra',
# Turn warning into an error.
# '-Werror',
'-fexceptions',
'-DNDEBUG',
'-std=c++11',
'-x',
'c',
'-isystem',
'/usr/include',
'-I.',
'-I./include',
'-I./inc',
]
```

- **-isystem**

> **-isystem** followed by path that was included with `<>`, and **-I** was followed by path included with `""`

- `<>` include

```c
#include <rte_rwlock.h>
#include <net/if.h>
```

auto-complete functions in these headers, you should use **-isystem**, like

```python
'-isystem',
'/mnt/221/dpdk-1805/build/include',
```

- `""` include

```c
#include "netif.h"
#include "ipvs/acl.h"
```

auto-complete functions in these headers, you should use **-I**, like

```python
'-I./include',
```

<a id=dpdk></a>
#### Config for calling DPDK functions
- config

add one `-isystem` entry like this:

```python
'-isystem',
'/mnt/221/dpdk-1805/build/include',
```

and yields:

```python
# For a C project, you would set this to 'c' instead of 'c++'.
'-x',
'c',
'-isystem',
'/usr/include',
'-isystem',
'/mnt/221/dpdk-1805/build/include',
'-I.',
'-I./include',
'-I./include/ipvs'
```

- commands for ycm

more hot-key please refer to [.vimrc](./track-files/vimrc)

```python
:YcmRestartServer
:YcmDebugInfo
# <Leader> = ;
<Leader> D
<Leader> j
```

<a id=kernel></a>
#### Config for calling Linux Kernel functions
for example, when you try to write kernel modules, add one `-isystem` entry like this:

```python
'-isystem',
'/usr/src/kernels/3.10.0-327.36.3.el7.x86_64/include/',
```

and yields:

```python
# For a C project, you would set this to 'c' instead of 'c++'.
'-x',
'c',
'-isystem',
'/usr/include',
'-isystem',
'/usr/src/kernels/3.10.0-327.36.3.el7.x86_64/include/',
'-I.',
'-I./include',
'-I./inc',
]
```

<a id=sshfs></a>
### Mouont remote server to local disk
then you could use all your local tools. refer [sshfs](./doc/sshfs.md)

<a id=keepalived></a>
### Debug guide for `keepalived` - fork mode
refer  [Gdb](./doc/gdb.md)

#### not strip binary
```bash
# cd keepalived/
# vim Makefile

all:
    @set -e; \
    for i in $(SUBDIRS); do \
    $(MAKE) -C $$i || exit 1; done && \
    echo "Building $(BIN)/$(EXEC)" && \
    $(CC) -o $(BIN)/$(EXEC) `find $(SUBDIRS) ../lib -name '*.[oa]'` $(DPVSDEPS) $(LDFLAGS)
    # $(STRIP) $(BIN)/$(EXEC)      <--- comment on this line
    @echo ""
    @echo "Make complete"
```

#### begin to debug
```bash
set follow-fork-mode child
set detach-on-fork off
```

then break on certain function you need

<a id=multithread></a>
### Debug guide for multi-thread mode

same as **multi-core** mode

```bash
br function
run
...

set scheduler-locking on

# step or next
```

if you want to **re-run** the program, you should `set scheduler-locking off` before `run`

```bash
# re-run the program
kill
set scheduler-locking off
run
```