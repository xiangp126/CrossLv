## find
#### Easiest way to use
```bash
find / -name for.txt
```

### Find the linked files and delete them

```bash
find . -type l -exec rm -rf {} +
find . -name *.swp -exec rm -f {} +
```
