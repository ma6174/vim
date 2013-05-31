" Vim color file
"
" Version: 1.1
"
" Author: Shawn Biddle <shawn@shawnbiddle.com>
"
" Note: Used the molokai color scheme as a template
" to build off then completely recolored almost
" everything to be a bit more colorful while still
" being quite readable
"

hi clear

set background=dark
if version > 580
    hi clear
    if exists("syntax_on")
        syntax reset
    endif
endif
let g:colors_name="skittles_dark"


hi Boolean guifg=#AE81FF
hi Character guifg=#E6DB74
hi Number guifg=#AE81FF
hi String guifg=#75d142
hi Conditional guifg=#d44d3e gui=bold
hi Constant guifg=#AE81FF gui=bold
hi Cursor guifg=#000000 guibg=#F8F8F0
hi Debug guifg=#BCA3A3 gui=bold
hi Define guifg=#d44d3e gui=bold
hi Delimiter guifg=#8F8F8F
hi DiffAdd guibg=#13354A
hi DiffChange guifg=#89807D guibg=#4C4745
hi DiffDelete guifg=#960050 guibg=#1E0010
hi DiffText guibg=#4C4745 gui=italic,bold

hi Directory guifg=#A6E22E gui=bold
hi Error guifg=#960050 guibg=#1E0010
hi ErrorMsg guifg=#8ac6f2 guibg=#232526 gui=bold
hi Exception guifg=#A6E22E gui=bold
hi Float guifg=#AE81FF
hi FoldColumn guifg=#465457 guibg=#000000
hi Folded guifg=#465457 guibg=#000000
hi Function guifg=#d44d3e

hi Identifier guifg=#ffffff

hi Ignore guifg=#808080 guibg=bg
hi IncSearch guifg=#C4BE89 guibg=#000000

hi Keyword guifg=#8ac6f2 gui=bold
hi Label guifg=#E6DB74 gui=none
hi Macro guifg=#C4BE89 gui=italic
hi SpecialKey guifg=#66D9EF gui=italic


hi MatchParen guifg=#000000 guibg=#FD971F gui=bold
hi ModeMsg guifg=#E6DB74
hi MoreMsg guifg=#E6DB74
hi Operator guifg=#FF9900

" complete menu
hi Pmenu guifg=#66D9EF guibg=#000000
hi PmenuSel guibg=#808080
hi PmenuSbar guibg=#080808
hi PmenuThumb guifg=#66D9EF
 
hi PreCondit guifg=#A6E22E gui=bold
hi PreProc guifg=#A6E22E
hi Question guifg=#66D9EF
hi Repeat guifg=#d44d3e gui=bold
hi Search guifg=#FFFFFF guibg=#455354
" marks column
hi SignColumn guifg=#A6E22E guibg=#232526
hi SpecialChar guifg=#FF9900 gui=bold
hi SpecialComment guifg=#465457 gui=bold
hi Special guifg=#66D9EF guibg=bg gui=italic
hi SpecialKey guifg=#888A85 gui=italic
if has("spell")
    hi SpellBad guisp=#FF0000 gui=undercurl
    hi SpellCap guisp=#7070F0 gui=undercurl
    hi SpellLocal guisp=#70F0F0 gui=undercurl
    hi SpellRare guisp=#FFFFFF gui=undercurl
endif
"hi Statement guifg=#8ac6f2 gui=bold
hi Statement guifg=#d44d3e gui=italic
hi StatusLine guifg=#455354 guibg=fg
hi StatusLineNC guifg=#808080 guibg=#080808
hi StorageClass guifg=#FD971F gui=italic
hi Structure guifg=#66D9EF
hi Tag guifg=#8ac6f2 gui=italic
hi Title guifg=#ef5939
hi Todo guifg=#FFFFFF guibg=bg gui=bold

hi phpDocBlock guifg=#94E1E4 guibg=bg gui=bold,italic,underline

hi Typedef guifg=#66D9EF
hi Type guifg=#66D9EF gui=none
hi Underlined guifg=#808080 gui=underline

hi VertSplit guifg=#808080 guibg=#080808 gui=bold
hi VisualNOS guibg=#403D3D
hi Visual guibg=#403D3D
hi WarningMsg guifg=#FFFFFF guibg=#333333 gui=bold
hi WildMenu guifg=#66D9EF guibg=#121212

hi Normal guifg=#F8F8F2 guibg=#050505
hi Comment guifg=#5D8D8F
hi CursorLine guibg=#121212
hi CursorColumn guibg=#121212
hi LineNr guifg=#FFFFFF guibg=#000000 gui=underline
hi NonText guifg=#BCBCBC guibg=#232526

hi yamlBaseKey  gui=bold,underline
hi yamlTab guibg=#FF0000
hi User1 guifg=#000000 guibg=#84E12E gui=bold

hi clear htmlTagN
hi link htmlTagN Typedef
