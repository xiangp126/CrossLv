## find
#### easiest way to use
```bash
find / -name fake.txt
```

### find the linked files and delete them
```bash
find . -type l -exec rm -rf {} +
find . -name *.swp -exec rm -f {} +
```