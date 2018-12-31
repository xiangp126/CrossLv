## makefile
### Template
```makefile
MAKE	= make
CC 		= gcc
LD 		= ld

SUBDIRS = src tools

INSDIR  = $(PWD)/bin
export INSDIR

export KERNEL   = $(shell /bin/uname -r)

all:
	for i in $(SUBDIRS); do $(MAKE) -C $$i || exit 1; done

clean:
	for i in $(SUBDIRS); do $(MAKE) -C $$i clean || exit 1; done

install:all
	-mkdir -p $(INSDIR)
	for i in $(SUBDIRS); do $(MAKE) -C $$i install || exit 1; done
```

### Notable GCC Variables
```
  CC          C compiler command
  CFLAGS      C compiler flags
  LDFLAGS     linker flags, e.g. -L<lib dir> if you have libraries in a
              nonstandard directory <lib dir>
  LIBS        libraries to pass to the linker, e.g. -l<library>
  CPPFLAGS    (Objective) C/C++ preprocessor flags, e.g. -I<include dir> if
              you have headers in a nonstandard directory <include dir>
  CPP         C preprocessor
  CXX         C++ compiler command
  CXXFLAGS    C++ compiler flags
```

### make
we can manual specify gcc/c++ using env variables

```bash
export CC=/usr/local/bin/gcc
export CXX=/usr/local/bin/c++
make -j
```
or

```makefile
make CC=/usr/local/bin/gcc CXX=/usr/local/bin/c++ -j
```

> make V=s

```
make V=?
V=99: This option controls the degree and type of verbosity that you will be exposed to during the make process. This is not specific to make itself but rather to the OpenWrt makefile. In the source see the file include/verbose.mk where the following links are made:
- Verbose = V
- Verbosity level 1 = w (warnings/errors only)
- Verbosity level 99 = s (This gives stdout+stderr)
makelevel
https://unix.stackexchange.com/questions/139459/what-does-makenumber-mean-in-make-v-s
https://askubuntu.com/questions/833770/what-does-make-j-n-v-m-mean
```

> make -j

```
make -j [N]
make -j
-j [N], --jobs[=N]          Allow N jobs at once; infinite jobs with no arg.

[Example]
make -j 8
```

---
### Special Symbols
- `$@`  target
- `$<`  the first depends
- `$^`  all depends

#### variable = value
```ruby
Lazy Set
VARIABLE = value
Normal setting of a variable - values within it are recursively expanded when the variable is used, not when it's declared
```

#### variable := value
```ruby
Immediate Set
VARIABLE := value
Setting of a variable with simple expansion of the values inside - values within it are expanded at declaration time.
```

#### variable ?= value
```ruby
Set If Absent
VARIABLE ?= value
Setting of a variable only if it doesn't have a value
```

#### variable += value
```ruby
Append
VARIABLE += value
Appending the supplied value to the existing value (or setting to that value if the variable didn't exist)
```