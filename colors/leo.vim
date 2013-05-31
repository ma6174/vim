" Vim color file
" Maintainer:		Lorenzo Leonini <vim-theme[a]leonini[.]net>
" Last Change:	2008 Aug 13
" URL:					http://www.leonini.net

" Description:
" A colored, contrasted theme for long programming sessions.
" For 256-colors term (xterm, Eterm, konsole, gnome-terminal, ...)
" Very good with Ruby, C, Lua, PHP, ... (but no language specific settings)

" Note:
" If your term report 8 colors (but is 256 capable), put 'set t_Co=256'
" in your .vimrc

" Tips:
" :verbose hi StatusLine
" Color numbers (0-255) see:
"		http://www.calmar.ws/vim/256-xterm-24bit-rgb-color-chart.html

" 0.5 => 0.6
" Synchro with GUI

" 0.3 => 0.5
" Ligther vertical separation
" Better diff
" Better pmenu
" Uniformisation between status bar, tabs and pmenu
" Added spell hl
" Change search highlight (I don't use it...)
" Folding done
" All in 256 code

if !has("gui_running")
	if &t_Co != 256
		echomsg "err: Please use a 256-colors terminal (so that t_Co=256 could be set)."
		echomsg ""
		finish
	end
endif

let g:colors_name = "leo256"

set background=dark
if v:version > 580
	highlight clear
	if exists("syntax_on")
		syntax reset
	endif
endif

" Normal should come first
hi Normal				cterm=none		ctermfg=255		ctermbg=16		guibg=#000000 guifg=#ffffff
hi CursorLine		cterm=none		ctermbg=16		guibg=#000000
hi DiffAdd			cterm=none		ctermbg=235		guibg=#262626
hi DiffChange		cterm=none		ctermbg=235		guibg=#262626
hi DiffDelete		cterm=none		ctermfg=238		ctermbg=244		guibg=#808080	guifg=#444444
hi DiffText			cterm=bold		ctermfg=255		ctermbg=196		guifg=#ffffff
hi Directory		cterm=none		ctermfg=196
hi ErrorMsg			cterm=none		ctermfg=255		ctermbg=160		guifg=#ffffff
hi FoldColumn		cterm=none		ctermfg=110		ctermbg=16		guibg=#000000
hi SignColumn		cterm=none		ctermbg=16		guibg=#000000
hi Folded				cterm=none		ctermfg=16		ctermbg=110		guifg=#000000	guibg=#87afd7
hi IncSearch		cterm=reverse
hi LineNr				cterm=none		ctermfg=124		guifg=#af0000
hi MoreMsg			cterm=none		ctermfg=40
hi NonText			cterm=none		ctermfg=27
hi Question			cterm=none		ctermfg=40
hi Search				cterm=none		ctermfg=16		ctermbg=248		guifg=#000000	guibg=#a8a8a8
hi SpecialKey		cterm=none		ctermfg=124		guifg=#af0000
hi StatusLine		cterm=none		ctermfg=255		ctermbg=21		guifg=#0000ff	guibg=#ffffff
hi StatusLineNC	cterm=none		ctermfg=252		ctermbg=17		guibg=#d0d0d0 guifg=#00005f
hi Title				cterm=none		ctermfg=33
hi VertSplit		cterm=none		ctermfg=254		ctermbg=16		guibg=#EEEEEE guifg=#000000
hi Visual				cterm=reverse	ctermbg=none
hi VisualNOS		cterm=underline,bold
hi WarningMsg		cterm=none		ctermfg=255		guifg=#ffffff
hi WildMenu			cterm=none		ctermfg=16		ctermbg=11

if v:version >= 700
	" light
	"hi Pmenu				cterm=none	ctermfg=16		ctermbg=252
	"hi PmenuSel			cterm=none	ctermfg=255		ctermbg=21
	"hi PmenuSbar		cterm=none	ctermfg=240		ctermbg=240
  "hi PmenuThumb		cterm=none	ctermfg=255		ctermbg=255

	"dark
	hi Pmenu				cterm=none		ctermfg=255		ctermbg=235		guibg=#262626		guifg=#ffffff
	hi PmenuSel			cterm=none		ctermfg=255		ctermbg=21		guibg=#0000ff	guifg=#ffffff
	hi PmenuSbar		cterm=none		ctermfg=240		ctermbg=240		guibg=#444444
  hi PmenuThumb		cterm=none		ctermfg=255		ctermbg=255		guifg=#ffffff

	hi SpellBad			cterm=none    ctermfg=16		ctermbg=196
	hi SpellCap			cterm=none    ctermfg=16		ctermbg=196
	hi SpellLocal		cterm=none    ctermfg=16		ctermbg=196
	hi SpellRare		cterm=none    ctermfg=16		ctermbg=196
	
	" No need for GUI colors :)
	hi TabLine			cterm=none	ctermfg=252		ctermbg=17
	hi TabLineSel		cterm=none	ctermfg=255		ctermbg=21
	hi TabLineFill	cterm=none	ctermfg=17		ctermbg=17
endif

" syntax highlighting
hi Boolean			cterm=none		ctermfg=135		guifg=#af5fff
hi Character		cterm=none		ctermfg=184
hi Comment			cterm=none		ctermfg=247		guifg=#A5A5A5
hi Constant			cterm=none		ctermfg=226		guifg=#ffff00
hi Conditional	cterm=none		ctermfg=154		guifg=#afff00
hi Define				cterm=bold		ctermfg=27		guifg=#005fff
hi Delimiter		cterm=none		ctermfg=196		guifg=#af0000
hi Exception		cterm=bold		ctermfg=226		guifg=#ffff00
hi Error				cterm=none		ctermfg=255		ctermbg=9			guifg=#ffffff
hi Keyword			cterm=none		ctermfg=159		guifg=#d7af00
hi Function			cterm=none		ctermfg=red		guifg=#ff0000
hi Identifier		cterm=none		ctermfg=27		guifg=#005fff
hi Number				cterm=none		ctermfg=135		guifg=#af5fff
hi Operator			cterm=none		ctermfg=11
hi PreProc			cterm=none		ctermfg=202		guifg=#ff5f00
hi Special			cterm=none		ctermfg=206		ctermbg=234		guifg=#ff5fd7
hi Statement		cterm=none		ctermfg=2			guifg=#00cd00
hi String				cterm=none		ctermfg=224		ctermbg=234		guifg=#ffd7d7	guibg=#1c1c1c
hi Todo         cterm=none		ctermfg=0			ctermbg=11		guifg=#000000 guibg=#ffff00
hi Type					cterm=none		ctermfg=75		guifg=#5fafff

" ADDITIONNAL
hi Repeat		cterm=none		ctermfg=142		guifg=#878700
