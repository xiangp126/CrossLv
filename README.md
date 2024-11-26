### Usage
```bash
$ git clone https://github.com/xiangp126/crosslv

$ cd crosslv
# Better to use bash not sh to run the script for the first time.
$ bash oneKey.sh -h

Persist the environment settings and tools for the current user

Usage: ./oneKey.sh [uth]

Options:
    -t, --tools     Link tools into /home/xiangp/.usr/bin
    -u, --update    Force an update of prerequisites
    -h, --help      Print this help message

Recommdned:
    ./oneKey.sh -t

Examples:
    ./oneKey.sh
    ./oneKey.sh -t
    ./oneKey.sh -u
    ./oneKey.sh -h

$ bash oneKey.sh
```

<!-- ### Demo -->
<!-- ![](./res/persistlv.gif) -->

Please Note: The script will also relink /bin/sh to /bin/bash on Ubuntu.

### License
The [MIT](./LICENSE.txt) License (MIT)
