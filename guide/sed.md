## sed
### Ordinary use
```bash
# must commit before used 'sed'

sed -i 's/Old/New/g' *.txt
```

### Removing trailing whitespace
```bash
-E, -r, --regexp-extended (did not need \ for special symbol)
use extended regular expressions in the script (for portability use POSIX -E).
```
> sample

```bash
sed --regexp-extended --in-place 's/\s+$//g' server.h
sed --regexp-extended --in-place 's/\s+$//g'

---- Only replace the second one matched
sed 's/ss.go/hh.jump/2' sample.txt
```