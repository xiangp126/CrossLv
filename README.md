### Introduction
- I wrote some tools to help me work more efficiently. These tools are mainly used for building, debugging, searching and connecting to devices.

- The tools are written in bash and expect tcl and are easy to use. The tools are mainly used in the Fortinet environment, but they can also be used in other environments.

### Key Tools

- [onekey](#onekey)
- [jmake](#jmake)
- [jssh](#jssh)
- [jdebug](#jdebug)
- [jr](#jr)

<a id="onekey"></a>
#### [onekey](./oneKey.sh)
use `onekey.sh` to link all the tools to the system path, and then you can use the tools directly in the terminal.

```bash
$ sh oneKey.sh -h
Usage: ./oneKey.sh [uth]

Options:
    -t, --tools     Link tools into $HOME/.usr/bin
    -u, --update    Force an update of prerequisites
    -h, --help      Print this help message

Recommdned:
    ./oneKey.sh -t

Examples:
    ./oneKey.sh
    ./oneKey.sh -t
    ./oneKey.sh -u
    ./oneKey.sh -h

```

<a id="jmake"></a>
#### [jmake](./ftnt-tools/jmake)
```bash
$ jmake
Usage: jmake [options]
       jmake [-m model] [-w working_dir] [-j num_of_jobs] [-T max_attempt]
             [-s sync_target] [-S sync_file] [-P sync_port] [-l/-u username] [-p password]
             [-B build_target]
             [-bcCohfk1]

Build Flags:
    -c      Clean the repo (default: false)
    -C      Run Configure intelligently (default: false)
    -o      Run build commands (set automatically if any of the [bmjwT] options is set)
    -b      Use Bear to generate compile_commands.json (default: false)
    -f      Remove compile_commands.json (default: false)

Build Options:
    -T      Set the maximum number of build attempts (default: 1)
    -B      Set the build target (default: image.out)
    -m      Set the build model  (default: KVM)
    -j      Set the number of jobs (default: 20)
    -w      Set working directory  (default: /data/fpx)
    -k      Rebuild the kernel (default: false)

Sync Options:
    -s      Set the sync source file (default: image.out)
    -t      Set the sync target machine (default: false)
    -P      Set the sync ssh port (default: 22)
    -l/-u   Set the sync username (default: admin)
    -p      Set the sync password (default: password)

Other Options:
    -h      Print this help message

Example:
    jmake -m FGT_VM64_KVM -c -T1 -j4 -b
    jmake -m vmware
    jmake -t fgt1 -s FGT_VM64_KVM-v7-build1662.out -l "admin" -p "password" -P 22

```

<a id="jssh"></a>
#### [jssh](./ftnt-tools/jssh)
```bash
$ jssh
jssh 1.0

usage:
    jssh [options]
    jssh [-l/-u user] [-p passwd] [-P ssh_port] [-v vdom] [-h] -t [user@]target[:port]
         [-c command] [-C]
         [-J user@jumpserver[:port]] [-W jump_passwd]
         [-L [local_listen_addr:]local_listen_port:target_addr:target_port]
         [-R [remote_listen_addr:]remote_listen_port:target_addr:target_port]
         [-M [dir:]mountpoint]
         [-S] [-T] [-X]

Basic Options:
    -t     Target        The device to connect to
    -l/-u  Username      Username for login (default: admin)
    -p     Password      Password for login (default: password)
    -P     Port          SSH Port to connect to (default: 22)
    -c     Command       Execute commands remotely without opening an interactive login session
    -C     Capture       Live capture packets from the remote device
    -h     Help          Print this help message

Forwarder Options:
    -L     Forwarder     Local Forwarder. Format: [local_listen_addr:]local_listen_port:target_addr:target_port
    -R     Reverse       Reverse Forwarder. Format: [remote_listen_addr:]remote_listen_port:target_addr:target_port
    -J     Jump Server   The jump server to connect to. Format: user@jumpserver[:port]
    -W     Jump Passwd   Password for jump server (default: password)

Advanced Options:
    -X     X11 Forward   Enable X11 forwarding
    -v     Vdom          Specify the VDOM (Useful for FGT/FPX devices)
    -M     Mountpoint    SSHFS Mode. Mount remote directory to local directory. Format: [dir:]mountpoint
    -S     SFTP Mode     Connect to the target device via SFTP
    -T     Telnet Mode   Auth to the target device via Telnet

Example:
    # SSH Connection
    jssh -t fpx1
    jssh -t 172.18.20.214 -l admin -p 1
    jssh -t fpxauto@172.18.20.84:22 -p qaz

    # SSH with a Jump Server
    jssh -t guodong@10.120.1.111 -P 2121 -p 123 -J fpxauto@172.18.20.84:22 -W qaz
    jssh -t 172.18.52.37 -l owner -p "FGT12\!34" -J fpxauto@172.18.20.84:22 -W qaz

    # SFTP Connection
    jssh -t 172.18.52.37 -l owner -p "FGT12\!34" -S

    # SFTP with a Jump Server
    jssh -t 172.18.52.37 -l owner -p "FGT12\!34" -J fpxauto@172.18.20.84:22 -W qaz -S

    # Remote Live Capture
    jssh -t fpxauto@172.18.20.84:22 -p qaz -c "tcpdump -i any -s 0 -U -n -vv 'not port 22 and not arp'"
    jssh -t fpxauto@172.18.20.84:22 -p qaz -c "tcpdump -i any -s 0 -U -n -w - 'not port 22 and not arp'" -C
    jssh -t 172.18.52.37 -l owner -p "FGT12\!34" -J fpxauto@172.18.20.84:22 -W qaz -c "tcpdump -i any -s 0 -U -n -w - 'not port 22 and not arp'" -C

    # Local Port Forwarding
    jssh -L 127.0.0.1:8881:172.18.52.37:22 -J fpxauto@172.18.20.84:22 -W qaz -l owner -p "FGT12\!34"

    # Reverse Port Forwarding
    jssh -R 127.0.0.1:1080:172.18.52.37:22 -J fpxauto@172.18.20.84:22 -W qaz -l owner -p "FGT12\!34"

    # SSHFS to mount remote directory
    jssh -t 172.18.52.37 -l owner -p "FGT12\!34" -M :~/MP
    jssh -t 172.18.52.37 -l owner -p "FGT12\!34" -J fpxauto@172.18.20.84:22 -W qaz -M :~/MP

```

<a id="jdebug"></a>
#### [jdebug](./ftnt-tools/jdebug)
```bash
$ jdebug
jdebug 0.1

Usage: jdebug [-t target] [-w worker_type] [-P gdbserver_listen_port] [-T max_attempts]
              [-u/-l username] [-p password] [-P ssh_conn_port] [-h]
              [-N wad_worker_count]
              [-n] [-k ]

Options:
    -t      Target device name or IP address(must be set)
    -w      Worker type(default: worker)
    -d      GDB Server listen port(default: 444)
    -l/-u   Username(default: admin)
    -p      Password(default: password)
    -P      SSH connection port(default: 22)
    -N      Set wad worker count(default: -1)
            0: unlimited, 1: 1 worker to make life easier, -1: keep the original value
    -n      No debug, only display the wad process info
    -k      Kill the existing gdbserver process attached to the worker PID
    -T      Maximum attempt(default: 2)
    -h      Print this help message

Example:
    jdebug -t fgt1
    jdebug -t fgt1 -P 22
    jdebug -t fgt1 -p "123" -N1
    jdebug -t fgt1 -w algo -d 9229
    jdebug -t fgt1 -w algo -d 9229 -l "admin" -p "123"
    jdebug -h

```
<a id="jr"></a>
#### [jr](./ftnt-tools/jr)
```bash
$ jr
jr v0.0

Usage: jr [vzd] <search term>

Options:
    -z  Search with empty query (you can also use jz command directly)
    -v  Open the file with vim (default is code)
    -e  Extended Search. Include the linux kernel source code in the search
    -d  Print debug information
    -r  Only use rg to search, not use fzf

Example: jr "search term"
         jr -z

Notice: The search term must be the last argument!

```

### License
The [MIT](./LICENSE.txt) License (MIT)
