## Tutorial
### Key Markdowns
- [Mount remote server to local disk](#sshfs)
- [Config YCM auto-compeltion for DPDK](#ycm)
- [Debug guide for `keepalived` - fork mode](#keepalived)
- [Debug guide for multi-thread mode](#multithread)

<a id=ycm></a>
### Config YCM auto-compeltion for DPDK

More hot-key please refer to [.vimrc](./track-files/vimrc)
#### commands for ycm
```ruby
:YcmRestartServer
:YcmDebugInfo
# <Leader> = ;
<Leader> D
<Leader> j
```

#### .ycm\_extra\_conf.py
Demo Config

```ruby
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
]
```

> **-isystem** followed path that was included with `<>`, and **-I** was followed by path included with `""`

- `<>` include

```c
#include <rte_rwlock.h>
#include <net/if.h>
```

You should use **-isystem**

```python
'-isystem',
'/mnt/221/dpdk-1805/build/include',
```

- `""` include

```c
#include "netif.h"
#include "ipvs/acl.h"
```

You should use **-I**

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