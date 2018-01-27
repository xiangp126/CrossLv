" My Vim Default color file: corsair.vim, work together with self-.vimrc
" placed under ~/.vim/colors, that not influence other's.

" This is the default color scheme.  It doesn't define the Normal
" highlighting, it uses whatever the colors used to be.

" Set 'background' back to the default.  The value can't always be estimated
" and is then guessed.
hi clear Normal
set bg&

" Remove all existing highlighting and set the defaults.
hi clear

" Load the syntax highlighting defaults, if it's enabled.
if exists("syntax_on")
  syntax reset
endif

let colors_name = "corsair"
" add self optimization here
" hi Search term=reverse ctermbg=Yellow ctermfg=Black guibg=Yellow guifg=Black
hi Comment ctermfg=Grey guifg=green
hi Directory ctermfg=Blue
" PopUp Menu
" hi pMenu ctermbg=22 ctermfg=Grey
hi pMenu ctermbg=DarkGrey ctermfg=Grey
hi PmenuSel ctermfg=Brown
" match parentheses, cursor color can be set in 'iTrem' -> preference ->
" Profiles -> default -> colors -> cursor colors
hi MatchParen ctermbg=Black ctermfg=DarkMagenta term=standout
" Visual mode selection section color
hi Visual ctermfg=DarkYellow term=Bold

" vim: sw=4
