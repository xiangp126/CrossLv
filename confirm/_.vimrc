"""""""""""""""""""""""""""""
" BASIC CONFIG
""""""""""""""""""""""""""""""
syntax on
set ignorecase
set number
set ruler
set tabstop=4
set expandtab " set TAB expands to spaces
set laststatus=1
set softtabstop=4
set shiftwidth=4
set autoindent
set cindent
set cinoptions={0,1s,t0,n-2,p2s,(03s,=.5s,>1s,=1s,:1s
set fileencodings=utf-8,gb2312,gb18030,gbk,ucs-bom,cp936,latin1
set enc=utf8
set fencs=utf8,gbk,gb2312,gb18030
" set text auto next line when exceed 80 characters.
" set textwidth=80 formatoptions+=Mm
" always use 'corsair.vim' scheme in private ~/.vim/colors/corsair.vim
:colorscheme corsair
let mapleader='\'  " leader key, default is '\''

""""""""""""""""""""""""""""""
" BASIC KEYBIND 
""""""""""""""""""""""""""""""
"map <F10>:set paste<CR>
set pastetoggle=<F11>

""""""""""""""""""""""""""""""
" VIM BUNDLE 
""""""""""""""""""""""""""""""
set nocompatible              " be iMproved, required
set backspace=indent,eol,start
filetype off                  " required
" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

" The following are examples of different formats supported.
" Keep Plugin commands between vundle#begin/end.
" #1 case: plugin on GitHub repo
" Plugin 'tpope/vim-fugitive'
" plugin from http://vim-scripts.org/vim/scripts.html
" Plugin 'L9'

" #2 case: Git plugin not hosted on GitHub
" Plugin 'git://git.wincent.com/command-t.git'

" #3 case: git repos on your local machine 
" i.e. when working on your own plugin.
" Plugin 'file:///home/gmarik/path/to/plugin'

" The sparkup vim script is in a subdirectory of this repo called vim.
" Pass the path to set the runtimepath properly.
" Plugin 'rstacruz/sparkup', {'rtp': 'vim/'}
" Install L9 and avoid a Naming conflict if you've already installed a
" different version somewhere else.
" Plugin 'ascenator/L9', {'name': 'newL9'}

" Add plugins you need below.
" Plugin 'L9'
" Plugin 'OmniCppComplete'
" Plugin 'snipMate'
" Plugin 'vim-airline/vim-airline'
" Plugin 'vim-airline/vim-airline-themes'
" Plugin 'tell-k/vim-autopep8'
" Plugin 'Lokaltog/vim-powerline'

"------ NEW PLUGINS -----
Plugin 'Tagbar'
Plugin 'scrooloose/nerdtree'
Plugin 'scrooloose/nerdcommenter'
Plugin 'Yggdroot/indentLine'
Plugin 'jiangmiao/auto-pairs'
"------ THREE ALGOTHER -----
Plugin 'SirVer/ultisnips'
Plugin 'ervandew/supertab'
Plugin 'honza/vim-snippets'
"------ END OF THREE  -----
Plugin 'Valloric/YouCompleteMe'

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
" To ignore plugin indent changes, instead use:
"filetype plugin on
"
" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
"
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line

""""""""""""""""""""""""""""""
" SET VIM SHELL
""""""""""""""""""""""""""""""
" Set default shell for vim, resolving below problem
" Error detected while processing function <SNR>33_Tlist_Window_Toggle..
" line   87:
" E484: Can't open file /tmp/vZAVQWu/0
" Taglist: Failed to generate tags for
set shell=/bin/bash

""""""""""""""""""""""""""""""
" SET TAGS FILE 
""""""""""""""""""""""""""""""" 
set autochdir " Auto change 'pwd' value
" set tags=/usr/include/system-include.tags " 1st tag use '=' not '+='
" " if you will jump across different source dircetory
" set tags+=./tags

""""""""""""""""""""""""""""""
" CONFIG CSCOPE
""""""""""""""""""""""""""""""
if has("cscope")
    set cscopetag   " let only support Ctrl+] & Ctrl+t to jump between
    " check cscope for definition of a symbol before checking ctags:
    " set to 1 if you want the reverse search order.
    set csto=1

    " add any cscope database in current directory
    if filereadable("cscope.out")
        cs add cscope.out
    " else add the database pointed to by environment variable
    elseif $CSCOPE_DB !=""
        cs add $CSCOPE_DB
    endif

    " show msg when any other cscope db added
    set cscopeverbose

    nmap <C-\>s :cs find s <C-R>=expand("<cword>")<CR><CR>
    nmap <C-\>g :cs find g <C-R>=expand("<cword>")<CR><CR>
    nmap <C-\>c :cs find c <C-R>=expand("<cword>")<CR><CR>
    nmap <C-\>t :cs find t <C-R>=expand("<cword>")<CR><CR>
    nmap <C-\>e :cs find e <C-R>=expand("<cword>")<CR><CR>
    nmap <C-\>f :cs find f <C-R>=expand("<cfile>")<CR><CR>
    nmap <C-\>i :cs find i <C-R>=expand("<cfile>")<CR><CR>
    nmap <C-\>d :cs find d <C-R>=expand("<cword>")<CR><CR>
    endif

""""""""""""""""""""""""""""""
" CONFIG MINIBUFEXPLPP 
""""""""""""""""""""""""""""""
let g:miniBufExplMapWindowNavVim = 1   
let g:miniBufExplMapWindowNavArrows = 1   
let g:miniBufExplMapCTabSwitchBufs = 1   
let g:miniBufExplModSelTarget = 1  
let g:miniBufExplAutoStart = 1
" comment to disable it
let g:miniBufExplorerMoreThanOne = 1  
" MiniBufExpl Colors
" hi MBENormal          ctermbg=88
" hi MBEChanged         ctermbg=89
" hi MBEVisibleNormal   ctermbg=88
" hi MBEVisibleChanged  ctermbg=89
highlight MBEVisibleActiveNormal  ctermfg=5
highlight MBEVisibleActiveChanged cterm=underline ctermfg=5

""""""""""""""""""""""""""""""
" CONFIG NERDTREE 
""""""""""""""""""""""""""""""
" When pressed F3, toggle nerd tree
nnoremap <silent> <F3> :NERDTreeToggle<CR>
let g:NERDTree_title = "[NERDTree]"
let g:NERDTreeShowBookmarks = 0
let g:NERDTreeWinSize = 20 " default 30
let g:NERDTreeWinPos = 'left' " only left or right

""""""""""""""""""""""""""""""
" CONFIG TAGBAR
""""""""""""""""""""""""""""""
" When pressed F5, toggle tagbar window
nnoremap <silent> <F5> :call TagbarMyOpen()<CR><CR>
let g:Tagbar_title = "[Tagbar]"
" let g:tagbar_ctags_bin = "/usr/bin/ctags"
let g:tagbar_left = 0
let g:tagbar_width = 20
" originally Yellow value 11
highlight Search ctermbg=88
highlight TagbarSignature ctermfg=68
function! TagbarMyOpen()
    exec 'TagbarToggle'
endfunction

""""""""""""""""""""""""""""""
" CONFIG AUTO-COMPLPOP
""""""""""""""""""""""""""""""
" disables auto-popup at startup, if needed use :AcpEnable manually
let g:acp_enableAtStartup = 0 

""""""""""""""""""""""""""""""
" CONFIG OMNICPPCOMPLETE
""""""""""""""""""""""""""""""
" ctags --c-kinds=+px --c++-kinds=+px --fields=+iafksS --extra=+qf -R /usr/include/*
" map <C-F12> :!ctags -R --c++-kinds=+p --fields=+iaS --extra=+q .<CR>
set completeopt=menu,longest,menuone
let OmniCpp_NamespaceSearch = 2
let OmniCpp_GlobalScopeSearch = 1
let OmniCpp_ShowAccess = 1
let OmniCpp_ShowPrototypeInAbbr = 1 
let OmniCpp_MayCompleteDot = 1   
let OmniCpp_MayCompleteArrow = 1 
let OmniCpp_MayCompleteScope = 1 
let OmniCpp_DefaultNamespaces = ["std", "_GLIBCXX_STD"]
let OmniCpp_SelectFirstItem = 2
let OmniCpp_DisplayMode = 1
au CursorMovedI,InsertLeave * if pumvisible() == 0|silent! pclose|endif

""""""""""""""""""""""""""""""
" CONFIG INDENTLINE
""""""""""""""""""""""""""""""
let g:indentLine_char = '|'
let g:indentLine_enabled = 0
nnoremap <silent> <F2> :IndentLinesToggle<CR>

""""""""""""""""""""""""""""""
" CONFIG AUTOPEP8
""""""""""""""""""""""""""""""
let g:autopep8_disable_show_diff = 1

""""""""""""""""""""""""""""""
" CONFIG NERDCOMMENTER
""""""""""""""""""""""""""""""
"quick comment/uncomment
map <F4> <leader>ci <CR>

""""""""""""""""""""""""""""""
" CONFIG SUPERTAB
""""""""""""""""""""""""""""""
let g:SuperTabDefaultCompletionType = '<C-n>'

""""""""""""""""""""""""""""""
" CONFIG ULTISNIPS
""""""""""""""""""""""""""""""
"Trigger configuration. Do not use <tab> 
"if you use https://github.com/Valloric/YouCompleteMe.
" 
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger = "<tab>"
let g:UltiSnipsJumpBackwardTrigger = "<c-b>"
" If you want :UltiSnipsEdit to split your window.
let g:UltiSnipsEditSplit="vertical"

""""""""""""""""""""""""""""""
" CONFIG YouCompleteMe
""""""""""""""""""""""""""""""
" let g:ycm_keep_logfiles = 1
" let g:ycm_log_level = 'debug'
set completeopt=longest,menu
let g:ycm_global_ycm_extra_conf = '~/.ycm_extra_conf.py'
let g:ycm_confirm_extra_conf = 0 
let g:ycm_enable_diagnostic_signs = 0
let g:ycm_enable_diagnostic_highlighting = 0
let g:ycm_error_symbol = '>>'
let g:ycm_warning_symbol = '>*'
let g:ycm_collect_identifiers_from_tags_files = 1 
let g:ycm_min_num_of_chars_for_completion = 2 
let g:ycm_complete_in_comments = 1
let g:ycm_complete_in_strings = 1
let g:ycm_collect_identifiers_from_comments_and_strings = 0
let g:ycm_autoclose_preview_window_after_completion = 1
let g:ycm_cache_omnifunc = 0
" make YCM compatible with UltiSnips (using supertab)
let g:ycm_key_list_select_completion = ['<C-n>', '<Down>']
let g:ycm_key_list_previous_completion = ['<C-p>', '<Up>']
