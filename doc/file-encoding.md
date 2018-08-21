## file-encoding

### dos2linux
refer to <https://www.cyberciti.biz/faq/sed-remove-m-and-line-feeds-under-unix-linux-bsd-appleosx/>
> **!! Notice: ^M should be typed by 'Ctrl-V folled by Ctrl-M' !!**

- show ^M

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

### file encoding
```vim
# Just use 'utf-8' encoding when you create the file
:set fileencoding
:set fileencoding=utf-8
```
