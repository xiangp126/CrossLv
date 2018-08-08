## YCM
vim config

```vim
nnoremap <leader>j :YcmCompleter GoToDefinitionElseDeclaration<CR>
nnoremap <leader>D :YcmDiags<CR>
nnoremap <leader>I :YcmCompleter FixIt<CR>
```

### Compile & Build
refer [vim-youcompleteme clang+llvm](https://www.jianshu.com/p/c24f919097b3)

	build gcc/c++ supporting c++11
	build python3 support python3-config
	build cmake > 3.4
	build clang
	build vim > 7.4
	compile YouCompleteMe

### Issue
```
./ycm_core.so: /lib64/libc.so.6: version `GLIBC_2.15' not found (required by ~/.vim/bundle/YouCompleteMe/third_party/ycmd/./libclang.so.5)
./ycm_core.so: /lib64/libc.so.6: version `GLIBC_2.14' not found (required by ~/.vim/bundle/YouCompleteMe/third_party/ycmd/./libclang.so.5)
```

> brief
>
>- ./install.py will download pre-compiled libclang.so (compiled on Ubuntu 14.04) that is newer than CennOS
>- you should self-compile clang with your glibc version on your OS

and at last

```bash
cd ~/.vim/bundle/YouCompleteMe/third_party/ycmd
ln -s ~/myGit/mylx-vundle/sample/llvm-5.0.1.src/build_dir/lib/libclang.so.5 libclang.so.5
```

refer <https://github.com/Valloric/ycmd/issues/838>

#### check ycmd ilnk issue
```bash
cd ~/.vim/bundle/YouCompleteMe/third_party/ycmd
ldd ycm_core.so
python -c "import ycm_core; print(ycm_core.HasClangSupport())"
python3 -c "import ycm_core; print(ycm_core.HasClangSupport())"
```

you should compile python3 with your self-compiled gcc/c++ first

```vim
let g:ycm_server_python_interpreter = '/usr/bin/python3'
```

#### Only for MAC
unavailable:cannot import name _remove_dead_weakref

```bash
brew uninstall python@2
```