## sed
```
sed [-hnV][-e<script>][-f<script_file>] Text
```

recomment you **commit** before using sed with `-i`

`sed` **handle one line each time**

### Content List
- [Intro](#intro)
- [original example content](#oricontent)
- [searching syntax](#searching)
- [add](#add)
- [insert](#insert)
- [delete](#delete)
- [substitute with line](#substitutec)
- [substitute with searched string](#substitutes)
- [print with search](#print)

<a id=intro></a>
### Intro
Command | Meaning
--- | ---
a | **add**, to next line of current line
i | insert, to previous line of current line
c | substitute, with line
s | **substitute**, with matched string
d | **delete**
p | print

### Example
<a id=oricontent></a>
#### cat
```bash
cat test.txt
```
output:

```
HELLO LINUX!
Linux is a free unix-type operating system.
This is a linux testfile!
Linux test
```

<a id=searching></a>
### searching
`sed` equipped with basic **searching**

**syntax:**

```
sed '/searched_word/command' test.txt
```

of which, `command` can be `d`, `p`, etc

<a id=add></a>
#### add
add new content after `4th` line

```ruby
nl test.txt | sed '4a This is new line.'
```
output:

```
     1	HELLO LINUX!
     2	Linux is a free unix-type operating system.
     3	This is a linux testfile!
     4	Linux test
This is new line.
```

<a id=insert></a>
#### insert - same as add
insert new content before `2th` line

```bash
nl test.txt | sed '2i This is new line.'
```

output:

```
     1	HELLO LINUX!
This is new line.
     2	Linux is a free unix-type operating system.
     3	This is a linux testfile!
     4	Linux test
```


<a id=delete></a>
#### delete
delete `2th` and `3th` line

```bash
nl test.txt | sed '2,3 d'
```
output:

```
     1	HELLO LINUX!
     4	Linux test
```

delete `3th` till last line

```bash
nl test.txt | sed '3,$ d'
```

output:

```
     1	HELLO LINUX!
     2	Linux is a free unix-type operating system.
```

<a id=substitutec></a>
#### substitute with line
```bash
nl test.txt | sed '2,3c This is new line.'
```
output:

```
     1	HELLO LINUX!
This is new line.
     4	Linux test
```

<a id=print></a>
#### print
```bash
sed -n '/linux/p' test.txt
```
output:

```
This is a linux testfile!
```

<a id=substitutes></a>
#### substitute with searched string
only replace the **second one** matched in **one line** using `/2`<br>
`s/x1/x2/` was same as `s/x1/x2/1`

```bash
sed 's/ss.go/hh.jump/2' test.txt
```

replace all that matched using `/g`

```bash
sed 's/ss.go/hh.jump/g' test.txt
```

### Key Parameters
- -E, -r, --regexp-extended (did not need \ for special symbol)

```bash
use extended regular expressions in the script (for portability use POSIX -E).
```

removing trailing spaces

```bash
sed --regexp-extended --in-place 's/\s+$//g' test.txt
```