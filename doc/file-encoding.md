## file-encoding

### dos2linux
refer to <https://www.cyberciti.biz/faq/sed-remove-m-and-line-feeds-under-unix-linux-bsd-appleosx/>
> **!! Notice: `^M` should be typed by 'Ctrl-V followed by Ctrl-M' !!**

- show `^M`

```vim
:e ++ff=unix %
```

- replace with ''

```vim
:%s/^M$//g
```

### sed
```bash
sed 's/^M//g' haha.txt
```

### File Encoding
```vim
# Just use 'utf-8' encoding when you create the file
# Tips: on Mac open SRT subtitles using TextEdit

:set fileencoding
:set fileencoding=utf-8
```
