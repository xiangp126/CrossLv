## dmesg
dmesg is used to examine or control the kernel ring buffer.

The default action is to read all messages from `kernel ring buffer`.

### follow monitor

-H, --human

Enable human readable output.  See also --color, --reltime and --nopager.

-w, --follow

Wait for new messages. This feature is supported on systems with readable `/dev/kmsg` only (since kernel 3.5.0).

```bash
dmesg --follow
# or dmesg -w
dmesg --follow -H
```

### file written
this type of messages was originally writted to `/proc/kmsg`

do not tempt to `vim` the file

### tips
output of `pr_info` & `printk` can be seen using `dmesg`