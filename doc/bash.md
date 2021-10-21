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
# seq -- print sequences of numbers
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

### IF Clause

[What is the difference between the Bash operators \[\[ vs \[ vs \( vs \(\(](https://unix.stackexchange.com/questions/306111/what-is-the-difference-between-the-bash-operators-vs-vs-vs)

#### [ ]
```bash
#!/bin/bash

echo "Enter a number: "
read VAR

if [ $VAR -gt 10 ]
then
  echo "The variable is greater than 10."
else
  echo "The variable is equal or less than 10."
fi
```

#### [[ ]]
```bash
# Need to be upgraded
#!/bin/bash

echo "Enter a number: "
read VAR

if [[ $VAR -gt 10 ]]
then
  echo "The variable is greater than 10."
else
  echo "The variable is equal or less than 10."
fi
```
