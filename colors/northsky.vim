" Vim color file based on bluegreen
" Maintainer:   Sergey Khorev
" Last Change:  
" URL:			 


" cool help screens
" :he group-name
" :he highlight-groups
" :he cterm-colors

set background=dark
hi clear
if exists("syntax_on")
    syntax reset
endif
let g:colors_name="northsky"

hi Normal	guifg=white guibg=#061A3E

" highlight groups
hi Cursor	guibg=#D74141 guifg=#e3e3e3
hi VertSplit guibg=#C0FFFF guifg=#075554 gui=none
" hi Folded		guibg=#FFC0C0 guifg=black
hi Folded	 guifg=plum1 guibg=#061A3E
hi FoldColumn	guibg=#800080 guifg=tan
hi IncSearch	guifg=bg guibg=cyan gui=bold
hi ModeMsg guifg=#404040 guibg=#C0C0C0
hi MoreMsg guifg=darkturquoise guibg=#188F90
hi NonText guibg=#334C75 guifg=#9FADC5
hi Question	guifg=#F4BB7E
hi Search guibg=fg guifg=bg
hi SpecialKey	guifg=#BF9261
hi StatusLine	guibg=#067C7B guifg=cyan gui=none
hi StatusLineNC	guibg=#004443 guifg=DimGrey gui=none
hi Title	guifg=#8DB8C3
hi Visual gui=bold guifg=black guibg=#C0FFC0
hi WarningMsg	guifg=#F60000 gui=underline

" syntax highlighting groups
hi Comment guifg=DarkGray
" hi Comment guifg=#DABEA2
hi Constant guifg=#72A5E4 gui=bold
hi Number guifg=chartreuse2 gui=bold
" hi Number guifg=turquoise1 gui=bold
hi Identifier	guifg=#ADCBF1
hi Statement guifg=yellow
hi PreProc guifg=#14967C
hi Type	guifg=#FFAE66
hi Special guifg=#EEBABA
hi Ignore	guifg=grey60
hi Todo	guibg=#9C8C84 guifg=#244C0A
hi Label guifg=#ffc0c0

"vim: ts=4
