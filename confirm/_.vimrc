""""""""""""""""""""""""""""
" BASIC CONFIG
""""""""""""""""""""""""""""""
syntax on
set ignorecase
set number
set ruler
set autoindent
set cindent
set tabstop=4
set laststatus=1
set softtabstop=4
set shiftwidth=4
set expandtab         "set TAB expands to spaces
set cinoptions={0,1s,t0,n-2,p2s,(03s,=.5s,>1s,=1s,:1s
set encoding=utf-8
set fileencoding=utf-8
set fileencodings=utf-8,gb2312,gb18030,gbk,ucs-bom,cp936,latin1
set termencoding=utf-8
set backspace=indent,eol,start
" set text auto line feed when exceeds 80 characters.
" set textwidth=80 formatoptions+=Mm
let mapleader='\'     " leader key, default is '\''
":help ins-completion-menu
set nocompatible      " be iMproved, required
set autochdir         " auto change 'pwd' value
set pumheight=12      " maximum height of popup menu
set shell=/bin/bash   " set vim default shell
" self-scheme under ~/.vim/colors/
:colorscheme darkcoding

""""""""""""""""""""""""""""""
" BASIC KEYBIND
""""""""""""""""""""""""""""""
set pastetoggle=<F12>
noremap <F10> :set invnumber <CR>
" move among buffers with CTRL, case ignorance
map <C-L> :buffers <CR>
map <C-J> :bnext <CR>
map <C-K> :bprev <CR>

""""""""""""""""""""""""""""""
" SUMMARIZE PLUGIN MAPPING
""""""""""""""""""""""""""""""
" nnoremap <silent> <F2> :IndentLinesToggle <CR>
" nnoremap <silent> <F3> :NERDTreeToggle<CR>
" map <F4> <leader>ci <CR>
" nnoremap <silent> <F5> :call TagbarMyOpen() <CR>
" nnoremap <silent> <F6> :AirlineToggle <CR>

""""""""""""""""""""""""""""""
" VIM BUNDLE
""""""""""""""""""""""""""""""
filetype off          " Vundle required
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'VundleVim/Vundle.vim'

"------ OPTIONAL PLUGINS -----
" Plugin 'L9'
" Plugin 'davidhalter/jedi'
" Plugin 'tell-k/vim-autopep8'
" Plugin 'Raimondi/delimitMate'
Plugin 'Chiel92/vim-autoformat'
Plugin 'Yggdroot/LeaderF'
"------ NEW PLUGINS -----
Plugin 'scrooloose/nerdtree'
Plugin 'scrooloose/nerdcommenter'
Plugin 'jiangmiao/auto-pairs'
Plugin 'majutsushi/tagbar'
Plugin 'Yggdroot/indentLine'
"------ BEAUTIFY LINE -----
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
"------ THREE ALGOTHER -----
Plugin 'ervandew/supertab'
Plugin 'SirVer/ultisnips'
Plugin 'honza/vim-snippets'
"------ END OF THREE  -----
Plugin 'Valloric/YouCompleteMe'
" complete parameter after type '('
Plugin 'tenfyzhong/CompleteParameter.vim'

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
" CONFIG VIM-AIRLINE
""""""""""""""""""""""""""""""
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#buffer_nr_show = 1
let g:airline#extensions#tabline#left_sep = ' '
let g:airline#extensions#tabline#left_alt_sep = '|'
" let g:airline#extensions#tabline#formatter = 'unique_tail'
let g:airline#extensions#tabline#formatter = 'jsformatter'

""""""""""""""""""""""""""""""
" CONFIG VIMAIRLINE-THEME
""""""""""""""""""""""""""""""
let g:airline_theme = 'base16_grayscale'
nnoremap <silent> <F6> :AirlineToggle <CR>

""""""""""""""""""""""""""""""
" CONFIG TAGBAR
""""""""""""""""""""""""""""""
" let g:tagbar_ctags_bin = "/usr/bin/ctags"
nnoremap <silent> <F5> :call TagbarMyOpen() <CR>
let g:Tagbar_title = "[Tagbar]"
let g:tagbar_left = 0
let g:tagbar_width = 25
" originally Yellow value 11
highlight Search ctermbg=88
highlight TagbarSignature ctermfg=68
function! TagbarMyOpen()
    exec 'TagbarToggle'
endfunction

""""""""""""""""""""""""""""""
" CONFIG INDENTLINE
""""""""""""""""""""""""""""""
let g:indentLine_char = '|'
let g:indentLine_enabled = 0
nnoremap <silent> <F2> :IndentLinesToggle <CR>

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
" CONFIG NERDCOMMENTER
""""""""""""""""""""""""""""""
"quick comment/uncomment
map <F4> <leader>ci <CR>
"add a space after comment flag
let g:NERDSpaceDelims = 1

""""""""""""""""""""""""""""""
" CONFIG SUPERTAB
""""""""""""""""""""""""""""""
let g:SuperTabDefaultCompletionType = '<C-n>'

""""""""""""""""""""""""""""""
" CONFIG AUTO-PAIRS
""""""""""""""""""""""""""""""
let g:AutoPairs = {'[':']', '{':'}',"'":"'",'"':'"', '`':'`'}
inoremap <buffer><silent> ) <C-R>=AutoPairsInsert(')')<CR>

""""""""""""""""""""""""""""""
" CONFIG ULTISNIPS
""""""""""""""""""""""""""""""
"Trigger configuration. Do not use <tab>
"if you use https://github.com/Valloric/YouCompleteMe.
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger = "<tab>"
let g:UltiSnipsJumpBackwardTrigger = "<c-b>"
" If you want :UltiSnipsEdit to split your window.
let g:UltiSnipsEditSplit="vertical"

""""""""""""""""""""""""""""""
" CONFIG COMPLETEPARAMETER.VIM
""""""""""""""""""""""""""""""
inoremap <silent><expr> ( complete_parameter#pre_complete("()")
smap <c-j> <Plug>(complete_parameter#goto_next_parameter)
imap <c-j> <Plug>(complete_parameter#goto_next_parameter)
smap <c-k> <Plug>(complete_parameter#goto_previous_parameter)
imap <c-k> <Plug>(complete_parameter#goto_previous_parameter))
" use ultisnips mapping to goto next or previous parameter if set
let g:complete_parameter_use_ultisnips_mapping = 0

""""""""""""""""""""""""""""""
" CONFIG YOUCOMPLETEME
""""""""""""""""""""""""""""""
let g:ycm_semantic_triggers =  {
  \   'c' : ['->', '.', 're![_a-zA-z0-9]'],
  \   'objc' : ['->', '.', 're!\[[_a-zA-Z]+\w*\s', 're!^\s*[^\W\d]\w*\s',
  \             're!\[.*\]\s'],
  \   'ocaml' : ['.', '#'],
  \   'cpp,objcpp' : ['->', '.', '::', 're![_a-zA-z0-9]'],
  \   'perl' : ['->'],
  \   'php' : ['->', '::'],
  \   'cs,java,javascript,typescript,d,python,perl6,scala,vb,elixir,go' : ['.'],
  \   'ruby' : ['.', '::'],
  \   'lua' : ['.', ':'],
  \   'erlang' : [':'],
  \ }
" let g:ycm_keep_logfiles = 1
" let g:ycm_log_level = 'debug'
set completeopt=longest,menu
let g:ycm_global_ycm_extra_conf = '~/.ycm_extra_conf.py'
let g:ycm_confirm_extra_conf = 0
let g:ycm_enable_diagnostic_signs = 0
let g:ycm_enable_diagnostic_highlighting = 0
let g:ycm_error_symbol = '>>'
let g:ycm_warning_symbol = '>*'
"let g:ycm_key_invoke_completion = '<F9>'
let g:ycm_collect_identifiers_from_tags_files = 1
let g:ycm_min_num_of_chars_for_completion = 2
let g:ycm_complete_in_comments = 1
let g:ycm_complete_in_strings = 1
let g:ycm_collect_identifiers_from_comments_and_strings = 0
let g:ycm_cache_omnifunc = 0
" make YCM compatible with UltiSnips (using supertab)
let g:ycm_key_list_select_completion = ['<C-n>', '<Down>']
let g:ycm_key_list_previous_completion = ['<C-p>', '<Up>']
"do not delete next line | specify python3 interpreter
let g:ycm_server_python_interpreter = '/usr/bin/python3'
let g:ycm_add_preview_to_completeopt = 0
let g:ycm_autoclose_preview_window_after_insertion = 0
let g:ycm_autoclose_preview_window_after_completion = 0
let g:ycm_goto_buffer_command = 'new-tab'
nnoremap <leader>gl :YcmCompleter GoToDeclaration<CR>
nnoremap <leader>gf :YcmCompleter GoToDefinition<CR>
nnoremap <leader>gd :YcmCompleter GoToDefinitionElseDeclaration<CR>
