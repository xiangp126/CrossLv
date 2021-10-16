## Bash Scripting

### For Loop
#### Syntax 1
```bash
#!/usr/bin/bash
for i in {1..99}
do
    echo $i
done

# must check if sh was linked to bash
# before execution of sh testsh
```

#### Syntax 2 - Using `seq` command
```bash
$ seq 1 3
1
2
3
```

- Formatted seq

```bash
# printf syntax
$ seq -f "%02g" 1 3
01
02
03
```

using seq command

```bash
for i in $(seq -f "%02g" 1 3)
do
    echo $i
done
```