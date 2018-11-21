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

### System Cron
```bash
# ls cron*
cron.deny  crontab

cron.d:
0hourly  hubble-agent.cron  ntpdate.cron  pcp-pmie  pcp-pmlogger  raid-check  sa-update  sysstat

cron.daily:
0yum-daily.cron  logrotate  man-db.cron  mlocate

cron.hourly:
0anacron  0yum-hourly.cron

cron.monthly:
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
# list for current user
crontab -l

crontab -l root -l
# list crontab job for user 'cloud-agent'
crontab -l cloud-agent -l
```

### Delete
```bash
crontab -r
```