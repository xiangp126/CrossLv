## dmesg
dmesg is used to examine or control the kernel ring buffer.

The default action is to read all messages from `kernel ring buffer`.

### follow monitor
```bash
# Wait for new messages. -w or --follow
dmesg --follow
# Enable human readable output
dmesg --follow -H
# Print human readable timestamps
dmesg --follow -T
```

### write to file
this type of messages was originally writted to `/proc/kmsg`

do not tempt to `vim` the file

### Explain Key Parameters
> output of `pr_info` & `printk` can be seen using `dmesg`

* -w, --follow

```ruby
Wait for new messages. This feature is supported on systems with readable `/dev/kmsg` only (since kernel 3.5.0).
```

* -T

```ruby
Print human readable timestamps.  The timestamp could be inaccurate!
```
 
* -H

```ruby
-H, --human

Enable human readable output.  See also --color, --reltime and --nopager.
```

* -n

all levels of messages are **still written** to `/proc/kmsg`

```ruby
-n, --console-level level
       Set the level at which logging of messages is done to the console.  The level is a level number or abbreviation of the  level
       name.  For all supported levels see dmesg --help output.

       For  example,  -n 1 or -n alert prevents all messages, except emergency (panic) messages, from appearing on the console.  All
       levels of messages are still written to /proc/kmsg, so syslogd(8) can still be used to control exactly where kernel  messages
       appear.  When the -n option is used, dmesg will not print or clear the kernel ring buffer.
```

Supported log levels (priorities):

```ruby
   emerg - system is unusable
   alert - action must be taken immediately
    crit - critical conditions
     err - error conditions
    warn - warning conditions
  notice - normal but significant condition
    info - informational
   debug - debug-level messages
```

#### About Log Level

see log levels for your system

```bash
cat /proc/sys/kernel/printk
1	4	1	7
```

from `left -> right` were defined in `kernel/printk.c`

```c
int console_printk[4] = {
    DEFAULT_CONSOLE_LOGLEVEL,	/* console_loglevel */
    DEFAULT_MESSAGE_LOGLEVEL,	/* default_message_loglevel */
    MINIMUM_CONSOLE_LOGLEVEL,	/* minimum_console_loglevel */
    DEFAULT_CONSOLE_LOGLEVEL,	/* default_console_loglevel */
};
```

only `priority` **greater** than `console_loglevel` will be printed to console

_greater than: means the numeric of `priority` was **smaller** than `console_loglevel`_

```c
#define KERN_EMERG    "<0>"  /* system is unusable               */
#define KERN_ALERT    "<1>"  /* action must be taken immediately */
#define KERN_CRIT     "<2>"  /* critical conditions              */
#define KERN_ERR      "<3>"  /* error conditions                 */
#define KERN_WARNING  "<4>"  /* warning conditions               */
#define KERN_NOTICE   "<5>"  /* normal but significant condition */
#define KERN_INFO     "<6>"  /* informational                    */
#define KERN_DEBUG    "<7>"  /* debug-level messages             */
```