### Python Programming

#### Debug

```bash
# python -m pdb <File-Name> <Class-Name>.<Function-Name>
python -m pdb SyncIQQuotaSupport.py Sync SyncIQQuotaTestCase.test_sync_quota
```

- print

use built-in functions such as `vars()` to print variables

```python
p vars()

# or
# p vars(Your-Object)
# use pp instead of p for that pp stands for pretty-print
pp vars(Your-Object)
pp vars(self)

```