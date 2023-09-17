#!/usr/bin/env python3
import os, sys, binascii, math
from datetime import datetime

# https://github.com/git/git/blob/master/Documentation/technical/index-format.txt
def parseIndex(myfile):
    ''' Parse Index File.
          | 0           | 4            | 8           | C              |
          |-------------|--------------|-------------|----------------|
        0 | DIRC        | Version      | File count  | Ctime          | 0
          | Nano-Sec    | Mtime        | Nano-Sec    | Device         |
        2 | Inode       | Mode         | UID         | GID            | 2
          | File size   | Entry SHA-1    ...           ...            |
        4 | ...           ...          | Flags  | File Name(variant)  | 4
          | Index SHA-1   ...           ...            ...            |
        6 | ...                                                       |

   --->>
        2 | Mode - 32 bit     |      4 | Flags - 16 bit
          |-------------------|        |-------------------------|
          | 16-bit unknown    |        | 1-bit assume-valid flag |
          | 4-bit object type |        | 1-bit extended flag     |
          | 3-bit unused      |        | 2-bit stage             |
          | 9-bit unix perm   |        | 12-bit name length      |

    '''
    with open(myfile, "rb") as fRd:
        ''' 32-bit signature:
            The signature is { 'D', 'I', 'R', 'C' } (stands for "dircache")
        '''
        printAppendix()
        print("Index File ", end = "")
        printAppendix()
        print()
        byte = fRd.read(4)
        if byte != b"":
            str(byte, 'utf-8')
            print("Head: %s" %byte.decode('ascii'))

        ''' 32-bit version number:
            The current supported versions are 2, 3 and 4. '''
        byte = fRd.read(4)
        if byte != b"":
            val = int.from_bytes(byte, byteorder = "big")
            print("Version: %d" %val)

        ''' 32-bit file count
            32-bit number of index entries.  '''
        byte = fRd.read(4)
        if byte != b"":
            fileCount = int.from_bytes(byte, byteorder = "big")
            print("File Count: %d" %fileCount)

        ''' A number of sorted index entries
            32-bit ctime seconds, the last time a file's metadata changed
            this is stat(2) data.
        '''
        byte = fRd.read(4)
        if byte != b"":
            val = int.from_bytes(byte, byteorder = "big")
            print("Ctime:", end = ' ')
            print(datetime.fromtimestamp(int(val)).strftime('%Y-%m-%d %H:%M:%S'))
        ''' 32-bit nano seconds of ctime. '''
        byte = fRd.read(4)
        if byte != b"":
            val = int.from_bytes(byte, byteorder = "big")
            #print("nano seconds: %d" %val)

        ''' 32-bit mtime seconds, the last time a file's metadata changed
            this is stat(2) data.
        '''
        byte = fRd.read(4)
        if byte != b"":
            val = int.from_bytes(byte, byteorder = "big")
            print("Mtime:", end = ' ')
            print(datetime.fromtimestamp(int(val)).strftime('%Y-%m-%d %H:%M:%S'))
        ''' 32-bit nano seconds of mtime. '''
        byte = fRd.read(4)
        if byte != b"":
            val = int.from_bytes(byte, byteorder = "big")
            #print("nano seconds: %d" %val)

        ''' 32-bit dev
            this is stat(2) data. '''
        byte = fRd.read(4)
        if byte != b"":
            val = int.from_bytes(byte, byteorder = "big")
            print("Device: %d" %val)

        ''' 32-bit inode
            this is stat(2) data. '''
        for loop in range(0, fileCount):
            # beauty decorated
            printAppendix()
            print("File No. %d" %(loop + 1), end = ' ')
            printAppendix()
            print()

            byte = fRd.read(4)
            if byte != b"":
                val = int.from_bytes(byte, byteorder = "big")
                print("Inode : %d" %val)

            ''' 32-bit mode this is stat(2) data.
                Included 4-bit object type
                valid values in binary are 1000 (regular file), 1010 (symbolic link)
                and 1110 (gitlink). '''
            byte = fRd.read(2)              # 16-bit high, zero
            byte = fRd.read(2)              # 16-bit low, 4 + 3 + 9
            if byte != b"":
                val = int.from_bytes(byte, byteorder = "big")
                checkModeField(val)

            ''' 32-bit uid
                this is stat(2) data. '''
            byte = fRd.read(4)
            if byte != b"":
                val = int.from_bytes(byte, byteorder = "big")
                print("UID: %d" %val)

            ''' 32-bit gid
                this is stat(2) data. '''
            byte = fRd.read(4)
            if byte != b"":
                val = int.from_bytes(byte, byteorder = "big")
                print("GID: %d" %val)

            ''' 32-bit file size
                This is the on-disk size from stat(2), truncated to 32-bit. '''
            byte = fRd.read(4)
            if byte != b"":
                val = int.from_bytes(byte, byteorder = "big")
                print("File Size: %d [Char]" %val)

            ''' 160-bit SHA-1 for the represented object. '''
            byte = fRd.read(20)
            if byte != b"":
                # val = int.from_bytes(byte, byteorder = "big")
                # print("SHA-1: %x" %val)
                print("SHA-1: {}".format(binascii.hexlify(byte).decode('utf-8')))

            ''' A 16-bit 'flags' field split into (high to low bits).
            '''
            byte = fRd.read(2)
            if byte != b"":
                val = int.from_bytes(byte, byteorder = 'big')
                validFlag    = val & 0b1000000000000000
                extendedFlag = val & 0b0100000000000000
                stage        = val & 0b0011000000000000
                fileNameLen  = val & 0b0000111111111111
                print("Valid Flag: %d" %validFlag)
                print("Extended Flag: %d" %extendedFlag)
                print("Stage : %d" %stage)
                print("File Name Length: %d" %fileNameLen)

            ''' file name (variable), ended with 0x0000. '''
            byte = fRd.read(fileNameLen)
            if byte != b'':
                print("File Name: %s" %byte.decode('ascii'))

            ''' 1-8 nul bytes as necessary to pad the entry to a multiple
                of eight bytes while keeping the name NUL-terminated. '''
            ''' only entry, header(DIRC + Ver + File-Count) not included. '''
            entryDataLen = 10 * 4 + 20 + 2
            entryPlusFileLen = entryDataLen + fileNameLen
            # calculate how many b'\x00' be appended after file name.
            trueLen = (math.floor(entryPlusFileLen / 8) + 1) * 8
            paddedLen = trueLen - entryPlusFileLen

            ''' skip null-padding for file name '''
            byte = fRd.read(paddedLen)

            if loop == fileCount - 1:
                ''' - Extensions
                     4-byte extension signature. If the first byte is 'A'..
                     'Z' the extension is optional and can be ignored.
                '''
                byte = fRd.read(4)
                if byte != b'':
                    extSign = byte.decode('ascii')

                # parse different extersion signature
                if extSign == 'TREE':
                    # print message here to be compatible with mygit
                    print("-------------------- Extensions  --------------------")
                    print("Extension Signature: %s" %extSign)
                    ''' 32-bit size of the extension. '''
                    byte = fRd.read(4)
                    if byte != b"":
                        extSize = int.from_bytes(byte, byteorder = "big")
                        print("Extension Size: %d" %extSize)

                    ''' Ext Data. End of Extension. '''
                    ''' NUL-terminated path component (relative to its
                                            parent directory) '''
                    # byte = fRd.read(1)

                    # skip reading extension data
                    byte = fRd.read(extSize)
                    if byte != b'':
                        # print("SHA-1: {}".format(binascii.hexlify(byte).decode('utf-8')))
                        pass
                elif extSign == 'REUC':
                    pass
                else:
                    print("-----------------------------------------------------")
                    fRd.seek(-4, 1)

                ''' 160-bit SHA-1 over the content of the index file
                                            before this checksum  '''
                byte = fRd.read(20)
                if byte != b'':
                    val = int.from_bytes(byte, byteorder = "big")
                    print("CheckSum: %x" %val)

            else:
                 # skip 20 bytes, originally know as checksum
                 byte = fRd.read(20)
                 if byte != b'':
                     val = int.from_bytes(byte, byteorder = "big")
                     # print("Partial CheckSum: %x" %val)

        printAppendix()
        print("End of Parse ", end = "")
        printAppendix()
        print()

        fRd.close()

def checkModeField(val):
    objType = (val >> 12) & 0b1111
    unixPerm = val & 0b0000000111111111

    print("File Type:", end = ' ')
    if objType == 8:
        print("Regular File")
        # print("Unix Permission: %d" %unixPerm)
        print("Unix Permission: 0644 (%d)" %unixPerm)
    elif objType == 10:
        print("Symbolic Link")
        print("Unix Permission: 0")
    elif objType == 14:
        print("Gitlink")
        print("Unix Permission: 0")
    else:
        print("Unknown Type")
        print("Unix Permission: Unknown")

def printAppendix():
    print("--------------------", end = ' ')

if __name__ == "__main__":
    if len(sys.argv) < 2:
        indexPath = "./.git/index"
    elif len(sys.argv) == 2:
        indexPath = sys.argv[1]
    else:
        pass
    # tackle parse routine
    if os.path.exists(indexPath):
        parseIndex(indexPath)
    else:
        print("Usage: ./parse_index.py [index_file]")
        exit(1)
