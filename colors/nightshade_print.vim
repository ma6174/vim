" Vim color file
" Maintainer:	Dave Turner <turner@ameslab.gov>
" Last Change:	2005 June 2
" modified from the darkblue.vim file of Bohdan Vlasyuk

" NightShade -- My colorizations on a dark background
" NightShade_Print -- Colors to use for printing
" map <F1> :colorscheme nightshade_print<CR> :hardcopy<CR> :colorscheme nightshade<CR>

set bg=light
hi clear
if exists("syntax_on")
	syntax reset
endif

let colors_name = "nightshade_print"

hi Normal		guifg=#000000 guibg=#ffffff						ctermfg=gray ctermbg=black
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


hi Comment	guifg=black guibg=lightgray
hi String	guifg=Orange gui=bold
hi Special	guifg=Orange gui=bold
hi Identifier	guifg=brown gui=none
hi Statement	guifg=#5555ff gui=bold
hi PreProc	guifg=green3 gui=bold 
hi type		guifg=magenta gui=bold 
hi Label        guifg=cyan gui=bold
hi Operator     guifg=brown gui=bold
hi Number       guifg=#ff88d3 gui=bold
" hi Number       guifg=#ff58b3 gui=bold
hi Constant	guifg=#ff88d3 gui=bold
hi Function     guifg=green gui=bold
hi IO		guifg=red gui=bold
hi Communicator		guibg=yellow guifg=black gui=none
hi UnitHeader	guibg=lightblue guifg=black gui=bold
" hi Macro        guibg=green
hi Keyword      guifg=red

hi Underlined	cterm=underline term=underline
hi Ignore	guifg=bg ctermfg=bg


