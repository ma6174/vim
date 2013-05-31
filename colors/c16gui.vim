" Vim color file
" Maintainer:	Hideyuki <e27874_gmail_com>
" Last Change:	2007 Feb 12

" This color scheme uses a black or a white background.

" First remove all existing highlighting.
hi clear
if exists("syntax_on")
  syntax reset
endif

let colors_name = "c16gui"

if &background == "light"
  hi Normal	guibg=#ffffff	guifg=#000000
else
  hi Normal	guibg=#000000	guifg=#ffffff
endif

" Groups used in the 'highlight' and 'guicursor' options default value.
hi ErrorMsg	guibg=#ff0000	guifg=#ffffff	gui=NONE
hi IncSearch	guibg=NONE	guifg=NONE	gui=reverse
hi ModeMsg	guibg=NONE	guifg=NONE	gui=bold
hi NonText	guibg=NONE	guifg=#0000ff	gui=bold
hi StatusLine	guibg=NONE	guifg=NONE	gui=reverse,bold
hi StatusLineNC	guibg=NONE	guifg=NONE	gui=reverse
hi VertSplit	guibg=NONE	guifg=NONE	gui=reverse
hi VisualNOS	guibg=NONE	guifg=NONE	gui=underline,bold
hi DiffText	guibg=#ff0000	guifg=NONE	gui=bold
hi PmenuThumb	guibg=NONE	guifg=NONE	gui=reverse
hi PmenuSbar	guibg=#c0c0c0	guifg=NONE	gui=NONE
hi TabLineSel	guibg=NONE	guifg=NONE	gui=bold
hi TabLineFill	guibg=NONE	guifg=NONE	gui=reverse
hi Cursor	guibg=fg	guifg=bg	gui=NONE
hi lCursor	guibg=fg	guifg=bg	gui=NONE
if has('multi_byte_ime')
  hi CursorIM	guibg=fg	guifg=bg	gui=NONE
endif
if &background == "light"
  hi Directory	guibg=NONE	guifg=#0000ff	gui=NONE
  hi LineNr	guibg=NONE	guifg=#800000	gui=NONE
  hi MoreMsg	guibg=NONE	guifg=#008000	gui=bold
  hi Question	guibg=NONE	guifg=#008000	gui=bold
  hi Search	guibg=#ffff00	guifg=NONE	gui=NONE
  hi SpellBad	guibg=NONE	guifg=NONE	gui=undercurl	guisp=#ff0000
  hi SpellCap	guibg=NONE	guifg=NONE	gui=undercurl	guisp=#0000ff
  hi SpellRare	guibg=NONE	guifg=NONE	gui=undercurl	guisp=#ff00ff
  hi SpellLocal	guibg=NONE	guifg=NONE	gui=undercurl	guisp=#008080
  hi Pmenu	guibg=#ff00ff	guifg=NONE	gui=NONE
  hi PmenuSel	guibg=#c0c0c0	guifg=NONE	gui=NONE
  hi SpecialKey	guibg=NONE	guifg=#0000ff	gui=NONE
  hi Title	guibg=NONE	guifg=#ff00ff	gui=bold
  hi WarningMsg	guibg=NONE	guifg=#ff0000	gui=NONE
  hi WildMenu	guibg=#ffff00	guifg=#000000	gui=NONE
  hi Folded	guibg=#c0c0c0	guifg=#000080	gui=NONE
  hi FoldColumn	guibg=#808080	guifg=#000080	gui=NONE
  hi SignColumn	guibg=#808080	guifg=#000080	gui=NONE
  hi Visual	guibg=#c0c0c0	guifg=NONE	gui=NONE
  hi DiffAdd	guibg=#00ff00	guifg=NONE	gui=NONE
  hi DiffChange	guibg=#ff00ff	guifg=NONE	gui=NONE
  hi DiffDelete	guibg=#00ffff	guifg=#0000ff	gui=bold
  hi TabLine	guibg=#c0c0c0	guifg=NONE	gui=underline
  hi CursorColumn	guibg=#c0c0c0	guifg=NONE	gui=NONE
  hi CursorLine	guibg=#c0c0c0	guifg=NONE	gui=NONE
  hi MatchParen	guibg=#00ffff	guifg=NONE	gui=NONE
