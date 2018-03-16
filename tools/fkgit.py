#!/usr/bin/env python3
import sys, os, zlib, struct, math, argparse, time, operator
import getopt, hashlib, collections, binascii, stat, difflib

# ./.fkgit, same as ./.git
baseName = '.git'

# Data for one entry in the git index (.git/index)
''' Parse Index File.
      | 0           | 4            | 8           | C              |
      |-------------|--------------|-------------|----------------|
    0 | DIRC        | Version      | File count  | Ctime          | 0
      | Nano-Sec    | Mtime        | Nano-Sec    | Device         |
    2 | Inode       | Mode         | UID         | GID            | 2
      | File size   | Entry SHA-1    ...           ...            |
    4 | ...           ...          | Flags  | File Name(\0x00)    | 4
      | Ext-Sig     | Ext-Size     | Ext-Data (Ext was optional)  |
    6 | Checksum      ...            ...           ...            | 6

-->>
    2 | Mode - 32 bit     |      4 | Flags - 16 bit
      |-------------------|        |-------------------------|
      | 16-bit unknown    |        | 1-bit assume-valid flag |
      | 4-bit object type |        | 1-bit extended flag     |
      | 3-bit unused      |        | 2-bit stage             |
      | 9-bit unix perm   |        | 12-bit name length      |
'''
# IndexEntry = <class '__main__.IndexEntryType'>
IndexEntry = collections.namedtuple('IndexEntryType', [
    'ctime_s', 'ctime_n', 'mtime_s', 'mtime_n', 'dev', 'ino', 'mode', 'uid',
    'gid', 'size', 'sha1', 'flags', 'path'])

def lsFiles(verbose = False):
    ''' Show staged contents' object name in the output. '''
    for entry in readIndex():
        ''' IndexEntryType(ctime_s=1505698291, ctime_n=0, mtime_s=1505698291,
            mtime_n=0, dev=64512, ino=194773692, mode=33277, uid=1000,
            gid=1000, size=8920,
 sha1=b'\xd6\x8e\x19\x16S\xc2\xd2\x98\xe0\xdd\xfcW\xda\xeb=\xbdO\xa7\x8e\xf0',
            flags=14, path='indexcat.py')
        '''
        if verbose:
            sIndex = 0
            # > echo "obase = 8; ibase = 10; 33204" | bc      ==> 100664
            print('{:06o} {} {}\t{}'.format(entry.mode,
                binascii.hexlify(entry.sha1).decode('utf-8'),
                sIndex, entry.path))
        else:
            print(entry.path)

def diff():
    ''' Show diff between index and working tree. '''
    ''' entries_by_path = {e.path: e for e in read_index()} =
        {'indexcat.py': IndexEntry(..., ..., path='indexcat.py'),
        'main.cpp': IndexEntry(..., ..., path='main.cpp')}
    '''
    # type(entries_by_path) = <class 'dict'>, convert to Key -> Value.
    entriesByPath = {entry.path: entry for entry in readIndex()}
    ''' for path in enumerate(changed):
            ...  print(path)
                 ...
                 (0, 'demo.py')
                 (1, 'fkgit.py')
    '''
    changed, _, _ = getStatus()
    for _, path in enumerate(changed):
        sha1 = binascii.hexlify(entriesByPath[path].sha1).decode('utf-8')
        objType, data = readObject(sha1)
        assert objType == 'blob', "Only Support blob type."
        indexLines = data.decode('utf-8').splitlines()
        workingLines = readFile(path).decode('utf-8').splitlines()

        ''' unified_diff(a, b, fromfile='', tofile='', fromfiledate='',
            tofiledate='', n=3, lineterm='\n')
            Compare two sequences of lines;
            generate the delta as a unified diff.
        '''
        # For inputs that do not have trailing newlines, set the lineterm
        # argument to "" so that the output will be uniformly newline free
        diffLines = difflib.unified_diff(
                    indexLines, workingLines,
                    'a/{} (index)'.format(path),
                    'b/{} (working tree)'.format(path),
                    lineterm = '')

        for line in diffLines:
            print(line)

