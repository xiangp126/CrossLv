## valgrind

a tool to help us to check if there exists memory leak

```bash
# assume main is the executable program
valgrind --tool=memcheck --leak-check=full --show-reachable=yes ./main
```