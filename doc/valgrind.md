## valgrind

tool help to check memory leak

```bash
# assume main is the executable program
valgrind --tool=memcheck --leak-check=full --show-reachable=yes ./main
```