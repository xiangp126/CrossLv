## tmux

### new session
```bash
tmux
# or
tmux new-session
# and then change the session name
```

**! DO NOT USE tmux new-session -t XX**

### attach existing session

```bash
# say session name is 0
tmux attach-session -t 0
```