def findObject(hashCode):
    """ Find object with given SHA-1 prefix and return path to object. Or
        exit if there are no one or more than one object with this prefix.
    """
    if len(hashCode) < 7:
        errMsg("Hash Prefix Must Longer than 7 Characters.")
    objDir = os.path.join(baseName, 'objects', hashCode[:2])
    restHashCode = hashCode[2:]
    try:
        objs = [name for name in os.listdir(objDir)
                                    if name.startswith(restHashCode)]
    except FileNotFoundError:
        errMsg("File Not Found.")

    if not objs:
        # "Object '0fe2738082e4f75c9c6bf154af70c12d9b55af' Not Found."
        print("Object {!r} Not Found.".format(hashCode))
        sys.exit(1)
    if len(objs) > 2:
        print("There Are [{}] Objects with HashCode {!r}.".format( len(objs), hashCode))
    # .git/objects/48/0fe2738082e4f75c9c6bf154af70c12d9b55af
    return os.path.join(objDir, objs[0])

def readObject(hashCode, printRaw = False):
    ''' Read object with given SHA1 hashcode.
        Return: tuple of (type, data), or ValueError if not found.
    '''
    path = findObject(hashCode)
    # Notice, the object file was Zlib compressed.
    ''' fullData =  b'tree 114\x00100664 main.cpp\x00\xd8\xc1\xa2&i{:\x12\xf9%
        \x85\x03\x13\xe3{\x91\xe6"\xe4\xce100775 indexcat.py\x00\xd6\x8e
        \x19\x16S\xc2\xd2\x98\xe0\xdd\xfcW\xda\xeb=\xbdO\xa7\x8e\xf0100775
        fkgit.py\x001\x03\x99\xe2Uh\xed4\x0f[\xba\xc6\x0f\xa3GU\xeb\x12\x85i'
    '''
    fullData = zlib.decompress(readFile(path))
    if printRaw:
        print(fullData)

    # find the first occurance of b'\x00', take index as 8
    try:
        nullIndex = fullData.index(b'\x00')
    except ValueError:
        errMsg("Wrong Object File. Exit Now.")

    # [ ), right not included.
    header = fullData[0:nullIndex]
    # header = b'tree 114'
    # b'tree 114'.decode().split() = ['tree', '114']
    type, sizeStr = header.decode('utf-8').split()
    size = int(sizeStr)
    data = fullData[nullIndex + 1:]
    assert size == len(data), "Expect size {}, But Got {} bytes.".\
                            format(size, len(data))
    return (type, data)

def readTree(hashCode = None, data = None):
    ''' Read Tree object and return list of (mode, path, sha1) tuples. '''
    if hashCode is not None:
        objType, data = readObject(hashCode)
        assert objType == 'true'
    elif data is None:
        print("You Should Specify 'sha1' or 'data'")
    ''' data =  b'100664 main.cpp\x00\xd8\xc1\xa2&i{:\x12\xf9%\x85\x03\x13
        \xe3{\x91\xe6"\xe4\xce100775 indexcat.py\x00\xd6\x8e\x19\x16S
        \xc2\xd2\x98\xe0\xdd\xfcW\xda\xeb=\xbdO\xa7\x8e\xf0100775 fkgit.py
        \x001\x03\x99\xe2Uh\xed4\x0f[\xba\xc6\x0f\xa3GU\xeb\x12\x85i'
    '''
    # B.index(sub[, start[, end]]) -> int
    # Like B.find() but raise ValueError when the substring is not found.
    start = 0
    entries = []
    while True:
        try:
            # index = 15
            index = data.index(b'\x00', start)
        except ValueError:
            break
        # ['100664', 'main.cpp']
        mode, path = data[start:index].decode('utf-8').split()
        sha1 = data[index + 1:index + 21]
        # pack three elements as a tuple.
        # ('100664', 'main.cpp', 'd8c1a226697b3a12f925850313e37b91e622e4ce')
        mixTuple = (mode, path, binascii.hexlify(sha1).decode('utf-8'))
        entries.append(mixTuple)
        start = index + 21
    return entries

