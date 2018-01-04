#!/usr/bin/env python3
import os, sys, binascii
from datetime import datetime

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
            byte = fRd.read(2)
            byte = fRd.read(2)
            if byte != b"":
                val = int.from_bytes(byte, byteorder = "big")
                objType = (val >> 12) & 0b1111
                unixPerm = val & 0b0000000111111111
    
                checkObjType(objType)
                print("Unix Permission: %d" %unixPerm)
    
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
                validFlag = val & 0b1000000000000000
                extendedFlag = val & 0b0100000000000000
                stage = val & 0b0011000000000000
                length = val & 0b0000111111111111
                print("Valid Flag: %d" %validFlag)
                print("Extended Flag: %d" %extendedFlag)
                print("Stage : %d" %stage)
                print("Length: %d" %length)
    
            ''' file name (variable), ended with 0x0000. '''
            byte = fRd.read(length)
            if byte != b'':
                print("File Name: %s" %byte.decode('ascii'))
    
            ''' 1-8 nul bytes as necessary to pad the entry to a multiple
                of eight bytes while keeping the name NUL-terminated. '''
            while 1:
                byte = fRd.read(1)
                val = int.from_bytes(byte, byteorder = "big")
                if val == 0:
                    continue
                else:
                    break
    
            ''' back one byte from current position. '''
            fRd.seek(-1, 1)
            if loop == fileCount - 1:
                stepInto = 0
                try:
                    ''' - Extensions
                         4-byte extension signature. If the first byte is 'A'..
                         'Z' the extension is optional and can be ignored. 
                    '''
                    byte = fRd.read(4)
                    stepInto += 4
                    if byte != b'':
                        str(byte, 'utf-8')
                        print("Ext Sign: %s" %byte.decode('ascii'))
    
                    ''' 32-bit size of the extension. '''
                    byte = fRd.read(4)
                    stepInto += 4
                    if byte != b"":
                        extSize = int.from_bytes(byte, byteorder = "big")
                        print("Ext Size: %d" %extSize)
    
                    ''' Ext Data. End of Extension. '''
                    byte = fRd.read(extSize)
                    stepInto += extSize
                    if byte != b'':
                        # val = int.from_bytes(byte, byteorder = "big")
                        # print("Ext Data: %x" %val)
                        print("SHA-1: {}".format(binascii.hexlify(byte).decode('utf-8')))
                except ValueError:
                    fRd.seek(-stepInto, 1)
                    
            ''' 160 - bit CheckSum, Common Section. '''
            byte = fRd.read(20)
            if byte != b'':
                val = int.from_bytes(byte, byteorder = "big")
                print("CheckSum: %x" %val)

        printAppendix()
        print("End of Parse ", end = "")
        printAppendix()
        print()

        fRd.close()

def checkObjType(type):
    print("File Type:", end = ' ')
    if type == 8:
        print("Regular File")
    elif type == 10:
        print("Symbolic Link")
    elif type == 14:
        print("Gitlink")
    else:
        print("Unknown Type")

def printAppendix():
    print("--------------------", end = ' ')

if __name__ == "__main__":
    indexPath = "./.git/index"
    if os.path.exists(indexPath):
        parseIndex(indexPath)
    else:
        print("Usage: ./parse_index.py index_file")
        exit(1)
