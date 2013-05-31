
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" File Name:      winter.vim
" Abstract:       A color sheme file (only for GVIM) which uses a light grey 
"                 background makes the VIM look like the scenes of winter.
" Author:         CHE Wenlong <chewenlong AT buaa.edu.cn>
" Version:        1.0
" Last Change:    September 19, 2008

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

if !has("gui_running")
    runtime! colors/default.vim
    finish
endif

set background=light

hi clear

" Version control
if version > 580
    hi clear
    if exists("syntax_on")
        syntax reset
    endif
endif

let colors_name = "winter"

" Common
hi Normal           guifg=#000000   guibg=#d4d0c8   gui=NONE
hi Visual           guibg=#ccffff                   gui=NONE
hi Cursor           guifg=#d4d0c8   guibg=#cd0000   gui=NONE
hi Cursorline       guibg=#ccffff
hi lCursor          guifg=#000000   guibg=#ffffff   gui=NONE
hi LineNr           guifg=#707070   guibg=#e0e0e0   gui=NONE
hi Title            guifg=#202020   guibg=NONE      gui=bold
hi Underlined       guifg=#202020   guibg=NONE      gui=underline

" Split
hi StatusLine       guifg=#e0e0e0   guibg=#707070   gui=NONE
hi StatusLineNC     guifg=#e0e0e0   guibg=#909090   gui=NONE
hi VertSplit        guifg=#909090   guibg=#909090   gui=NONE

" Folder
hi Folded           guifg=#707070   guibg=#e0e0e0   gui=NONE

" Syntax
hi Type             guifg=#009933   guibg=NONE      gui=bold
hi Define           guifg=#1060a0   guibg=NONE      gui=bold
hi Comment          guifg=#0080ff   guibg=NONE      gui=NONE
hi Constant         guifg=#a07040   guibg=NONE      gui=NONE
hi String           guifg=#a07040   guibg=NONE      gui=NONE
hi Number           guifg=#cd0000   guibg=NONE      gui=NONE
hi Statement        guifg=#fc548f   guibg=NONE      gui=bold

" Others
hi PreProc          guifg=#1060a0    guibg=NONE     gui=NONE
hi Error            guifg=#ff0000    guibg=#ffffff  gui=bold,underline
hi Todo             guifg=#ff0000    guibg=#ffff00  gui=bold,underline
hi Special          guifg=#8b038d    guibg=NONE     gui=NONE
hi SpecialKey       guifg=#a07040    guibg=#e0e0e0  gui=NONE

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" vim:tabstop=4

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

