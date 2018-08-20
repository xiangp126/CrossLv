## crontab

```bash
# For details see man 4 crontabs

# Example of job definition:
# .---------------- minute (0 - 59)
# |  .------------- hour (0 - 23)
# |  |  .---------- day of month (1 - 31)
# |  |  |  .------- month (1 - 12) OR jan,feb,mar,apr ...
# |  |  |  |  .---- day of week (0 - 6) (Sunday=0 or 7) OR sun,mon,tue,wed,thu,fri,sat
# |  |  |  |  |
# *  *  *  *  * user-name command to be executed
```

### From File
```bash
crontab [-u user] file
crontab crontab.txt
```

### Edit
```bash
crontab -e

crontab: installing new crontab
```


### List
```bash
crontab -l
```

### Delete
```bash
crontab -r
```
