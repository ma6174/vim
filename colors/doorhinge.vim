" doorhinge.vim - Vim color file
" Maintainer:	talso <dimset@gmail.com>
" Last Change:	Oct 6, 2006
" Version: 0.3
"
"  +-----+
" [|     |   Rhymes with?
"  |     |                      
"  |    *|
"  |     |
" [|     |
"  +-----+ 
"
" Fugly in console, gvim <3.
" 
" http://vimdoc.sourceforge.net/htmldoc/syntax.html
" http://www.drpeterjones.com/colorcalc/

" #804000 - dark orange
" #FF7700 - better orange
" #FF8040 - bright orange
" #A50000 - dark red

" First remove all existing highlighting.
set background=dark
hi clear
if exists("syntax_on")
  syntax reset
endif

let g:colors_name = "doorhinge"

hi Normal		guifg=#DDDDDD guibg=#405871				ctermbg=DarkGrey ctermfg=White 

hi ErrorMsg		guibg=#A50000 guifg=White	term=standout		ctermbg=DarkRed ctermfg=White 
hi WarningMsg 		guibg=#A50000 guifg=White	term=standout		ctermfg=LightRed 

hi Search		guibg=#FFFFFF guifg=#25345F 	term=reverse		ctermbg=DarkBlue ctermfg=White 
hi IncSearch		guifg=#FF9911 guibg=#804000				ctermfg=darkblue ctermbg=gray

hi StatusLine		guifg=#FFFFFF guibg=#25345F gui=none	term=none	ctermfg=White ctermbg=DarkBlue cterm=none
hi StatusLineNC		guifg=#CCCCCC guibg=#25345F gui=none	term=none	ctermfg=LightGrey ctermbg=DarkBlue  cterm=none
hi VertSplit		guifg=#CCCCCC guibg=#25345F gui=none	term=none	ctermfg=LightGrey ctermbg=DarkBlue  cterm=none
hi LineNr		guifg=#25345F 				term=underline	ctermfg=Blue 

hi Directory 		guifg=#CCCCFF 			term=bold		ctermfg=LightCyan 
hi WildMenu 		guibg=Black guifg=#FF9911 	term=standout		ctermbg=Black ctermfg=Yellow 
hi Folded		guibg=#25345F guifg=#CCCCCC	term=standout		ctermbg=DarkBlue ctermfg=LightGrey
hi FoldColumn 		guibg=#25345F guifg=#FFFFFF	term=standout		ctermbg=DarkBlue ctermfg=LightGrey

hi Cursor		guibg=#BFE4FF guifg=Black
hi lCursor		guibg=#255A70 guifg=Black

hi Visual 		guifg=#E5ECFF guibg=#25345F gui=reverse	term=reverse cterm=reverse  
hi VisualNOS 		gui=underline,bold		term=underline,bold	cterm=underline,bold 

hi DiffText		guibg=Red gui=bold 		term=reverse 		ctermbg=Red cterm=bold  
hi DiffAdd 		guibg=DarkBlue 			term=bold 		ctermbg=DarkBlue 
hi DiffChange 		guibg=DarkMagenta		term=bold		ctermbg=DarkMagenta 
hi DiffDelete 		guifg=Blue guibg=DarkCyan gui=bold	term=bold 	ctermfg=Blue ctermbg=DarkCyan  

hi Comment		guifg=#80C9FF
hi PreProc		guifg=#999999
hi Constant 		guifg=#FF9911			term=underline		ctermfg=Magenta 
hi Special 		guifg=#FF9911 guibg=grey5	term=bold		ctermfg=LightRed
hi Identifier		guifg=#BBBBBB
hi Statement 		guifg=#FFFFFF gui=bold		term=bold		ctermfg=Yellow cterm=bold  
hi Type			guifg=#80C9FF gui=NONE 		term=underline		ctermfg=Blue 
hi Tag 			guifg=DarkGreen			term=bold 		ctermfg=DarkGreen 
hi Title 		guifg=Lightblue			term=bold		ctermfg=LightMagenta  
hi Question 		guifg=#FF9911 gui=bold 		term=standout		ctermfg=LightGreen 
hi SpecialKey 		guifg=Cyan 			term=bold		ctermfg=LightBlue
hi Todo			guifg=orangered guibg=yellow2

hi Ignore 		guifg=grey20 						ctermfg=DarkGrey 
hi ModeMsg 		gui=bold			term=bold		cterm=bold 
hi MoreMsg 		guifg=#FF9911 gui=bold		term=bold		ctermfg=LightGreen  
hi NonText 		guifg=LightBlue guibg=grey30 gui=bold 	term=bold	ctermfg=LightBlue 
" EOF
