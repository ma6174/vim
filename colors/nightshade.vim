" Vim color file
" Maintainer:	Dave Turner <turner@ameslab.gov>
" Last Change:	2005 June 2
" modified from the darkblue.vim file of Bohdan Vlasyuk

" NightShade -- My colorizations on a dark background
" NightShade_Print -- Colors to use to print with
" map <F1> :colorscheme nightshade_print<CR> :hardcopy<CR> :colorscheme nightshade<CR>


set bg=dark
hi clear
if exists("syntax_on")
	syntax reset
endif

let colors_name = "nightshade"

hi Normal		guifg=#e0e0e0 guibg=#000000						ctermfg=gray ctermbg=black
hi ErrorMsg		guifg=#ffffff guibg=#287eff						ctermfg=white ctermbg=lightblue
hi Visual		guifg=#8080ff guibg=fg		gui=reverse				ctermfg=lightblue ctermbg=fg cterm=reverse
hi VisualNOS	guifg=#8080ff guibg=fg		gui=reverse,underline	ctermfg=lightblue ctermbg=fg cterm=reverse,underline
hi Todo			guifg=#d14a14 guibg=#1248d1						ctermfg=red	ctermbg=darkblue
hi Search		guifg=#90fff0 guibg=#2050d0						ctermfg=white ctermbg=darkblue cterm=underline term=underline
hi IncSearch	guifg=#b0ffff guibg=#2050d0							ctermfg=darkblue ctermbg=gray

hi SpecialKey		guifg=cyan			ctermfg=darkcyan
hi Directory		guifg=cyan			ctermfg=cyan
hi Title			guifg=magenta gui=none ctermfg=magenta cterm=bold
hi WarningMsg		guifg=red			ctermfg=red
hi WildMenu			guifg=yellow guibg=black ctermfg=yellow ctermbg=black cterm=none term=none
hi ModeMsg			guifg=#22cce2		ctermfg=lightblue
hi MoreMsg			ctermfg=darkgreen	ctermfg=darkgreen
hi Question			guifg=green gui=none ctermfg=green cterm=none
hi NonText			guifg=#0030ff		ctermfg=darkblue

hi StatusLine		guifg=blue guibg=darkgray gui=none		ctermfg=blue ctermbg=gray term=none cterm=none
hi StatusLineNC		guifg=black guibg=darkgray gui=none		ctermfg=black ctermbg=gray term=none cterm=none
hi VertSplit		guifg=black guibg=darkgray gui=none		ctermfg=black ctermbg=gray term=none cterm=none

hi Folded			guifg=#808080 guibg=#000040			ctermfg=darkgrey ctermbg=black cterm=bold term=bold
hi FoldColumn		guifg=#808080 guibg=#000040			ctermfg=darkgrey ctermbg=black cterm=bold term=bold
hi LineNr			guifg=#90f020			ctermfg=green cterm=none

hi DiffAdd			guibg=darkblue	ctermbg=darkblue term=none cterm=none
hi DiffChange		guibg=darkmagenta ctermbg=magenta cterm=none
hi DiffDelete		ctermfg=blue ctermbg=cyan gui=bold guifg=Blue guibg=DarkCyan
hi DiffText			cterm=bold ctermbg=red gui=bold guibg=Red

hi Cursor			guifg=#000020 guibg=#ffaf38 ctermfg=bg ctermbg=brown
hi lCursor			guifg=#ffffff guibg=#000000 ctermfg=bg ctermbg=darkgreen


hi Comment	guifg=yellow guibg=#000050 ctermfg=darkGray
hi Constant	guifg=#ff58b3 gui=bold ctermfg=lightMagenta
hi String	guifg=Orange gui=bold ctermfg=darkRed
hi Special	guifg=Orange gui=none ctermfg=darkRed
hi Identifier	guifg=red gui=none ctermfg=Red
hi Statement	guifg=blue gui=bold ctermfg=Blue
hi PreProc	guifg=green3 gui=none ctermfg=darkGreen
hi type		guifg=purple gui=none ctermfg=darkMagenta
hi Label        guifg=cyan ctermfg=Cyan
hi Operator     guifg=yellow    gui=none ctermfg=Yellow
hi Number       guifg=#ff58b3 gui=bold ctermfg=lightMagenta
hi Function     guifg=green gui=bold ctermfg=Green
hi IO		guifg=red gui=bold ctermfg=Red
hi Communicator		guibg=yellow2 guifg=black gui=bold ctermbg=Green ctermfg=Black
hi UnitHeader	guibg=cyan guifg=black gui=bold ctermfg=Cyan
" hi Macro        guibg=green ctermfg=Green
hi Keyword      guifg=red ctermfg=Red

hi Underlined	cterm=underline term=underline
hi Ignore	guifg=bg ctermfg=bg

hi Tooltip	guibg=red

