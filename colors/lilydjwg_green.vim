" local syntax file - set colors on a per-machine basis:
" vim: tw=0 ts=4 sw=4
" Vim color file
" Version: 1.3
" Maintainer:	lilydjwg <lilydjwg@gmail.com>
" Last Change:	2009 Feb 9

set background=light
hi clear
if exists("syntax_on")
  syntax reset
endif
let g:colors_name = "lilydjwg_绿色"

hi Comment guifg=#686868 guibg=#9bedd1
hi Constant guifg=#10a303 guibg=#9bedd1
hi Cursor gui=bold guifg=#ff68d1 guibg=#00c4ff
hi CursorIM gui=None
hi CursorLine guibg=lightcyan
hi DiffAdd guifg=black guibg=slateblue
hi DiffChange guifg=black guibg=darkgreen
hi DiffDelete gui=bold guifg=black guibg=coral
hi DiffText gui=bold guifg=black guibg=olivedrab
hi Directory guifg=#ff99ff guibg=#66ffcc
hi Error gui=underline guifg=red guibg=darkblue
hi ErrorMsg guifg=orange guibg=darkblue
hi FoldColumn guifg=#b6c2ff guibg=#a4a4ff
hi Folded guifg=#7450ff guibg=#9bc4d1
hi Identifier guifg=#986CFF guibg=#9bedd1
hi Ignore gui=None
hi IncSearch gui=bold,reverse guifg=#33ff1c guibg=#3454ff
hi LineNr guifg=#ff64cb guibg=#9bedd1
hi MatchParen guifg=#342cff guibg=#9aeb95
hi ModeMsg gui=bold guifg=#ffff3c guibg=#9bedd1
hi MoreMsg guifg=yellow
hi NonText gui=bold guifg=#ffff5c guibg=#9cffee
hi Normal guifg=#3454ff guibg=#9bedd1
hi Pmenu guibg=#ff77ff
hi PmenuSel guibg=grey
hi PmenuSbar guibg=darkgray
hi PmenuThumb gui=reverse
hi PreProc guifg=#9b20d1 guibg=#9bedd1
hi Question gui=bold guifg=#006633 guibg=#66ffff
hi Search guifg=#3404ff guibg=yellow
hi SignColumn guifg=cyan guibg=grey
hi Special guifg=magenta
hi SpecialKey guifg=#00AEA0 guibg=#8cedd1
hi SpellBad gui=undercurl
hi SpellCap gui=undercurl
hi SpellLocal gui=undercurl
hi SpellRare gui=undercurl
hi Statement gui=bold guifg=#d86868 guibg=#9bedd1
hi StatusLine gui=reverse guifg=#00c4ff guibg=black
hi StatusLineNC gui=reverse guifg=#a4a4ff guibg=#5f4d0e
hi TabLine guifg=#ffffc8 guibg=#a4a4ff
hi TabLineFill gui=reverse guifg=#9cffee
hi TabLineSel gui=bold,underline guifg=#3488ff guibg=#9bedd1
hi Title gui=bold guifg=#ffff44 guibg=#9bedd1
hi Todo gui=bold,underline guifg=#ff4c4c guibg=#d8ff33
hi Type gui=bold guifg=orange
hi Underlined gui=underline guifg=#0088C5 guibg=#aef0da
hi VertSplit gui=reverse guifg=#00c4ff guibg=blue
hi Visual guifg=#9bedd1 guibg=#a4a4ff
hi VisualNOS gui=bold,underline
hi WarningMsg guifg=cyan guibg=darkblue
hi WildMenu guifg=black guibg=yellow
hi link Boolean Constant
hi link Character Constant
hi link Conditional Statement
hi link CursorColumn CursorLine
hi link Debug Special
hi link Define PreProc
hi link Delimiter Special
hi link Exception Statement
hi link Float Constant
hi link Function Identifier
hi link Include PreProc
hi link Keyword Statement
hi link Label Statement
hi link Macro PreProc
hi link Number Constant
hi link Operator Statement
hi link PreCondit PreProc
hi link Repeat Statement
hi link SpecialChar Special
hi link SpecialComment Special
hi link StorageClass Type
hi link String Constant
hi link Structure Type
hi link Tag Special
hi link Typedef Type
