## Python Programming

- [Python Tips](https://book.pythontips.com/en/latest/index.html)
- [How to debug](#debug)
- [Basic handling](#basichandling)
    - [Associate with print](#print)
- [Grammar Syntax](#grammar)
    - [Ternary Operators](#ternary)
    - [str.format()](#format)

<a id=debug></a>
### How to debug
```bash
# python -m pdb <File-Name> <Class-Name>.<Function-Name>
python -m pdb SyncIQQuotaSupport.py Sync SyncIQQuotaTestCase.test_sync_quota
```

<a id=basichandling></a>
### Python Basic Handling

<a id=print></a>
#### print
- locals()

```bash
>>> locals()
{'__name__': '__main__', '__doc__': None, '__package__': None, '__loader__': <class '_frozen_importlib.BuiltinImporter'>, '__spec__': None, '__annotations__': {}, '__builtins__': <module 'builtins' (built-in)>}
```

- vars()

```bash
Help on built-in function vars in module builtins:

vars(...)
    vars([object]) -> dictionary

    Without arguments, equivalent to locals().
    With an argument, equivalent to object.__dict__.
    
>>> vars()
{'__name__': '__main__', '__doc__': None, '__package__': None, '__loader__': <class '_frozen_importlib.BuiltinImporter'>, '__spec__': None, '__annotations__': {}, '__builtins__': <module 'builtins' (built-in)>}
```

- print() and pprint()

use built-in functions such as `vars()` to print variables.

```python
print(vars())

# or
# pprint vars(Your-Object)
# use pp instead of p for that pp stands for pretty-print

>>> import pprint

pprint(vars(Your-Object))
pprint(vars(self))

```

<a id=grammar></a>
### Grammar Syntax

<a id=ternary></a>
#### [Ternary Operators](https://book.pythontips.com/en/latest/ternary_operators.html#ternary-operators)

```bash
value_if_true if condition else value_if_false
# Example
is_nice = True
state = "nice" if is_nice else "not nice"
```

<a id=format></a>
#### str.format()

https://www.pythonf.cn/read/51807

```bash
# load help page
>>> help('FORMATTING')
********************

The "str.format()" method and the "Formatter" class share the same
syntax for format strings (although in the case of "Formatter",
subclasses can define their own format string syntax).  The syntax is
related to that of formatted string literals, but there are
differences.
...

# Example
"{0} love {1}".format("I","You")
```