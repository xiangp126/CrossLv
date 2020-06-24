## find
#### easiest way to use
```bash
find / -name for.txt
```

### find the linked files and delete them
```bash
find . -type l -exec rm -rf {} +
find . -name *.swp -exec rm -f {} +
```