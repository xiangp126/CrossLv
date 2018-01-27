" ============================================================================
" File:        default.vim
" Description:
" Author:      Yggdroot <archofortune@gmail.com>
" Website:     https://github.com/Yggdroot
" Note:
" License:     Apache License, Version 2.0
" ============================================================================

" stlName -> leaderf
" stlCwd  -> current working directory
let s:palette = {
            \   'stlName': {
            \       'gui': 'bold',
            \       'font': 'NONE',
            \       'guifg': '#2F5C00',
            \       'guibg': '#BAFFA3',
            \       'cterm': 'bold',
            \       'ctermfg': '16',
            \       'ctermbg': '109'
            \   },
            \   'stlCategory': {
            \       'gui': 'NONE',
            \       'font': 'NONE',
            \       'guifg': '#000000',
            \       'guibg': '#F28379',
            \       'cterm': 'NONE',
            \       'ctermfg': '16',
            \       'ctermbg': '137'
            \   },
            \   'stlNameOnlyMode': {
            \       'gui': 'NONE',
            \       'font': 'NONE',
            \       'guifg': '#000000',
            \       'guibg': '#E8ED51',
            \       'cterm': 'NONE',
            \       'ctermfg': '16',
            \       'ctermbg': '130'
            \   },
            \   'stlFullPathMode': {
            \       'gui': 'NONE',
            \       'font': 'NONE',
            \       'guifg': '#000000',
            \       'guibg': '#AAAAFF',
            \       'cterm': 'NONE',
            \       'ctermfg': '16',
            \       'ctermbg': '130'
            \   },
            \   'stlFuzzyMode': {
            \       'gui': 'NONE',
            \       'font': 'NONE',
            \       'guifg': '#000000',
            \       'guibg': '#E8ED51',
            \       'cterm': 'NONE',
            \       'ctermfg': '16',
            \       'ctermbg': '130'
            \   },
            \   'stlRegexMode': {
            \       'gui': 'NONE',
            \       'font': 'NONE',
            \       'guifg': '#000000',
            \       'guibg': '#7FECAD',
            \       'cterm': 'NONE',
            \       'ctermfg': '16',
            \       'ctermbg': '130'
            \   },
            \   'stlCwd': {
            \       'gui': 'NONE',
            \       'font': 'NONE',
            \       'guifg': '#EBFFEF',
            \       'guibg': '#606168',
            \       'cterm': 'Bold',
            \       'ctermfg': '16',
            \       'ctermbg': 'DarkGrey'
            \   },
            \   'stlBlank': {
            \       'gui': 'NONE',
            \       'font': 'NONE',
            \       'guifg': 'NONE',
            \       'guibg': '#3B3E4C',
            \       'cterm': 'NONE',
            \       'ctermfg': 'NONE',
            \       'ctermbg': '237'
            \   },
            \   'stlLineInfo': {
            \       'gui': 'NONE',
            \       'font': 'NONE',
            \       'guifg': '#000000',
            \       'guibg': '#EBFFEF',
            \       'cterm': 'NONE',
            \       'ctermfg': '16',
            \       'ctermbg': '109'
            \   },
            \   'stlTotal': {
            \       'gui': 'NONE',
            \       'font': 'NONE',
            \       'guifg': '#000000',
            \       'guibg': '#BCDC5C',
            \       'cterm': 'NONE',
            \       'ctermfg': '16',
            \       'ctermbg': '140'
            \   }
            \ }

let g:leaderf#colorscheme#default#palette = leaderf#colorscheme#mergePalette(s:palette)
