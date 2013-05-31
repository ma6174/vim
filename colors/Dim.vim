"
" Restore default colors
hi clear
set background=dark 


if exists("syntax_on")
  syntax reset
endif

let g:colors_name = "Dim"



hi Normal guibg=black guifg=grey75
hi Cursor guibg=grey75
hi NonText guibg=grey10 guifg=yellow4

" Brown / Tan
"hi Statement guifg=wheat4
"hi Statement guifg=grey75 gui=bold
"hi Statement guifg=grey65 gui=bold
"hi Statement guifg=wheat4 gui=bold
"hi Statement guifg=#8B7E66 gui=bold
hi Statement guifg=#9B8E76 gui=bold

" Red
hi Constant guifg=PaleVioletRed3

" Green
"hi Identifier guifg=#00BB00
"hi Identifier guifg=#55BB55
"hi Identifier guifg=#55AA55
hi Identifier guifg=#559955

" Yellow
hi Special guifg=khaki3

" Blue
hi Comment guifg=SkyBlue3

" Purple
hi PreProc guifg=plum3

" Cyan
hi Character guifg=CadetBlue3

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" The default was cyan, which is too bright, but this takes away any
" distinction...
hi SpecialKey guifg=CadetBlue3
hi Directory guifg=SkyBlue3
"
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""


" Orange
"hi Type guifg=orange4 gui=none
"hi Type guifg=orange3 gui=none
"hi Type guifg=#DD9550 gui=none
"hi Type guifg=#CD8550 gui=none
hi Type guifg=#BD7550 gui=none

hi link Function Identifier

"
" Colors not part of the original set:
"
"hi Folded guifg=cyan4 guibg=grey20
"hi Folded guifg=grey90 guibg=grey45
hi Folded guifg=black guibg=grey55

hi Visual gui=reverse guibg=fg guifg=darkolivegreen

"hi Search guifg=black guibg=LightSkyBlue3 gui=none
hi Search guifg=black guibg=LightSkyBlue4 gui=none

hi IncSearch guifg=yellow guibg=LightSkyBlue3 gui=bold
hi WarningMsg guifg=red guibg=GhostWhite gui=bold
hi Error guibg=red3

hi Todo guibg=yellow3
hi Question guifg=green3

