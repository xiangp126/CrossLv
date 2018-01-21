" Derived from 'default' scheme, copyright by Peng 2018
hi clear Normal
set bg&

" Remove all existing highlighting and set the defaults.
hi clear

" Load the syntax highlighting defaults, if it's enabled.
if exists("syntax_on")
  syntax reset
endif

let colors_name = "darkcoding"
hi Comment ctermfg=Grey guifg=green
hi Directory ctermfg=Blue

hi PMenu ctermfg=DarkGrey ctermbg=0
hi PmenuSel ctermfg=Brown ctermbg=0
hi StatusLine ctermfg=DarkGrey ctermbg=0

" match parentheses, cursor color can be set in 'iTrem' -> preference ->
" Profiles -> default -> colors -> cursor colors
hi MatchParen ctermbg=Black ctermfg=DarkMagenta term=standout
" Visual mode selection section color
hi Visual ctermfg=DarkYellow ctermbg=0 term=Bold

" vim: sw=4
