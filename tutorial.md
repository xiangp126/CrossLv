## Tutorial
### Key Markdowns
- [Config YCM auto-compeltion for DPDK](#ycm)
- [Mouont remote server to local disk](#sshfs)

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