else
  hi Directory	guibg=NONE	guifg=#00ffff	gui=NONE
  hi LineNr	guibg=NONE	guifg=#ffff00	gui=NONE
  hi MoreMsg	guibg=NONE	guifg=#008000	gui=bold
  hi Question	guibg=NONE	guifg=#00ff00	gui=bold
  hi Search	guibg=#ffff00	guifg=#000000	gui=NONE
  hi SpecialKey	guibg=NONE	guifg=#00ffff	gui=NONE
  hi SpellBad	guibg=NONE	guifg=NONE	gui=undercurl	guisp=#ff0000
  hi SpellCap	guibg=NONE	guifg=NONE	gui=undercurl	guisp=#0000ff
  hi SpellRare	guibg=NONE	guifg=NONE	gui=undercurl	guisp=#ff00ff
  hi SpellLocal	guibg=NONE	guifg=NONE	gui=undercurl	guisp=#00ffff
  hi Pmenu	guibg=#ff00ff	guifg=NONE	gui=NONE
  hi PmenuSel	guibg=#808080	guifg=NONE	gui=NONE
  hi Title	guibg=NONE	guifg=#ff00ff	gui=bold
  hi WarningMsg	guibg=NONE	guifg=#ff0000	gui=NONE
  hi WildMenu	guibg=#ffff00	guifg=#000000	gui=NONE
  hi Folded	guibg=#808080	guifg=#00ffff	gui=NONE
  hi FoldColumn	guibg=#c0c0c0	guifg=#00ffff	gui=NONE
  hi SignColumn	guibg=#c0c0c0	guifg=#00ffff	gui=NONE
  hi Visual	guibg=#808080	guifg=NONE	gui=NONE
  hi DiffAdd	guibg=#000080	guifg=NONE	gui=NONE
  hi DiffChange	guibg=#800080	guifg=NONE	gui=NONE
  hi DiffDelete	guibg=#008080	guifg=#0000ff	gui=bold
  hi TabLine	guibg=#808080	guifg=NONE	gui=underline
  hi CursorColumn	guibg=#808080	guifg=NONE	gui=NONE
  hi CursorLine	guibg=#808080	guifg=NONE	gui=NONE
  hi MatchParen	guibg=#008080	guifg=NONE	gui=NONE
endif

" Colors for syntax highlighting
hi Error	guibg=#ff0000	guifg=#ffffff	gui=NONE
hi Todo		guibg=#ffff00	guifg=#0000ff	gui=NONE
if &background == "light"
  hi Comment	guibg=NONE	guifg=#0000ff	gui=NONE
  hi Constant	guibg=NONE	guifg=#ff00ff	gui=NONE
  hi Special	guibg=NONE	guifg=#000080	gui=NONE
  hi Identifier	guibg=NONE	guifg=#008080	gui=NONE
  hi Statement	guibg=NONE	guifg=#800000	gui=bold
  hi PreProc	guibg=NONE	guifg=#800080	gui=NONE
  hi Type	guibg=NONE	guifg=#008000	gui=bold
  hi Underlined	guibg=NONE	guifg=#000080	gui=underline
  hi Ignore	guibg=NONE	guifg=bg	gui=NONE
else
  hi Comment	guibg=NONE	guifg=#008080	gui=NONE
  hi Constant	guibg=NONE	guifg=#ff0000	gui=NONE
  hi Special	guibg=NONE	guifg=#808000	gui=NONE
  hi Identifier	guibg=NONE	guifg=#00ffff	gui=NONE
  hi Statement	guibg=NONE	guifg=#ffff00	gui=bold
  hi PreProc	guibg=NONE	guifg=#ff00ff	gui=NONE
  hi Type	guibg=NONE	guifg=#00ff00	gui=bold
  hi Underlined	guibg=NONE	guifg=#008080	gui=underline
  hi Ignore	guibg=NONE	guifg=bg	gui=NONE
endif

" vim: sw=2 ts=8
