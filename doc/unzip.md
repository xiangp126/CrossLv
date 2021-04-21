## Unzip files in particular directory or folder

```bash
mkdir myfolder
unzip package.zip -d myfolder
cd myfolder
ls -l
```

```bash
man unzip
...
       [-d exdir]
              An optional directory to which to extract files.  By default, all files and subdirectories are recreated in the current directory; the -d option allows extraction  in  an  arbitrary
              directory  (always assuming one has permission to write to the directory). 
```
