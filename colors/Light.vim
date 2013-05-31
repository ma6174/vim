"A lighter color scheme, with a font that looks good bold.


" Restore default colors
hi clear
set background=light 

if exists("syntax_on")
    syntax reset
endif

let g:colors_name = "Light"


" These are pretty good on grey75:
" yellow4
" rosybrown4
" burlywood4
" DeepPink4
" HotPink4



hi Cursor guibg=IndianRed

hi Normal  guibg=grey78   guifg=black
hi NonText guibg=grey75

hi Visual     guibg=palegreen3 guifg=fg   gui=NONE
hi Search     guibg=LightBlue
hi IncSearch  guibg=yellow2    guifg=fg   gui=none
hi WarningMsg guibg=white      guifg=red3 gui=bold

"
" Brown / Tan
"



"
" Red
"
"hi Function guifg=firebrick gui=NONE

"hi PreProc guifg=MidnightBlue gui=NONE
"hi PreProc guifg=HotPink4 gui=bold
hi PreProc guifg=DeepPink4 gui=none


"
" Green
"
"hi Comment guifg=DarkOrange4 gui=NONE
hi Comment guifg=#005500 gui=none


"
" Yellow
"


"
" Blue
"
hi Identifier guifg=blue3 gui=NONE

"hi Function gui=bold guifg=grey40
hi Function gui=none guifg=MidnightBlue

"hi Statement guifg=black gui=bold 
hi Statement guifg=MidnightBlue gui=bold 


"
" Purple
"

"hi Type guifg=DarkViolet gui=NONE
"hi Type guifg=#5D06AD gui=NONE
hi Type guifg=#6D16BD gui=NONE


"hi Constant guifg=magenta3 gui=none
"hi Constant guifg=#AD00AD gui=none
hi Constant guifg=#BD00BD gui=none


"
" Cyan
"

"hi Constant guifg=SteelBlue gui=NONE
"hi Constant guifg=DodgerBlue4  gui=NONE
hi Special guifg=DodgerBlue4  gui=NONE


"
" Orange
"

"hi String guifg=DarkGreen gui=bold
"hi String  guifg=#005500 gui=none
" the special char color blended too easily w/ the green string.
hi String guifg=darkorange4 gui=none


" Misc


hi! link SpecialKey Identifier
hi! link Directory Identifier






" Swapped these because orange4 and VioletRed4/DeepPink4 look to close right
" next to each other.  But then, I think I prefer green comments... :)  and

"hi Comment guifg=darkorange4 gui=none


";; Ediff faces that preserve some of the syntax highlighting w/in each diff
";; segment. See "M-x,apropos,defface" for settable attributes.
"'(ediff-fine-diff-face-B        ((t (:background "MediumTurquoise"))))
"'(ediff-current-diff-face-B     ((t (:background "Khaki"))))
"'(ediff-even-diff-face-Ancestor ((t (:background "DarkGrey"))))
"'(ediff-even-diff-face-A        ((t (:background "DarkGrey"))))
"'(ediff-even-diff-face-B        ((t (:background "DarkGrey"))))
"'(ediff-odd-diff-face-A         ((t (:background "DarkGrey"))))
"'(ediff-odd-diff-face-Ancestor  ((t (:background "DarkGrey"))))
"'(ediff-odd-diff-face-B         ((t (:background "DarkGrey"))))



















