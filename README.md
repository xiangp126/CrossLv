### Usage
```bash
$ git clone https://github.com/xiangp126/crosslv

$ cd crosslv
# Better to use bash not sh to run the script for the first time.
$ bash oneKey.sh
Usage: ./oneKey.sh [iuchH]
Options:
    -h, --help                      Print this help message
    -i, --install                   Create symbolic links
    -H, --hard-install              Perform a hard installation
        -t, --tools                 Link tools into /home/xiangp/.usr/bin
        -c, --check                 Check sudo privileges
        -u, --update                Force an update

Recommdned:
    ./oneKey.sh -i

Examples:
    ./oneKey.sh -i
    ./oneKey.sh -it
    ./oneKey.sh -ic
    ./oneKey.sh -iu
    ./oneKey.sh -iuH
    ./oneKey.sh -h

$ bash oneKey.sh -ic
```

### Demo
![](./res/persistlv.gif)

Please Note: The script will also relink /bin/sh to /bin/bash on Ubuntu.

### License
The [MIT](./LICENSE.txt) License (MIT)