def catFile(mode, hashCode):
    ''' Upper function of cat-file call. '''
    ''' git cat-file -p 19b5340d1316fc3f19b4d87f558ad2bd082d80fd
        100644 blob 49ec02b198e6ce4b454a9958929efe62cb5b530f    main.cpp
        100755 blob 0feef4cb2560de7e7380d2396a1e5fa18d92da37    fkgit.py
        100755 blob 6dd1382a4dcc9ef465515885865f41f89623873c    indexcat.py
        100755 blob 4285790ef284f43f960f4e2b85c464fb8d473767    demo.py
    '''
    if mode == 'raw':
        objType, data = readObject(hashCode, True)
    else:
        objType, data = readObject(hashCode)

    if mode == 'size':
        print(len(data))
    elif mode == 'type':
        print(objType)
    elif mode == 'pretty':
        if objType in ['blob', 'commit']:
            sys.stdout.buffer.write(data)
        elif objType == 'tree':
            # ('100664', 'main.cpp', 'd8c1a226697b3a12f925850313e37b91e622e4ce')
            for mode, path, sha1 in readTree(data = data):
                # int(x, base=10) -> integer, int(modeStr, 8) = 33188
                modInt = int(mode, 8)
                # S_ISDIR(mode) -> bool
                # Return True if mode is from a directory.
                if stat.S_ISDIR(modInt):
                    type = 'tree'
                else:
                    type = 'blob'
                # int('040000', 8) = 16384
                # stat.S_ISDIR(16384) = True
                '''040000 tree f90a0dbf3408bfc7a52e1693314abf8abbf7b7f7    haha
                   100644 blob 49ec02b198e6ce4b454a9958929efe62cb5b530f    main.cpp
                '''
                # print '040000', notice '0' before '40000'.
                # The store value is only '40000', need to be adjusted to length 6.
                # {:06} => 016384, {:06o} => 040000
                print("{:06o} {} {}\t{}".format(modInt, type, sha1, path))

def getLocalMasterHash():
    ''' Get SHA-1 of the latest commit of local master branch. '''
    # '.fkgit/refs/heads/master'
    masterPath = os.path.join(baseName, 'refs', 'heads', 'master')
    try:
        return readFile(masterPath).decode('utf-8').strip()
    except FileNotFoundError:
        return None

def writeTree():
    ''' Write a tree object from the current index file. '''
    for entry in readIndex():
        # entry.mode = 33277, {:o} o => octal
        # '{:o} {}'.format(entry.mode, entry.path) => '100775 demo.py'
        modePath = '{:o} {}'.format(entry.mode, entry.path).encode('utf-8')
        treeEntry = modePath + b'\x00' + entry.sha1
        treeEntries.append(treeEntry)
    print("treeEntries = ", treeEntries)
    # Example: b'.'.join([b'ab', b'pq', b'rs']) -> b'ab.pq.rs'.
    return(hashObject(b''.join(treeEntries), 'tree', True))

def commit(message):
    ''' Commit, using the index file and given message,
        return: sha1 of commit object. '''
    treeHash = writeTree()
    parent = getLocalMasterHash()

    # 'corsair <xiangp126@sjtu.edu.cn>'
    author = 'Annoymous'
    email = 'jokers@sjtu.edu.cn'
    try:
        author = '{} <{}>'.format(
            os.environ['GIT_AUTHOR_NAME'], os.environ['GIT_AUTHOR_EMAIL'])
    except KeyError:
        author = '{} <{}>'.format(author, email)

    # format author time.
    timeStamp = int(time.mktime(time.localtime()))
    authorTime = '1505732862 -0500'

    # standard git commit, The first commit, has no parent.
    ''' > git cat-file -p 13bf599
        tree 25e4ad73b4a7b7fd156f665a11769b98b434d1dc
        author corsair <xiangp126@126.com> 1505724533 -0400
        committer corsair <xiangp126@126.com> 1505724533 -0400

        Init commit
    '''
    # standard git commit, has parent commit.
    ''' > git cat-file -p df34f29
        tree 19b5340d1316fc3f19b4d87f558ad2bd082d80fd
        parent 13bf599a061991f4a0c1bfd6086ea6d48e5e232b
        author corsair <xiangp126@126.com> 1505725603 -0400
        committer corsair <xiangp126@126.com> 1505725603 -0400

        second commit
    '''
    # format commit info.
    commitInfo = ['tree ' + treeHash]
    # if has parent commit
    if parent:
        commitInfo.append('parent ' + parent)
    commitInfo.append('author {} {}'.format(author, authorTime))
    commitInfo.append('committer {} {}'.format(author, authorTime))
    commitInfo.append('')
    commitInfo.append(message)
    commitInfo.append('')
    ''' S.join(iterable) -> str
        Return a string which is the concatenation of the strings in the
            iterable.  The separator between elements is S.
        S => '\n', in this example.
    '''

    data = '\n'.join(commitInfo).encode('utf-8')
    sha1 = hashObject(data, 'commit', True)
    masterPath = os.path.join(baseName, 'refs', 'heads', 'master')
    writeFile(masterPath, (sha1 + '\n').encode('utf-8'))
    # [master df34f29] second commit
    print("[master {}] {}".format(sha1, message))
    return sha1

