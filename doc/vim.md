## vim
vim manipulation record

### Removing trailing whitespace
```vim
:%s/\s\+$//gc
```

### Del ^M generated from Windows
```vim
:%s/\r//gc
```

### Shortcut Key with Iterm2
> As illustrated

![](../res/iterm2-Alt.png)

```bvim
# mapping Alt to Esc+
# so typing 'Alt + O' equals typing 'Esc + O'

then

Alt + o   next line in 'Insert Mode'
Alt + Shift + i  goto current head of line
```

### copy
> Copy line 31-33 to below current line

```vim
:31, 33 copy .
```
<br>
---
### registers
<https://vi.stackexchange.com/questions/84/how-can-i-copy-text-to-the-system-clipboard-from-vim>

