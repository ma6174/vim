"
" A color scheme that uses the colors from "Dark", but the arrangement of
" "Light".
"


" Restore default colors
hi clear
set background=dark

if exists("syntax_on")
    syntax reset
endif

let g:colors_name = "Dark2"


hi Cursor guibg=IndianRed

hi Normal  guibg=Black   guifg=GhostWhite
hi NonText guibg=grey10  guifg=yellow3
hi Folded guifg=grey90 guibg=grey45




"
" Brown / Tan
"
hi Statement  guifg=tan



"
" Red
"
hi PreProc guifg=#FF7070   gui=none
hi Error guibg=red3
hi WarningMsg guifg=red guibg=GhostWhite gui=bold


"
" Green
"
hi Comment guifg=#80CC80 gui=none
hi Visual gui=reverse guibg=fg guifg=darkolivegreen


"
" Yellow
"
hi Special    guifg=#DDDD00 gui=none


"
" Blue
"
hi Identifier guifg=SkyBlue gui=none
hi Search guibg=LightSkyBlue3 guifg=black gui=none
"hi IncSearch guibg=LightSkyBlue3 guifg=yellow gui=bold
hi IncSearch guibg=blue guifg=yellow gui=bold

hi link Function Identifier


"
" Purple
"

hi Type guifg=LightMagenta gui=none


"
" Cyan
"



"
" Orange
"
hi String guifg=orange2      gui=none


"
" Misc
"
hi! link SpecialKey Identifier
hi! link Directory Identifier


