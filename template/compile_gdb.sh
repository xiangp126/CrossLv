#!/bin/bash

# $ lsb_release -a
# No LSB modules are available.
# Distributor ID: Ubuntu
# Description:    Ubuntu 20.04.6 LTS
# Release:        20.04
# Codename:       focal

# Define the target GDB version
GDB_TARG_VERSION="12.1"

# Get the current GDB version and check if the passed argument is not -f
if [ -x "$(command -v gdb)" ] && [ "$1" != "-f" ]; then
    gdb_path=$(which gdb)
    current_version=$(gdb --version | grep -oE "[0-9]+\.[0-9]+")

    # Compare the versions
    if [[ "$(printf "%s\n" "$GDB_TARG_VERSION" "$current_version" | sort -V | tail -n 1)" == "$GDB_TARG_VERSION" ]]; then
        cat << _EOF_
GDB version $GDB_TARG_VERSION is already installed in $gdb_path
Current GDB version ($current_version) is greater than or equal to $GDB_TARG_VERSION
Use -f to force the installation
_EOF_
        exit
    else
        echo "Current GDB version ($current_version) is older than $GDB_TARG_VERSION"
    fi
fi

GDB_SOURCE_URL="https://ftp.gnu.org/gnu/gdb/gdb-$GDB_TARG_VERSION.tar.gz"

# Define installation directory
INSTALL_DIR="$HOME/.usr/"
DOWNLOAD_DIR="$HOME/Downloads"
PATCH_URL="https://github.com/mduft/tachyon3/raw/master/tools/patches/gdb-12.1-archswitch.patch"

# Ensure you have necessary build tools installed
sudo apt-get update
sudo apt-get install -y build-essential \
                        texinfo \
                        libisl-dev \
                        libgmp-dev \
                        libncurses-dev \
                        python3-dev

# Navigate to the download directory
cd "$DOWNLOAD_DIR"

# Download GDB source code
if [ ! -f "gdb-$GDB_TARG_VERSION.tar.gz" ]; then
    wget "$GDB_SOURCE_URL"
fi

if [ ! -d "gdb-$GDB_TARG_VERSION" ]; then
    tar -xzvf "gdb-$GDB_TARG_VERSION.tar.gz"
fi

# Download the patch
if [ ! -f "gdb-12.1-archswitch.patch" ]; then
    wget "$PATCH_URL" -O gdb-12.1-archswitch.patch
    cd "gdb-$GDB_TARG_VERSION"
    patch -p1 < ../gdb-12.1-archswitch.patch
fi

cd $DOWNLOAD_DIR/gdb-$GDB_TARG_VERSION
if [ "$1" == "-f" ]; then
    make distclean
fi

# Configure the build
# https://sourceware.org/gdb/wiki/BuildingNatively
python3_path=$(which python3)
./configure \
  --prefix="$INSTALL_DIR" \
  --disable-binutils \
  --disable-ld \
  --disable-gold \
  --disable-gas \
  --disable-gprof \
  --with-python=$python3_path \
  --enable-sim \
  --enable-gdb-stub \
  --enable-tui \
  --with-curses \
  --enable-x86-64 \
  CXXFLAGS='-g3 -O0' \
  CFLAGS='-g3 -O0 -DCURSES_LIBRARY'

# Compile and install GDB
if [ $? -ne 0 ]; then
    echo "Failed to configure GDB"
    exit 1
fi
# Make full use of all CPU cores
make -j$(nproc)

if [ $? -ne 0 ]; then
    echo "Failed to compile GDB"
    exit 1
fi
make install

# Clean up downloaded files and patch
# cd "$DOWNLOAD_DIR"
# rm -f "gdb-$GDB_TARG_VERSION.tar.gz"
# rm -f "gdb-12.1-archswitch.patch"

# Verify GDB installation
if [ $? -ne 0 ]; then
    echo "Failed to install GDB"
    exit 1
fi
echo "GDB $GDB_TARG_VERSION with the patch applied has been installed to $INSTALL_DIR"
cd $INSTALL_DIR/bin
./gdb --version
ldd gdb

# $ ldd `which gdb`
#         linux-vdso.so.1 (0x00007ffdbe5aa000)
#         libncursesw.so.6 => /lib/x86_64-linux-gnu/libncursesw.so.6 (0x00007f5911724000)
#         libtinfo.so.6 => /lib/x86_64-linux-gnu/libtinfo.so.6 (0x00007f59116f4000)
#         libdl.so.2 => /lib/x86_64-linux-gnu/libdl.so.2 (0x00007f59116ee000)
#         libpython3.8.so.1.0 => /lib/x86_64-linux-gnu/libpython3.8.so.1.0 (0x00007f5911198000)
#         libpthread.so.0 => /lib/x86_64-linux-gnu/libpthread.so.0 (0x00007f5911175000)
#         libm.so.6 => /lib/x86_64-linux-gnu/libm.so.6 (0x00007f5911026000)
#         libexpat.so.1 => /lib/x86_64-linux-gnu/libexpat.so.1 (0x00007f5910ff6000)
#         libgmp.so.10 => /lib/x86_64-linux-gnu/libgmp.so.10 (0x00007f5910f72000)
#         libstdc++.so.6 => /lib/x86_64-linux-gnu/libstdc++.so.6 (0x00007f5910d90000)
#         libgcc_s.so.1 => /lib/x86_64-linux-gnu/libgcc_s.so.1 (0x00007f5910d75000)
#         libc.so.6 => /lib/x86_64-linux-gnu/libc.so.6 (0x00007f5910b83000)
#         /lib64/ld-linux-x86-64.so.2 (0x00007f5912638000)
#         libz.so.1 => /lib/x86_64-linux-gnu/libz.so.1 (0x00007f5910b67000)
#         libutil.so.1 => /lib/x86_64-linux-gnu/libutil.so.1 (0x00007f5910b60000)
