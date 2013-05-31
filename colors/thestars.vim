" Vim Color File
" Maintainer: Michael Wiseman (thestarslookdown at gmail dot com)
" Last Change: August 11, 2005

" Color Help Screens
" h cterm-colors
" h group-name
" h highlight-groups

set bg=dark
hi clear
if exists("syntax_on")
    syntax reset
endif

let colors_name = "thestars"

"------------------------------------------------------------------------------
" Highlight Groups
"------------------------------------------------------------------------------

" Cursors
hi Cursor guibg=white guifg=black gui=bold
hi lCursor guifg=white guifg=black gui=bold

" Directory
hi Directory guibg=black guifg=#9BC4E2

" Diff
hi DiffAdd guibg=white guifg=blue
hi DiffChange guibg=white guifg=darkred
hi DiffDelete guibg=white guifg=red gui=bold
hi DiffText guibg=white guifg=green gui=italic

" Error Message
hi ErrorMsg guibg=black guifg=red

" Vertical Split
hi VertSplit guibg=#666666 guifg=#F5F5F5

" Folding
hi Folded guibg=gainsboro guifg=#666666
hi FoldColumn guibg=gainsboro guifg=#666666

" Sign Column
hi SignColumn guibg=black guifg=red

" Incremental Search
hi IncSearch guibg=gainsboro guifg=#666666

" Line Number
hi LineNr guibg=gainsboro guifg=#666666 gui=bold

" Mode Message
hi ModeMsg guibg=black guifg=white

" More Prompt
hi MoreMsg guibg=black guifg=#F5F5F5

" Nontext
hi NonText guibg=black guifg=white

" Normal Text
hi Normal guibg=black guifg=white

" Question
hi Question guibg=black guifg=darkgreen gui=bold

" Search
hi Search guibg=#666666 guifg=gainsboro

" Special Key
hi SpecialKey guibg=black guifg=#337147

" Status Line
hi StatusLine guibg=#666666 guifg=#F5F5F5
hi StatusLineNC guibg=#333333 guifg=#666666

" Title
hi Title guifg=black guifg=white gui=bold

" Visual
hi Visual guibg=#DAF4F0 guifg=#666666
hi VisualNOS guibg=#DAF4F0 guifg=#666666 gui=italic

" Warning Message
hi WarningMsg guibg=black guifg=red

" Wild Menu
hi WildMenu guibg=white guifg=black gui=bold

"------------------------------------------------------------------------------
" Group Name
"------------------------------------------------------------------------------

" Comments
hi Comment guibg=black guifg=#FDF8FF gui=italic

" Constants
hi Constant guibg=black guifg=#CC1100
" hi String guibg=black guifg=#337147
" hi Character guibg=black guifg=#337147
" hi Number guibg=black guifg=#C6C3B5
" hi Boolean guibg=black guifg=#8C1717
" hi Float guibg=black guifg=#C6C3B5

" Identifier
hi Identifier guibg=black guifg=#FF9955
" hi Function guibg=black guifg=#4682B4

" Statement
hi Statement guibg=black guifg=#FCD59C
" hi Conditional guibg=black guifg=#D98719
" hi Repeat guibg=black guifg=#D98719
" hi Label guibg=black guifg=white
" hi Operator guibg=black guifg=white
" hi Keyword guibg=black guifg=white
" hi Exception guibg=black guifg=#D98719

" PreProc
hi PreProc guibg=black guifg=blue
" hi Include guibg=black guifg=#D98719
" hi Define guibg=black guifg=#D98719
" hi Macro guibg=black guifg=#D98719
" hi PreCondit guibg=black guifg=#D98719
 
" Type
hi Type guibg=black guifg=darkgreen
" hi StorageClass guibg=black guifg=white
" hi Structure guibg=black guifg=white
" hi Typedef guibg=black guifg=white

" Special
hi Special guibg=black guifg=#87CEFA
"hi SpecialChar guibg=black guifg=orange
"hi Tag guibg=black guifg=orange
"hi Delimiter guibg=black guifg=orange
"hi SpecialComment guibg=black guifg=#96C8A2
"hi Debug guibg=black guifg=orange

" Underlined
hi Underlined guibg=darkgray guifg=#00FF40 gui=underline

"Ignore
hi Ignore guibg=black guifg=black

" Error
hi Error guibg=red guifg=white

" Todo
hi Todo  guibg=black guifg=blue
