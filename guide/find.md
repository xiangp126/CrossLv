## find
> find link file to delete

```bash
find . -type l -exec rm -rf {} +
find . -name *.swp -exec rm -f {} +
```