#!/bin/bash

# $ lsb_release -a
# No LSB modules are available.
# Distributor ID: Ubuntu
# Description:    Ubuntu 20.04.6 LTS
# Release:        20.04
# Codename:       focal

# Define the GDB version and source URL
GDB_VERSION="12.1"

# Get the current GDB version and check if the passed argument is not -f
if [ -x "$(command -v gdb)" ] && [ "$1" != "-f" ]; then
    current_version=$(gdb --version | grep -oE "[0-9]+\.[0-9]+")

    # Compare the versions
    if [[ "$(printf "%s\n" "$GDB_VERSION" "$current_version" | sort -V | tail -n 1)" == "$GDB_VERSION" ]]; then
        echo "Current GDB version ($current_version) is greater than or equal to $GDB_VERSION"
        exit
    else
        echo "Current GDB version ($current_version) is older than $GDB_VERSION"
    fi
fi

GDB_SOURCE_URL="https://ftp.gnu.org/gnu/gdb/gdb-$GDB_VERSION.tar.gz"

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
                        libncurses-dev

# Navigate to the download directory
cd "$DOWNLOAD_DIR"

# Download GDB source code
if [ ! -f "gdb-$GDB_VERSION.tar.gz" ]; then
    wget "$GDB_SOURCE_URL"
fi

if [ ! -d "gdb-$GDB_VERSION" ]; then
    tar -xzvf "gdb-$GDB_VERSION.tar.gz"
fi

# Download the patch
if [ ! -f "gdb-12.1-archswitch.patch" ]; then
    wget "$PATCH_URL" -O gdb-12.1-archswitch.patch
    cd "gdb-$GDB_VERSION"
    patch -p1 < ../gdb-12.1-archswitch.patch
fi

cd $DOWNLOAD_DIR/gdb-$GDB_VERSION
if [ "$1" == "-f" ]; then
    make distclean
fi

# Configure the build
# https://sourceware.org/gdb/wiki/BuildingNatively
./configure \
  --prefix="$INSTALL_DIR" \
  --disable-binutils \
  --disable-ld \
  --disable-gold \
  --disable-gas \
  --disable-gprof \
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
make -j$(nproc)

if [ $? -ne 0 ]; then
    echo "Failed to compile GDB"
    exit 1
fi
make install

# Clean up downloaded files and patch
# cd "$DOWNLOAD_DIR"
# rm -f "gdb-$GDB_VERSION.tar.gz"
# rm -f "gdb-12.1-archswitch.patch"

# Verify GDB installation
if [ $? -ne 0 ]; then
    echo "Failed to install GDB"
    exit 1
fi
echo "GDB $GDB_VERSION with the patch applied has been installed to $INSTALL_DIR"
cd $INSTALL_DIR/bin
./gdb --version
ldd gdb

# $ ldd gdb
#         linux-vdso.so.1 (0x00007fff84d69000)
#         libncursesw.so.6 => /lib/x86_64-linux-gnu/libncursesw.so.6 (0x00007f25f91be000)
#         libtinfo.so.6 => /lib/x86_64-linux-gnu/libtinfo.so.6 (0x00007f25f918e000)
#         libdl.so.2 => /lib/x86_64-linux-gnu/libdl.so.2 (0x00007f25f9188000)
#         libexpat.so.1 => /lib/x86_64-linux-gnu/libexpat.so.1 (0x00007f25f915a000)
#         libgmp.so.10 => /lib/x86_64-linux-gnu/libgmp.so.10 (0x00007f25f90d6000)
#         libstdc++.so.6 => /lib/x86_64-linux-gnu/libstdc++.so.6 (0x00007f25f8ef4000)
#         libm.so.6 => /lib/x86_64-linux-gnu/libm.so.6 (0x00007f25f8da3000)
#         libgcc_s.so.1 => /lib/x86_64-linux-gnu/libgcc_s.so.1 (0x00007f25f8d88000)
#         libpthread.so.0 => /lib/x86_64-linux-gnu/libpthread.so.0 (0x00007f25f8d65000)
#         libc.so.6 => /lib/x86_64-linux-gnu/libc.so.6 (0x00007f25f8b73000)
#         /lib64/ld-linux-x86-64.so.2 (0x00007f25fa03c000)
