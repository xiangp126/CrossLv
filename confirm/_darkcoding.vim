" DERIVED FROM 'DEFAULT' SCHEME, COPYRIGHT BY PENG 2018 
" COLOR REFERENCE http://blog.csdn.net/cp3alai/article/details/45509459
hi clear Normal
set bg&

" Remove all existing highlighting and set the defaults.
hi clear

" Load the syntax highlighting defaults, if it's enabled.
if exists("syntax_on")
  syntax reset
endif

let colors_name = "darkcoding"
" ---------------------- comment ---------------------
hi Comment ctermfg=Grey guifg=green
hi Directory ctermfg=Blue
" ---------------------- pop up menu ---------------------
hi PMenu ctermfg=DarkGrey ctermbg=16
hi PmenuSel ctermfg=DarkYellow ctermbg=0 term=Bold
" ---------------------- status line ---------------------
hi StatusLine ctermfg=DarkGrey ctermbg=0
" ---------------------- match parentheses ---------------------
" match parentheses, cursor color can be set in 'iTerm' -> 
" preference " -> Profiles -> default -> colors -> cursor colors
hi MatchParen ctermbg=Black ctermfg=DarkMagenta term=standout
" ---------------------- visual mode selection ---------------------
hi Visual ctermfg=Grey ctermbg=237 term=Bold

" vim: sw=4
