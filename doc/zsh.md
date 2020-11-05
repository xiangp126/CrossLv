## zsh - z shell
### Allow comments with `#` in interactive zsh commands

[Allowing comments in interactive zsh commands](https://unix.stackexchange.com/questions/557486/allowing-comments-in-interactive-zsh-commands)

[zsh Interpret/ignore commands beginning with '#' as comments](https://unix.stackexchange.com/questions/33994/zsh-interpret-ignore-commands-beginning-with-as-comments)

```bash
set -k
# or
setopt interactive_comments
```