" Vim color file
" Maintainer:   Hans Fugal <hans@fugal.net>
" Last Change:  $Date: 2003/05/06 16:37:49 $
" URL:		http://hans.fugal.net/vim/colors/desert.vim

" cool help screens
" :he group-name
" :he highlight-groups
" :he cterm-colors

set background=dark
if version > 580
    " no guarantees for version 5.8 and below, but this makes it stop
    " complaining
    hi clear
    if exists("syntax_on")
	syntax reset
    endif
endif
let g:colors_name="asmdev2"

hi Normal	guifg=white guibg=#501808

" highlight groups
hi Cursor	guibg=khaki guifg=slategrey
"hi CursorIM
hi Directory guifg=#f0c000 guibg=#400800
"hi DiffAdd
"hi DiffChange
"hi DiffDelete
"hi DiffText guibg=white
hi ErrorMsg guifg=#f0c000 guibg=#300800
hi VertSplit	guibg=#400800 guifg=#400800 gui=none
hi Folded	guifg=#907050 guibg=#582010
" hi FoldColumn	guibg=grey30 guifg=tan
" hi IncSearch	guifg=slategrey guibg=khaki
hi LineNr guifg=#907050
hi Prompt guibg=white
"hi ModeMsg	guifg=goldenrod guibg=white
hi MoreMsg	guifg=SeaGreen guibg=black
hi NonText	guifg=#400800 guibg=#502818
hi Question	guifg=black
hi Search	guibg=black guifg=wheat
hi SpecialKey	guifg=yellowgreen
hi StatusLine	guibg=#300600 guifg=grey70 gui=none
hi StatusLineNC	guibg=#400800 guifg=grey50 gui=none
hi Title	guifg=indianred guibg=black
hi Visual	gui=none guifg=#400800 guibg=#602818
"hi VisualNOS
hi WarningMsg	guifg=salmon guibg=black
"hi WildMenu
"hi Menu
"hi Scrollbar
"hi Tooltip

" syntax highlighting groups
hi Comment	 guifg=#804838
hi Constant	 guifg=#d0b020
hi Type	 guifg=#a08070
"guibg=#603020
hi Identifier	 guifg=#a08070 gui=italic
"guibg=#603020
hi Statement	 guifg=#a08000 gui=bold 
"guibg=#603020
" hi Statement	 guifg=khaki
hi PreProc	 guifg=indianred
"hi Type		 guifg=darkkhaki
hi Special	 guifg=navajowhite
"hi Underlined
hi Ignore	 guifg=grey40
"hi Error
hi Todo		 guifg=white guibg=#300800 gui=bold

" color terminal definitions
hi SpecialKey	 ctermfg=darkgreen
hi NonText	 cterm=bold ctermfg=darkblue
hi Directory	 ctermfg=darkcyan
hi ErrorMsg	 cterm=bold ctermfg=7 ctermbg=1
hi IncSearch	 cterm=NONE ctermfg=yellow ctermbg=green
hi Search	 cterm=NONE ctermfg=grey ctermbg=blue
hi MoreMsg	 ctermfg=darkgreen
hi ModeMsg	 cterm=NONE ctermfg=brown
hi LineNr	 ctermfg=3
hi Question	 ctermfg=green
hi StatusLine	 cterm=bold,reverse
hi StatusLineNC  cterm=reverse
hi VertSplit	 cterm=reverse
hi Title	 ctermfg=5
hi Visual	 cterm=reverse
hi VisualNOS	 cterm=bold,underline
hi WarningMsg	 ctermfg=1
hi WildMenu	 ctermfg=0 ctermbg=3
hi Folded	 ctermfg=darkgrey ctermbg=NONE
hi FoldColumn	 ctermfg=darkgrey ctermbg=NONE
hi DiffAdd	 ctermbg=4
hi DiffChange	 ctermbg=5
hi DiffDelete	 cterm=bold ctermfg=4 ctermbg=6
hi DiffText	 cterm=bold ctermbg=1
hi Comment	 ctermfg=darkcyan
hi Constant	 ctermfg=brown
hi Special	 ctermfg=5
hi Identifier	 ctermfg=6
hi Statement	 ctermfg=3
hi PreProc	 ctermfg=5
hi Type		 ctermfg=2
hi Underlined	 cterm=underline ctermfg=5
hi Ignore	 cterm=bold ctermfg=7
hi Error	 cterm=bold ctermfg=7 ctermbg=1


"vim: sw=4
