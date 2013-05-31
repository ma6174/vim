" xterm16 color scheme file
" Maintainer:	Gautam Iyer <gautam@math.uchicago.edu>
" Created:	Thu 16 Oct 2003 06:17:47 PM CDT
" Modified:	Fri 14 Nov 2003 01:33:15 PM CST
"
" Sets colors for a 16 color terminal. Can be used with 8 color terminals
" provided VIM is configured to set the bold attribute for higher colors.
" Defines GUI colors to be identical to the terminal colors

set bg=dark
hi clear

if exists("syntax_on")
    syntax reset
endif

let colors_name = 'xterm16'

" Set cterm colors. Some are set here even though they are equal to their
" default settings because the GUI settings need to be modified

hi normal	cterm=none	ctermfg=grey		ctermbg=black

hi cursor	cterm=none	ctermfg=black		ctermbg=green
hi diffadd	cterm=none	ctermfg=darkblue	ctermbg=darkgreen
hi diffchange	cterm=none	ctermfg=black		ctermbg=darkyellow
hi diffdelete	cterm=none	ctermfg=darkblue	ctermbg=none
hi difftext	cterm=none	ctermfg=darkred		ctermbg=darkyellow
hi foldcolumn	cterm=none	ctermfg=yellow		ctermbg=darkblue
hi folded	cterm=none	ctermfg=yellow		ctermbg=darkblue
hi incsearch	cterm=none	ctermfg=grey		ctermbg=darkblue
hi moremsg	cterm=bold	ctermfg=green		ctermbg=none
hi nontext	cterm=none	ctermfg=blue		ctermbg=none
hi search	cterm=none	ctermfg=darkblue	ctermbg=darkcyan
hi specialkey	cterm=none	ctermfg=blue		ctermbg=none
hi statusline	cterm=none	ctermfg=darkblue	ctermbg=grey
hi statuslinenc	cterm=reverse	ctermfg=none		ctermbg=none
hi title	cterm=none	ctermfg=magenta		ctermbg=none
hi visual	cterm=none	ctermfg=none		ctermbg=darkblue
hi visualnos	cterm=none	ctermfg=none		ctermbg=darkgrey
hi warningmsg	cterm=bold	ctermfg=red		ctermbg=none

hi comment	cterm=none	ctermfg=darkred		ctermbg=none
hi constant	cterm=none	ctermfg=darkyellow	ctermbg=none
hi error	cterm=none	ctermfg=white		ctermbg=red
hi identifier	cterm=none	ctermfg=darkcyan	ctermbg=none
hi ignore	cterm=none	ctermfg=darkgrey	ctermbg=none
hi preproc	cterm=none	ctermfg=blue		ctermbg=none
hi special	cterm=none	ctermfg=darkgreen	ctermbg=none
hi statement	cterm=none	ctermfg=cyan 		ctermbg=none
hi todo		cterm=none	ctermfg=black		ctermbg=yellow
hi type		cterm=none	ctermfg=green		ctermbg=none
hi underlined	cterm=none	ctermfg=darkmagenta	ctermbg=none

" Define GUI colors to be exactly the same as xterm colors. To change any
" paticular color, set the variable "g:colorname" to be that color (before you
" load this color scheme.)

let s:none		= 'NONE'
let s:black		= exists("g:black") ? g:black :		    '#000000'
let s:darkred		= exists("g:darkred") ? g:darkred :	    '#CD0000'
let s:darkgreen		= exists("g:darkgreen") ? g:darkgreen :	    '#00CD00'
let s:darkyellow	= exists("g:darkyellow") ? g:darkyellow :   '#CDCD00'
let s:darkblue		= exists("g:darkblue") ? g:darkblue : 	    '#0000FF'
let s:darkmagenta	= exists("g:darkmagenta") ? g:darkmagenta : '#CD00CD'
let s:darkcyan		= exists("g:darkcyan") ? g:darkcyan :	    '#00CDCD'
let s:grey		= exists("g:grey") ? g:grey :		    '#C0C0C0'
let s:darkgrey		= exists("g:darkgrey") ? g:darkgrey :	    '#808080'
let s:red		= exists("g:red") ? g:red :		    '#FF0000'
let s:green		= exists("g:green") ? g:green :		    '#00FF00'
let s:yellow		= exists("g:yellow") ? g:yellow :	    '#FFFF00'
let s:blue		= exists("g:blue") ? g:blue :		    '#0080FF'
let s:magenta		= exists("g:magenta") ? g:magenta :	    '#FF00FF'
let s:cyan		= exists("g:cyan") ? g:cyan :		    '#00FFFF'
let s:white		= exists("g:white") ? g:white :		    '#FFFFFF'

