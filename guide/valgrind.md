## valgrind
```bash
# assume main is the executable program
valgrind --tool=memcheck --leak-check=full --show-reachable=yes ./main
```