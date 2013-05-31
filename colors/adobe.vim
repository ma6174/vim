" Vim color file
" Maintainer:  mdelliot
" Last Change: $Date: 2005-09-23 08:53:22 -0700 (Fri, 23 Sep 2005) $
" Revsision:   $Revision: 38 $
" Version:     0.2
" Info:        Adobe theme, easy on eyes.
"
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Philosophy:
"
" - Nothing should be bold unless it's very important and should stand
"   out above all other things. Functions/Classes are good for this.
"
" - Colors should be easy on eyes to stare at for many hours.
"
" - Todos should stand out just a little (underline looks nice).
"
" - Comments should be stand out less than anything else.
"
" - Strings should be a beautiful color since much documentation should
"   exist in source code as strings (think """ comments in python or /**
"   in java).
"
" - Normal text should be colored either black or white so it is obvious
"   if something is not recognized syntax.
"
" - No two used colors should be highly similar.

set background=dark
hi clear
if exists("syntax_on")
   syntax reset
endif
let g:colors_name = "adobe"

hi Normal guibg=#a0a087 ctermbg=black

" Cursor
hi Cursor       guibg=Yellow guifg=NONE ctermfg=NONE ctermbg=yellow

" Search
hi Search       guibg=green ctermfg=green

" Fold
hi Folded       guibg=#a0a087

" Split area
hi StatusLine   gui=reverse guibg=white

" Messages
hi ModeMsg      gui=none
hi MoreMsg      gui=reverse
hi Question     gui=NONE guifg=#ffff60 guibg=NONE

" Other
hi Todo         gui=underline guifg=white guibg=NONE cterm=bold,underline ctermbg=NONE
hi NonText      guifg=blue ctermfg=darkblue
hi VisualNOS    gui=underline
hi Title        gui=none

" Diff
hi DiffDelete   gui=none
hi DiffText     gui=none

" Html
hi htmlBoldUnderline gui=underline
hi htmlBold     gui=none
hi htmlBoldItalic gui=none
hi htmlBoldUnderlineItalic gui=underline

" Syntax group
hi Comment      guifg=white gui=italic ctermfg=darkgray
hi Statement    guifg=orange4 gui=none ctermfg=brown
hi Type         guifg=#22229a gui=none ctermfg=lightblue
hi String       guifg=#005522 ctermfg=darkgreen
hi PreProc      guifg=#0066ff ctermfg=darkcyan
hi Special      guifg=purple3 ctermfg=darkmagenta
hi Constant     guifg=red4 ctermfg=darkred
hi Identifier   guifg=red ctermfg=red
hi Function     guifg=darkblue gui=bold ctermfg=lightblue
hi Underlined   guifg=yellow ctermfg=yellow

" OLD ATTEMPTS
"hi Normal guibg=#b0b097 ctermbg=black
"hi String guifg=#0099aa ctermfg=brown
"hi String guifg=#0055dd ctermfg=brown
"hi Special guifg=darkblue ctermfg=none