" Set the hilight groups for GUI

exec "hi normal	      gui=none	guifg=".s:grey	"guibg=".s:black

exec "hi cursor	      gui=bold	guifg=".s:black		"guibg=".s:green
exec "hi diffadd      gui=none	guifg=".s:darkblue	"guibg=".s:darkgreen
exec "hi diffchange   gui=none	guifg=".s:black		"guibg=".s:darkyellow
exec "hi diffdelete   gui=none	guifg=".s:darkblue	"guibg=".s:none
exec "hi difftext     gui=none	guifg=".s:darkred	"guibg=".s:darkyellow
exec "hi foldcolumn   gui=none	guifg=".s:yellow	"guibg=".s:darkblue
exec "hi folded	      gui=none	guifg=".s:yellow	"guibg=".s:darkblue
exec "hi incsearch    gui=none	guifg=".s:grey		"guibg=".s:darkblue
exec "hi moremsg      gui=bold	guifg=".s:green		"guibg=".s:none
exec "hi nontext      gui=none	guifg=".s:blue		"guibg=".s:none
exec "hi search	      gui=none	guifg=".s:darkblue	"guibg=".s:darkcyan
exec "hi specialkey   gui=none	guifg=".s:blue		"guibg=".s:none
exec "hi statusline   gui=none	guifg=".s:darkblue	"guibg=".s:grey
exec "hi statuslinenc gui=none	guifg=".s:black		"guibg=".s:grey
exec "hi title	      gui=none	guifg=".s:magenta	"guibg=".s:none
exec "hi visual       gui=none	guifg=".s:none		"guibg=".s:darkblue
exec "hi visualnos    gui=none	guifg=".s:none		"guibg=".s:darkgrey
exec "hi warningmsg   gui=bold	guifg=".s:red		"guibg=".s:none

exec "hi comment      gui=none	guifg=".s:darkred	"guibg=".s:none
exec "hi constant     gui=none	guifg=".s:darkyellow	"guibg=".s:none
exec "hi error	      gui=none	guifg=".s:white		"guibg=".s:red
exec "hi identifier   gui=none	guifg=".s:darkcyan	"guibg=".s:none
exec "hi ignore       gui=none	guifg=".s:darkgrey	"guibg=".s:none
exec "hi preproc      gui=none	guifg=".s:blue		"guibg=".s:none
exec "hi special      gui=none	guifg=".s:darkgreen	"guibg=".s:none
exec "hi statement    gui=none	guifg=".s:cyan 		"guibg=".s:none
exec "hi todo	      gui=none	guifg=".s:black		"guibg=".s:yellow
exec "hi type	      gui=none	guifg=".s:green		"guibg=".s:none
exec "hi underlined   gui=none	guifg=".s:darkmagenta	"guibg=".s:none

" Html groups use cterm attributes (which SUCK), so we change them here. The
" GUI attributes are OK, and are unchanged. If you do not want your precious
" html groups touched, set the variable "xterm16_NoHtmlColors" in your .vimrc
"
" If html colors don't work correctly, set the variable "html_no_rendering"

if !exists("g:xterm16_NoHtmlColors")
    hi htmlBold cterm=none gui=bold ctermfg=white ctermbg=none
    hi htmlItalic cterm=none gui=italic ctermfg=yellow  ctermbg=none
    hi htmlUnderline cterm=none gui=underline ctermfg=darkmagenta ctermbg=none
    hi htmlBoldItalic  cterm=bold gui=bold,italic ctermfg=white  ctermbg=none
    hi htmlBoldUnderline cterm=bold gui=bold,underline ctermfg=white  ctermbg=none
    hi htmlUnderlineItalic cterm=bold gui=underline,italic ctermfg=white ctermbg=none
    hi htmlBoldUnderlineItalic cterm=bold gui=bold,italic,underline ctermfg=white ctermbg=none

    hi! link htmlLink			preproc
endif

" On a linux console, the darkblue (preproc) is unreadble so we remap it. To
" disable this feature, set the variable "xterm16_NoRemap" in your .vimrc
"
" If this color gives you trouble on other terminals, and you want it changed
" elsewhere too set the variable "xterm16_TermRegexp" to a regexp matching all
" troublesome terminals.

if !exists("g:xterm16_NoRemap") && &term =~# (exists("g:xterm16_TermRegexp") ? xterm16_TermRegexp : "linux")
    hi! link preproc		underlined
endif
