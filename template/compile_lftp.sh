#!/bin/bash

# check hostname, if not client1, exit
HOSTNAME=$(hostname)
if [ "$HOSTNAME" != "client1" ]; then
    echo "This script is only for client1"
    exit 1
fi

#!/bin/bash

# Define installation directory
INSTALL_DIR="$HOME/.usr/"
DOWNLOAD_DIR="$HOME/Downloads"
LFTP_VERSION="4.9.2"
LFTP_SOURCE_URL="https://lftp.yar.ru/ftp/lftp-$LFTP_VERSION.tar.xz"

# Ensure you have necessary build tools installed
sudo apt-get update
sudo apt-get install -y build-essential \
                        libreadline-dev \
                        zlib1g-dev

# Navigate to the download directory
cd "$DOWNLOAD_DIR"

# Download lftp source code
if [ ! -f "lftp-$LFTP_VERSION.tar.xz" ]; then
    wget "$LFTP_SOURCE_URL"
fi

# Extract the source code
tar -xvf "lftp-$LFTP_VERSION.tar.xz"

# Navigate to the lftp source directory
cd "lftp-$LFTP_VERSION"

# Configure, compile, and install lftp
./configure --prefix="$INSTALL_DIR" --enable-debug
make
sudo make install

echo "lftp $LFTP_VERSION has been successfully compiled and installed to $INSTALL_DIR"
