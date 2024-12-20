#!/bin/bash

# $ lsb_release -a
# No LSB modules are available.
# Distributor ID: Ubuntu
# Description:    Ubuntu 20.04.6 LTS
# Release:        20.04
# Codename:       focal

# Define the target GDB version
GDB_TARG_VERSION="15.2"
GDB_SOURCE_URL="https://ftp.gnu.org/gnu/gdb/gdb-$GDB_TARG_VERSION.tar.gz"

# Define installation directory
INSTALL_DIR="$HOME/.usr/"
DOWNLOAD_DIR="$HOME/Downloads"
PATCH_NAME="gdb-12.1-archswitch.patch"
PATCH_URL="https://github.com/mduft/tachyon3/raw/master/tools/patches/$PATCH_NAME"
MAGENTA='\033[0;35m'
RESET='\033[0m'
USER_NOTATION="@@@@"

usage() {
    cat << _EOF_

Install GDB $GDB_TARG_VERSION with the patch applied into $INSTALL_DIR

Usage: $(basename $0) [-f] [-h]
    -f: Force the installation
    -h: Display this help message

_EOF_
    exit 0
}

# use getopt to process the arguments -f and -h
while getopts "fh" opt; do
    case $opt in
        f)
            echo "$USER_NOTATION Forcing the installation"
            ;;
        h)
            usage
            ;;
        ?)
            echo "$USER_NOTATION Invalid option: -$OPTARG" >&2
            exit 1
            ;;
    esac
done

# Get the current GDB version and check if the passed argument is not -f
echo -e "${MAGENTA}Checking the current GDB version${RESET}"
if [ -x "$(command -v gdb)" ] && [ "$1" != "-f" ]; then
    gdb_path=$(which gdb)
    if [ $? -ne 0 ]; then
        echo "$USER_NOTATION Failed to get the path to the current GDB"
        exit 1
    fi
    # current_version=$(gdb --version | grep -oE "[0-9]+\.[0-9]+")
    current_version=$(gdb --version | head -n 1 | awk '{print $NF}')

    # Compare the versions
    # use bc to compare the versions
    if [ $(echo "$current_version >= $GDB_TARG_VERSION" | bc -l) -eq 1 ]; then
        cat << _EOF_
GDB version $current_version is already installed in $gdb_path
Current GDB version ($current_version) is greater than or equal to $GDB_TARG_VERSION
Use -f to force the installation
_EOF_
        exit
    else
        cat << _EOF_
Current GDB version ($current_version) is older than $GDB_TARG_VERSION
Start installing GDB $GDB_TARG_VERSION
_EOF_
    fi
fi

echo -e "${MAGENTA}Installing necessary build tools${RESET}"
# Ensure you have necessary build tools installed
sudo apt-get update
sudo apt-get install -y build-essential \
                        texinfo \
                        libisl-dev \
                        libgmp-dev \
                        libncurses-dev \
                        python3-dev \
                        source-highlight \
                        libsource-highlight-dev \
                        libmpfr-dev

# Navigate to the download directory
cd "$DOWNLOAD_DIR" || exit

if [ ! -f "gdb-$GDB_TARG_VERSION.tar.gz" ]; then
    echo -e "${MAGENTA}Downloading GDB source code${RESET}"
    wget "$GDB_SOURCE_URL"
fi

if [ ! -d "gdb-$GDB_TARG_VERSION" ]; then
    echo -e "${MAGENTA}Extracting GDB source code${RESET}"
    tar -xzvf "gdb-$GDB_TARG_VERSION.tar.gz"
fi

cd "$DOWNLOAD_DIR"/gdb-$GDB_TARG_VERSION || exit
if [ ! -f "$PATCH_NAME" ]; then
    echo -e "${MAGENTA}Downloading the patch${RESET}"
    wget "$PATCH_URL" -O "$PATCH_NAME"
    if [ $? -ne 0 ]; then
        echo -e "${USER_NOTATION} Failed to download the patch"
        exit 1
    fi

    echo -e "${MAGENTA}Applying the patch${RESET}"
    set -x
    patch -p1 < $PATCH_NAME
    set +x
    if [ $? -ne 0 ]; then
        echo -e "${USER_NOTATION} Failed to apply the patch"
        exit 1
    fi
fi

if [ "$1" == "-f" ]; then
    echo -e "${MAGENTA}Cleaning up the build directory${RESET}"
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
  --with-python="$python3_path" \
  --enable-source-highlight \
  --enable-sim \
  --enable-gdb-stub \
  --enable-tui \
  --with-curses \
  --enable-x86-64 \
  CXXFLAGS='-g3 -O0' \
  CFLAGS='-g3 -O0 -DCURSES_LIBRARY'

# Compile and install GDB
if [ $? -ne 0 ]; then
    echo -e "${USER_NOTATION} Failed to configure GDB"
    exit 1
fi

# Make full use of all CPU cores
echo -e "${MAGENTA}Compiling GDB${RESET}"
make -j$(nproc)

if [ $? -ne 0 ]; then
    echo -e "${USER_NOTATION} Failed to compile GDB"
    exit 1
fi

echo -e "${MAGENTA}Installing GDB${RESET}"
make install

# Clean up downloaded files and patch
# cd "$DOWNLOAD_DIR"
# rm -f "gdb-$GDB_TARG_VERSION.tar.gz"
# rm -f "gdb-12.1-archswitch.patch"

# Verify GDB installation
if [ $? -ne 0 ]; then
    echo -e "${USER_NOTATION} Failed to install GDB"
    exit 1
fi

echo "$USER_NOTATION ${MAGENTA}GDB $GDB_TARG_VERSION with the patch applied has been installed to $INSTALL_DIR${RESET}"

cd "$INSTALL_DIR"/bin || exit
./gdb --version
./gdb -configuration
ldd gdb
