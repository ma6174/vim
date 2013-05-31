
" It's based on:
runtime colors/Dim.vim

let g:colors_name = "DimGreen2"

hi Normal guibg=#001800 guifg=#99aa99
hi Normal guibg=black guifg=ForestGreen
hi Normal guifg=DarkSeaGreen4
hi Normal guifg=#448844
"hi Normal guifg=khaki4
hi NonText guibg=#000800

" SeaGreen4
" aquamarine4
" green4
" khaki4
" yellow4

hi Cursor guibg=green4
hi NonText guibg=grey10 guifg=yellow4

hi Statement guifg=ForestGreen gui=bold
hi Statement guifg=DarkOliveGreen4 gui=bold
"hi Statement guifg=khaki4 gui=bold
hi Constant guifg=OliveDrab
hi Identifier guifg=#46AD8A
hi Identifier guifg=ForestGreen
"hi Identifier guifg=aquamarine4
hi Special guifg=PaleGreen3
hi Comment guifg=DarkSeaGreen4
hi Comment guifg=SkyBlue4
hi Comment guifg=DarkSlateGray4
"hi Comment guibg=black guifg=ForestGreen
hi PreProc guifg=wheat4

hi Character guifg=CadetBlue3
hi Character guifg=CadetBlue4
hi SpecialKey guifg=CadetBlue3
hi SpecialKey guifg=CadetBlue4
hi Directory guifg=SkyBlue3
hi Directory guifg=SkyBlue4

hi Type guifg=#BD7550 gui=none
hi Type guifg=#9D7530 gui=none


hi link Function Identifier




"
" Colors not part of the original set:
"
hi Folded guifg=black guibg=grey55

hi Visual gui=reverse guibg=fg guifg=darkolivegreen

hi Search guifg=black guibg=LightSkyBlue4 gui=none

hi IncSearch guifg=yellow guibg=LightSkyBlue3 gui=bold
hi WarningMsg guifg=red guibg=GhostWhite gui=bold
hi Error guibg=red3