def readIndex():
    ''' Read index file, return list of IndexEntry object. '''
    try:
         data = readFile(os.path.join(baseName, 'index'))
    except FileNotFoundError:
        return []

    # calculate checksum leaving the last 20 bytes(checksum itself).
    # data[0:20], left included, right not.
    checkSum = hashlib.sha1(data[0:-20]).digest()
    assert checkSum == data[-20:], "Error, Invalid Index CheckSum."
    sigh, ver, fileCnt = struct.unpack('!4sLL', data[0:12])
    assert sigh == b'DIRC', \
            'Error, Invalid Index Signature {}'.format(sigh)
    assert ver == 2, 'Error, Unknown Index Version {}'.format(ver)

    # omit header and checksum part.
    allEntryPart = data[12:-20]
    entries = []
    # per entry data length.
    entryDataLen = 62

    i = 0
    while i + entryDataLen < len(allEntryPart):
        # not included, as j in [i:j]
        fieldEnd = i + entryDataLen
        ''' fields = (1505637351, 0, 1505637351, 0, 16777220, 35245842,
                    33188, 502, 20, 83,
             b'\x0c\x02Q\xe0\x9eya\xf9\x92s\xa5\xa8\xe9S\xf6Q\xeb_=Y', 8)
        '''
        fields = struct.unpack('>LLLLLLLLLL20sH', allEntryPart[i:fieldEnd])
        # parse path name, multiple b'\x00' terminatered.
        pathLen = fields[-1]
        entryLen = (((entryDataLen + pathLen) // 8) + 1) * 8
        path = allEntryPart[fieldEnd:fieldEnd + pathLen]
        # (path.decode('utf-8'),) convert str to tuple.
        ''' fields + (path.decode('utf-8'),) =
                (1505637351, 0, 1505637351, 0, 16777220, 35245842, 33188,
                 502, 20, 83,
                 b'\x0c\x02Q\xe0\x9eya\xf9\x92s\xa5\xa8\xe9S\xf6Q\xeb_=Y',
                 8, 'main.cpp')
        '''
        ''' IndexEntry(*(fields + (path.decode(),))) =
            IndexEntry(ctime_s=1505637351, ctime_n=0, mtime_s=1505637351,
            mtime_n=0, dev=16777220, ino=35245842, mode=33188, uid=502,
            gid=20, size=83,
            sha1=b'\x0c\x02Q\xe0\x9eya\xf9\x92s\xa5\xa8\xe9S\xf6Q\xeb_=Y',
            flags=8, path='main.cpp')
        '''
        entry = IndexEntry(*(fields + (path.decode(),)))
        entries.append(entry)
        i += entryLen

    assert len(entries) == fileCnt, "Error, File Count Not Match."
    return entries

def getStatus():
    ''' Get status of working tree, return (changedPaths, newPaths, delPath)
        as a tuple. '''
    paths = set()
    ''' > for root, dirs, files in os.walk('.'):
          ...  dirs[:] = [d for d in dirs if d != '.fkgit']
          ...  print("root = ", root, ", dirs = ", dirs, ", files = ", files)
          ...
          root =  . , dirs =  ['deer', 'lala'] , files =  ['demo.py',
                                    'main.cpp', 'indexcat.py', 'fkgit.py']
          root =  ./deer , dirs =  [] , files =  ['data.txt', 'raw.txt']
          root =  ./lala , dirs =  [] , files =  []
    '''
    for root, dirs, files in os.walk('.'):
        # omit dir '.fkgit'
        dirs[:] = [d for d in dirs if d != baseName]
        for file in files:
            path = os.path.join(root, file)
            if path.startswith('./'):
                path = path[2:]
            paths.add(path)
    ''' entries_by_path = {e.path: e for e in read_index()} =
        {'indexcat.py': IndexEntry(..., ..., path='indexcat.py'),
        'main.cpp': IndexEntry(..., ..., path='main.cpp')}
    '''
    # type(entries_by_path) = <class 'dict'>, convert to Key -> Value.
    entriesByPath = {entry.path: entry for entry in readIndex()}
    # entryPaths = {'indexcat.py', 'main.cpp'}
    entryPaths = set(entriesByPath)

    changedFiles = set()
    # check if SHA1 of the file has changed.
    # binascii.hexlify(entries_by_path['main.cpp'].sha1).decode('utf-8') =
    # '0c0251e09e7961f99273a5a8e953f651eb5f3d59'
    for path in (paths & entryPaths):
        sha1 = hashObject(readFile(path), 'blob', write = False)
        oriSHA1 = \
            binascii.hexlify(entriesByPath[path].sha1).decode('utf-8')
        if sha1 != oriSHA1:
            changedFiles.add(path)
    # only two set() can minus each other.
    newFiles = paths - entryPaths
    deletedFiles = entryPaths - paths
    #print(changedFiles, newFiles, deletedFiles)

    return (sorted(changedFiles), sorted(newFiles), sorted(deletedFiles))

def status():
    ''' The upper function of getStatus(). In case the latter is too large. '''
    changed, new, deleted = getStatus()
    if changed:
        print('changed files:')
        for path in changed:
            print('   ', path)
    if new:
        print('new files:')
        for path in new:
            print('   ', path)
    if deleted:
        print('deleted files:')
        for path in deleted:
            print('   ', path)

def add(paths):
    ''' Add files to 'stage', same as 'git add main.cpp'. '''
    entriesByPath = {entry.path: entry for entry in readIndex()}
    entries = []

    # type(paths) = <class 'list'>
    # make sure git add XX did not affect the others already in index file.
    for path in paths:
        sha1 = hashObject(readFile(path), 'blob', True)
        ''' os.stat(path) = os.stat_result(st_mode=33204, st_ino=195100843,
            st_dev=64512, st_nlink=1, st_uid=1000, st_gid=1000, st_size=82,
            st_atime=1505454057, st_mtime=1505453832, st_ctime=1505453832).
        '''
        st = os.stat(path)
        # Default encoding is 'utf-8'
        # 0 0 00 {12 bit} -> 'name length', 16 bit total.
        flags = len(path.encode('utf-8'))
        # only case lowest 12 bit(name length) not overflow.
        assert flags < (1 << 12)
        entry = IndexEntry(
                int(st.st_ctime), 0, int(st.st_mtime), 0, st.st_dev, st.st_ino,
                st.st_mode, st.st_uid, st.st_gid, st.st_size, bytes.fromhex(sha1),
                flags, path)
        entriesByPath[path] = entry
    entries = list(entriesByPath.values())
    entries.sort(key = operator.attrgetter('path'))
    writeIndex(entries)

def writeIndex(entries):
    ''' Write IndexEntry objects to fkgit index file. '''
    # read before write, see if the path already exists.

    packedEntries = []
    for entry in entries:
        # >: big-endian, std. size & alignment
        # L:unsigned long
        # s:string (array of char)
        # H:unsigned short
        # these can be preceded by a decimal repeat count
        # 20s, 20 char-length of string
        # type(entryHead) = <class 'bytes'>
        entryData = struct.pack('>LLLLLLLLLL20sH',
                entry.ctime_s, entry.ctime_n, entry.mtime_s, entry.mtime_n,
                entry.dev, entry.ino, entry.mode, entry.uid, entry.gid,
                entry.size, entry.sha1, entry.flags)
        # 'main.cpp' -> b'main.cpp'
        path = entry.path.encode('utf-8')
        ''' 1-8 nul bytes as necessary to pad the this entry to a multiple of
            eight bytes while keeping the name NUL-terminated.
        '''
        # math.floor 70 / 8 = 8.75, 70 // 8 = 8
        # len(entryData) = 62 = 10 * 4 + 20 + 2
        entryDataLen = len(entryData)
        pathLen = len(path)
        # calculate how many b'\x00' will be appeded after file name.
        trueLen = (math.floor((entryDataLen + pathLen) / 8) + 1) * 8
        packedEntry = entryData + path + b'\x00' * (trueLen - entryDataLen - pathLen)
        packedEntries.append(packedEntry)
    # | DIRC        | Version      | File count  | ...       |
    packHeader = struct.pack('>4sLL', b'DIRC', 2, len(entries))
    # The result is returned as a new bytes object.
    # Example: b'.'.join([b'ab', b'pq', b'rs']) -> b'ab.pq.rs'.
    # bytes + b''.join(list) => bytes
    allData = packHeader + b''.join(packedEntries)
    indexSha1 = hashlib.sha1(allData).digest()
    allData += indexSha1
    writeFile(os.path.join(baseName, 'index'), allData)

def hashObject(data, objType = 'blob', write = False):
    ''' Compute sha1 hashcode of specified file and write data to object
        directory if needed.  '''
    ''' The sample form stored in object file:
                       '${objType} ${len_of_char}' + '\0' + ${true_content}. '''
    # Unicode-objects must be encoded before hashing
    # type(header) = <class 'bytes'>
    header = "{} {}".format(objType, len(data)).encode('utf-8')
    fullData = header + b'\x00' + data
    # 0c0251e09e7961f99273a5a8e953f651eb5f3d59
    sha1 = hashlib.sha1(fullData).hexdigest()

    if write:
        # .git/objects/0c/0251e09e7961f99273a5a8e953f651eb5f3d59
        path = os.path.join(baseName, 'objects', sha1[:2], sha1[2:])
        dirName = os.path.dirname(path)
        if not os.path.exists(path):
            os.makedirs(dirName, exist_ok = True)
        # zlib compress the data to be stored.
        zlibData = zlib.compress(fullData)
        writeFile(path, zlibData)
    return sha1

def readFile(path):
    ''' Read file as bytes at given path. '''
    with open(path, "rb") as file:
        return file.read()

def writeFile(path, data):
    ''' write bytes to file at given path. '''
    # type(data) = <class 'bytes'>
    with open(path, "wb") as file:
        file.write(data)

def init(repo):
    ''' Init .fkgit associated files. '''
    global baseName
    # if base dir not exists, just create it.
    if not os.path.exists(baseName):
        os.makedirs(baseName, exist_ok = True)
        # ./.fkgit/{objects, refs}
        for name in ['objects', 'refs', 'refs/heads']:
            newDir = os.path.join(baseName, name)
            os.makedirs(newDir, exist_ok = True)
        # ./.fkgit/HEAD
        writePath = baseName + '/HEAD'
        writeFile(writePath, b'ref: refs/heads/master')
        print("Initialized Empty Repository {}".format(baseName))
    else:
        print("Warnning: Repository {} Not Empty.".format(baseName))

def addFilesInDir(newPaths, path):
    ''' Add all files recursively under the dir. '''
    if not os.path.isdir(path):
        newPaths.append(os.path.join('.', path))
        return

    for root, dirs, files in os.walk(path):
        dirs[:] = [d for d in dirs if d != baseName]
        if not (files == []):
            for file in files:
                newPaths.append(os.path.join(root, file))

def errMsg(msg):
    ''' Print Error Message. '''
    print("Error, {}".format(msg))
    sys.exit(1)

if __name__ == '__main__':
    ''' The help message was referenced by git relative page. '''
    parser = argparse.ArgumentParser()
    subParsers = parser.add_subparsers(dest = 'command')
    subParsers.required = True

    # git init
    subParser = subParsers.add_parser('init', help = 'initialize a new repo')

    # git add main.cpp indexcat.py
    subParser = subParsers.add_parser('add',
                                     help = 'Add file contents to the index')
    subParser.add_argument('paths', nargs = '+',
                                     help = 'path(s) of files to add')

    # git hash-object -t {commit,tree,blob}] [-w] <file_name>
    subParser = subParsers.add_parser('hash-object',
            help = 'hash contents of given file(optionally write to '
                 'object store)')
    subParser.add_argument('path', help = 'path of file to hash')
    subParser.add_argument('-t', choices = ['commit', 'tree', 'blob'],
            default = 'blob', dest = 'type',
            help = 'object type (default %(default)r)')
    subParser.add_argument('-w', action = 'store_true', dest = 'write',
            help = "write the object into the object database")

    # git ls-files -s
    subParser = subParsers.add_parser('ls-files', help = 'list files in index')
    subParser.add_argument('-s', '--stage', action = 'store_true',
                dest = 'stage', help = 'show object details (mode, hash, and '
                'stage number) in addition to path')

    # git cat-file [-p] SHA1
    subParser = subParsers.add_parser('cat-file',
            help='display contents of object')
    subParser.add_argument('-t', '--type', action = 'store_true',
                                    dest = 'type', help = "show object type")
    subParser.add_argument('-s', '--size', action = 'store_true',
                                    dest = 'size', help = "show object size")
    subParser.add_argument('-p', '--pretty', action = 'store_true',
                     dest = 'pretty', help = "pretty-print object's content")
    subParser.add_argument('-r', '--raw', action = 'store_true',
           dest = 'raw', help = "show raw data of object after decompressed")
    subParser.add_argument('sha1', help = "SHA1 of the object")
    subParser.required = False

    # git commit -m 'message'
    subParser = subParsers.add_parser('commit',
            help='commit current state of index to master branch')
    subParser.add_argument('-a', '--author',
            help='commit author in format "A U Thor <author@example.com>" '
                 '(uses GIT_AUTHOR_NAME and GIT_AUTHOR_EMAIL environment '
                 'variables by default)')
    subParser.add_argument('-m', '--message', required=True,
            help='text of commit message')

    # git diff
    subParser = subParsers.add_parser('diff',
          help = 'show diff of files changed (between index and working tree)')

    # git status
    subParser = subParsers.add_parser('status',
                                        help='show status of working copy')

    # actual arguments parse stage.
    args = parser.parse_args()

    if args.command == 'add':
        param = args.paths
        newPaths  = []
        if param == list('.'):
            # add support to 'git add .' for all files in current dir.
            addFilesInDir(newPaths, '.')
        else:
            for path in param:
                addFilesInDir(newPaths, path)

        # excluded post fix file.
        exPostfix = ['swp', 'swo']
        for file in newPaths:
            if file.split('.')[-1] in exPostfix:
                newPaths.remove(file)

        add(newPaths)
        for path in newPaths:
            print(path)

    elif args.command == 'cat-file':
        try:
            if args.type:
                catFile('type', args.sha1)
            elif args.size:
                catFile('size', args.sha1)
            elif args.pretty:
                catFile('pretty', args.sha1)
            elif args.raw:
                catFile('raw', args.sha1)
            else:
                print("Missing Parameter before SHA1, Please See Help Page.")
                sys.exit(1)
        except ValueError as error:
            print(error, file = sys.stderr)
            sys.exit(1)
    elif args.command == 'commit':
        commit(args.message)
    elif args.command == 'diff':
        diff()
    elif args.command == 'hash-object':
        sha1 = hashObject(readFile(args.path), args.type, args.write)
        print(sha1)
    elif args.command == 'init':
        init('.')
    elif args.command == 'ls-files':
        lsFiles(args.stage)
    elif args.command == 'status':
        status()
    else:
        # 'unexpected command {}'.format(command)
        #                    => "unexpected command diff"
        # {!r} => r => raw
        # 'unexpected command {!r}'.format(command)
        #                    => "unexpected command 'diff'"
        assert False, 'unexpected command {!r}'.format(args.command)
