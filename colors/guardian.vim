" Vim color file
" Maintainer: Anders Korte
" Last Change: 17 Mar 2005

" Guardian color scheme 1.1

" GUI only. :/

set background=dark
hi clear
syntax reset

" Colors for the User Interface.

hi Cursor      guibg=#cc4455  guifg=white    gui=bold
hi link CursorIM Cursor
hi Normal      guibg=#221100  guifg=white    gui=none
hi NonText     guibg=#445566  guifg=#ffeecc  gui=bold
hi Visual      guibg=#557799  guifg=white    gui=none

hi Linenr      guibg=bg	      guifg=#aaaaaa  gui=none

hi Directory   guibg=bg	      guifg=#337700  gui=none

hi IncSearch   guibg=#0066cc  guifg=white    gui=none
hi link Seach IncSearch

hi SpecialKey  guibg=bg	guifg=fg       gui=none
hi Titled      guibg=bg	guifg=fg       gui=none

hi ErrorMsg    guibg=bg	guifg=#ff0000  gui=bold
hi ModeMsg     guibg=bg	guifg=#ffeecc  gui=none
hi link	 MoreMsg     ModeMsg
hi Question    guibg=bg	guifg=#ccffcc  gui=bold
hi link	 WarningMsg  ErrorMsg

hi StatusLine	  guibg=#ffeecc	 guifg=black	gui=bold
hi StatusLineNC	  guibg=#cc4455	 guifg=white	gui=none
hi VertSplit	  guibg=#cc4455	 guifg=white	gui=none

hi DiffAdd     guibg=#446688  guifg=fg	  gui=none
hi DiffChange  guibg=#558855  guifg=fg	  gui=none
hi DiffDelete  guibg=#884444  guifg=fg	  gui=none
hi DiffText    guibg=#884444  guifg=fg	  gui=bold 

" Colors for Syntax Highlighting.

hi Comment  guibg=#445566  guifg=#dddddd  gui=none

hi Constant    guibg=bg	   guifg=white	  gui=bold
hi String      guibg=bg	   guifg=#ffffcc  gui=italic
hi Character   guibg=bg	   guifg=#ffffcc  gui=bold
hi Number      guibg=bg	   guifg=#bbddff  gui=bold
hi Boolean     guibg=bg	   guifg=#bbddff  gui=none
hi Float       guibg=bg	   guifg=#bbddff  gui=bold

hi Identifier  guibg=bg    guifg=#ffddaa  gui=bold
hi Function    guibg=bg    guifg=#ffddaa  gui=bold
hi Statement   guibg=bg    guifg=#ffffcc  gui=bold

hi Conditional guibg=bg    guifg=#ff6666  gui=bold
hi Repeat      guibg=bg    guifg=#ff9900  gui=bold
hi Label       guibg=bg    guifg=#ffccff  gui=bold
hi Operator    guibg=bg    guifg=#cc9966  gui=bold
hi Keyword     guibg=bg	   guifg=#66ffcc  gui=bold
hi Exception   guibg=bg	   guifg=#66ffcc  gui=bold

hi PreProc	  guibg=bg	 guifg=#ffcc99	gui=bold
hi Include	  guibg=bg	 guifg=#99cc99	gui=bold
hi link Define	  Include
hi link Macro	  Include
hi link PreCondit Include

hi Type		  guibg=bg	 guifg=#ff7788  gui=bold
hi StorageClass	  guibg=bg	 guifg=#99cc99  gui=bold
hi Structure	  guibg=bg	 guifg=#99ff99  gui=bold
hi Typedef	  guibg=bg	 guifg=#99cc99  gui=italic

hi Special	  guibg=bg	 guifg=#bbddff	gui=bold
hi SpecialChar	  guibg=bg	 guifg=#bbddff	gui=bold
hi Tag		  guibg=bg	 guifg=#bbddff	gui=bold
hi Delimiter	  guibg=bg	 guifg=fg	gui=none
hi SpecialComment guibg=#445566	 guifg=#dddddd	gui=italic
hi Debug	  guibg=bg	 guifg=#ff9999	gui=none

hi Underlined guibg=bg guifg=#99ccff gui=underline

hi Title    guibg=#445566  guifg=white	  gui=bold
hi Ignore   guibg=bg	   guifg=#cccccc  gui=italic
hi Error    guibg=#ff0000  guifg=white	  gui=bold
hi Todo	    guibg=#556677  guifg=#ff0000  gui=bold

hi htmlH2 guibg=bg guifg=white gui=bold
hi link htmlH3 htmlH2
hi link htmlH4 htmlH3
hi link htmlH5 htmlH4
hi link htmlH6 htmlH5

" And finally.

let colors_name="Guardian"

