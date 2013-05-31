" Vim color file
" @Author: Pascal Vasilii <jabberroid@gmail.com>	

hi clear
if exists("syntax_on")
  syntax reset
endif

let g:colors_name = "silent"
set background=light

hi Cursor           guifg=DarkGrey guibg=grey gui=NONE
hi LineNr           ctermbg=DarkGrey ctermfg=LightGrey gui=bold,italic guifg=DarkGray guibg=#F1FFC1
hi StatusLineNC     ctermbg=white  ctermfg=black guifg=White guibg=DimGray gui=bold,italic
hi StatusLine       ctermbg=white  ctermfg=black guifg=#DDDDDD guibg=#1D343B gui=italic
hi SpecialKey       guifg=orange gui=none
hi Title            guifg=Black   gui=bold 
hi CursorLine       guibg=#fafafa
hi CursorColumn     guibg=#fafafa
hi MatchParen       ctermbg=LightGrey guifg=#141312 guibg=Yellow gui=underline
hi AutoHiGroup      guibg=Yellow 

hi Directory	    ctermbg=White ctermfg=DarkGray gui=bold,italic guifg=DarkGray guibg=#F1FFC1
hi FoldColumn       guifg=Black guibg=#F1FFC1 gui=none 
hi VertSplit        guifg=White guibg=DimGray gui=none 
hi Wildmenu         guifg=Black guibg=White gui=bold 


hi Pmenu            ctermbg=white guibg=#DDDDDD guifg=Black gui=italic
hi PmenuSbar        ctermbg=white guibg=#DDDDDD guifg=fg gui=italic
hi PmenuSel         ctermbg=Blue  ctermfg=white  guibg=#F1FFC1 guifg=Black gui=italic
hi PmenuThumb       ctermbg=white ctermfg=white guibg=#DDDDDD guifg=fg gui=none

hi IncSearch        ctermbg=White     ctermfg=Yellow  gui=none guifg=White guibg=Black
hi Search           ctermbg=DarkBlue ctermfg=white   gui=none guifg=Black guibg=Yellow

hi Normal	        ctermfg=DarkGrey guifg=#141312 guibg=White 
hi Visual	        ctermfg=Blue guibg=#4485FF guifg=white gui=bold
hi Comment	        ctermfg=Brown guifg=#888786	gui=italic
hi PerlPOD	        ctermfg=Brown guifg=#B86A18	gui=NONE
hi Constant	        ctermfg=DarkGrey guifg=#141312 gui=bold
hi Charachter	    ctermfg=Yellow guifg=#644A9B	gui=NONE
hi String           ctermfg=DarkRed guifg=#BF0303	gui=italic
hi Number	        ctermfg=DarkRed  guifg=#B07E00 gui=NONE
hi Boolean	        ctermfg=DarkBlue guifg=#B07E00	gui=NONE
hi Special	        ctermfg=DarkRed	guifg=#9C0D0D gui=NONE
hi Define	        ctermfg=DarkGreen guifg=#006E26 gui=bold

" vars
hi Identifier 	    ctermfg=DarkBlue guifg=#0057AE gui=NONE
hi Exception 	    ctermfg=DarkBlue guifg=black gui=bold
hi Statement 	    ctermfg=DarkBlue guifg=#B07E00 gui=NONE
"hi Label 	        ctermfg=DarkBlue guifg=#B07E00 gui=NONE
hi Keyword 	        ctermfg=DarkBlue guifg=#141312 gui=NONE
hi PreProc	        ctermfg=DarkBlue guifg=#141312 gui=bold
hi Type		        ctermfg=DarkGrey guifg=black gui=NONE
hi Function	        ctermfg=DarkBlue guifg=#B07E00 gui=NONE
hi Repeat	        ctermfg=DarkBlue guifg=#B07E00 gui=bold
hi Operator	        ctermfg=DarkBlue guifg=#0057AE gui=NONE
hi Ignore	        ctermfg=DarkBlue guifg=bg
hi Folded           ctermbg=Grey ctermfg=White guibg=#F1FFC1 guifg=#101010 gui=italic
hi Error	        term=reverse ctermbg=Red ctermfg=White guibg=#D80000 guifg=#FFD1CC gui=NONE
hi Todo		        term=standout ctermbg=Yellow ctermfg=DarkGrey guifg=Grey guibg=#AD5500 gui=NONE
hi Done		        term=standout ctermbg=Gray ctermfg=White guifg=#CCEEFF guibg=Gray gui=NONE

hi SpellErrors      ctermfg=DarkRed guifg=#9C0D0D gui=NONE

hi MoreMsg          guifg=black gui=NONE
hi ModeMsg          guifg=black gui=NONE
hi Title            gui=bold
hi NonText          ctermfg=black ctermbg=white guibg=#FFFFFF guifg=black gui=NONE
hi DiffAdd          ctermfg=white ctermbg=blue guifg=NONE guibg=#CCFFCC gui=NONE
hi DiffDelete       ctermfg=red  ctermbg=white guifg=NONE guibg=#FFCCCC gui=NONE
hi DiffChange       ctermfg=white ctermbg=red guifg=NONE guibg=#F1FFC1 gui=NONE
hi DiffText         ctermfg=black ctermbg=white guibg=#ffffff guifg=NONE gui=NONE

hi Question         guifg=black gui=bold
hi link String	Constant 
hi link Character	Constant
hi link Number		Constant
hi link Boolean	Constant
hi link Float		Number
hi Conditional	ctermfg=DarkYellow guifg=#B07E00 gui=NONE
hi Include		ctermfg=DarkGrey guifg=#141312 gui=bold
hi link Structure	Define
hi link Macro		PreProc
hi link PreCondit	PreProc
hi link StorageClass	Type
hi link Structure	Type
hi link Typedef		Type
hi link Tag		Special
hi SpecialChar	ctermfg=DarkGreen guifg=#141312 gui=bold
hi link Delimiter	Normal
hi link SpecialComment 	Special
hi link Debug		Special

