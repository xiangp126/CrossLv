## p7zip
### Example
```bash
7z a -mhe=on -pcipher me.7z me/

7z a
7z x
7z x me.7z
```

### Syntax
```
-mhe=on|off
  7z format only : enables or disables archive header encryption (Default : off)

-t{Type}
    Type of archive (7z, zip, gzip, bzip2 or tar. 7z format is default)
    7z a -tzip me.zip me/

-m{Parameters}
    Set Compression Method

-p{Password}
    Set Password
    7z a -mhe=on -pcipher me.7z me/
    -- or input password 'cipher' from command-line
    7z a -mhe=on -p me.7z me/
```