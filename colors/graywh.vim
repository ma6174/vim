" Vim color file
" Maintainer:   Will Gray <graywh@gmail.com>
" GetLatestVimScripts: xxxx 1 :AutoInstall: graywh.vim
"
" For best results on 88/256-color terminals, I recommend CSApprox.vim by
" godlygeek.

" Favorite colors {{{1
" I prefer to use a terminal with color levels of [00, 33, 66, 99, CC, FF]
" and have used color codes to reflect that.
"                Light                           Dark
"       Black    333333 236  8   1E1E1E 234      000000  16 0
"       Red      FFCCCC 224      FF6666 210  9   CC0000 160 1
"       Green    CCFFCC 194      66FF66 120 10   00CC00  40 2
"       Yellow   FFFFCC 230      FFFF66 228 11   CCCC00 184 3
"       Blue     99CCFF 153      6699FF 111 12   3366CC  68 4
"       Magenta  FFCCFF 225      FF66FF 213 13   CC00CC 164 5
"       Cyan     CCFFFF 195      66FFFF 123 14   00CCCC  44 6
"       Gray     FFFFFF 231 15                   CCCCCC 251 7
" }}}1

" First remove all existing highlighting.
set background=dark
hi clear
if exists("syntax_on")
  syntax reset
endif

let colors_name = "graywh"

" Common {{{1
" Links {{{2
hi link Character String

" For GUI {{{1
hi Normal               guifg=#CCCCCC   guibg=#1E1E1E
" Vim {{{2
hi SpecialKey           guifg=#515151   guibg=bg        gui=none
hi NonText              guifg=#66FFFF   guibg=#282828   gui=none
hi Directory            guifg=#009999
hi ErrorMsg             guifg=#CC0000   guibg=bg
hi IncSearch                                            gui=reverse
hi Search                               guibg=#FFFF00
hi MoreMsg              guifg=#339966                   gui=bold
hi ModeMsg                                              gui=bold
hi LineNr               guifg=#CCCC99   guibg=#282828
hi Question             guifg=#33FF33                   gui=bold
hi StatusLine                                           gui=reverse,bold
hi StatusLineNC                                         gui=reverse
hi VertSplit                                            gui=reverse
hi Title                guifg=#FF66FF                   gui=bold
hi Visual                               guibg=bg        gui=reverse
hi VisualNOS                                            gui=bold,underline
hi WarningMsg           guifg=#CCCC00
hi WildMenu             guifg=bg        guibg=#CCCC00
hi Folded               guifg=#FFCCFF   guibg=#474747   gui=italic
hi FoldColumn           guifg=#66FFFF   guibg=#474747
hi DiffAdd                              guibg=#143314
hi DiffChange                           guibg=#141414
hi DiffDelete           guifg=fg        guibg=#331414   gui=none
hi DiffText                             guibg=#333314   gui=none
hi SignColumn           guifg=#FFFF66   guibg=#474747
if version >= 700
  hi SpellBad                                           gui=undercurl           guisp=#FF0000
  hi SpellCap                                           gui=undercurl           guisp=#0000FF
  hi SpellRare                                          gui=undercurl           guisp=#FF00FF
  hi SpellLocal                                         gui=undercurl           guisp=#00FFFF
endif
hi Pmenu                guifg=fg        guibg=#CC66CC
hi PmenuSel             guifg=fg        guibg=#666666
hi PmenuSbar            guifg=fg        guibg=#666666
hi PmenuThumb                                           gui=reverse
hi TabLine              guifg=bg        guibg=fg        gui=none
hi TabLineSel           guifg=fg        guibg=bg        gui=bold
hi TabLineFill          guifg=fg        guibg=bg        gui=reverse
hi CursorColumn                         guibg=#282828
hi CursorLine                           guibg=#282828
hi Cursor               guifg=bg        guibg=fg
" Syntax {{{2
hi lCursor              guifg=bg        guibg=fg
hi MatchParen                           guibg=#009999
hi Comment              guifg=#99FF99                   gui=italic
hi Constant             guifg=#FF9999
hi String               guifg=#FF99FF
hi Boolean              guifg=#3366FF                   gui=bold
hi Identifier           guifg=#99FFFF
hi Function             guifg=#99CCFF
hi Statement            guifg=#6699FF                   gui=none
hi Operator             guifg=#FF9966
hi PreProc              guifg=#33FFFF                   gui=none
hi Type                 guifg=#FFFF99                   gui=none
hi Special              guifg=#FF3333
hi Underlined           guifg=#9999FF                   gui=underline
hi Ignore               guifg=bg
hi Error                guifg=#FFFFFF   guibg=#FF3333
hi Todo                 guifg=#0000CC   guibg=#FFFF33
" For 16 color terminals {{{1
hi Normal               ctermfg=Gray            ctermbg=Black
" Vim {{{2
hi SpecialKey           ctermfg=DarkGray
hi NonText              ctermfg=Cyan
hi Directory            ctermfg=DarkCyan
hi ErrorMsg             ctermfg=DarkRed         ctermbg=bg
hi IncSearch                                                            cterm=reverse
hi Search                                       ctermbg=Yellow
hi MoreMsg              ctermfg=Green
hi ModeMsg                                                              cterm=bold
hi LineNr               ctermfg=Yellow
hi Question             ctermfg=Green
hi StatusLine                                                           cterm=reverse,bold
hi StatusLineNC                                                         cterm=reverse
hi VertSplit                                                            cterm=reverse
hi Title                ctermfg=Magenta
hi Visual                                       ctermbg=bg              cterm=reverse
hi VisualNOS                                                            cterm=underline
hi WarningMsg           ctermfg=DarkYellow
hi WildMenu             ctermfg=bg              ctermbg=Yellow
hi Folded               ctermfg=Magenta         ctermbg=bg
hi FoldColumn           ctermfg=Cyan            ctermbg=bg
hi DiffAdd              ctermfg=Black           ctermbg=DarkGreen
hi DiffChange                                   ctermbg=DarkGray
hi DiffDelete           ctermfg=Black           ctermbg=DarkRed
hi DiffText             ctermfg=Black           ctermbg=DarkYellow      cterm=none
hi SignColumn           ctermfg=Yellow          ctermbg=bg
if version >= 700
  hi SpellBad                                   ctermbg=DarkRed         cterm=underline
  hi SpellCap                                   ctermbg=DarkBlue        cterm=underline
  hi SpellRare                                  ctermbg=DarkMagenta     cterm=underline
  hi SpellLocal                                 ctermbg=DarkCyan        cterm=underline
endif
hi Pmenu                ctermfg=fg              ctermbg=DarkMagenta
hi PmenuSel             ctermfg=fg              ctermbg=DarkGray
hi PmenuSbar            ctermfg=fg              ctermbg=DarkGray
hi PmenuThumb                                                           cterm=reverse
hi TabLine              ctermfg=bg              ctermbg=fg              cterm=none
hi TabLineSel                                                           cterm=bold
hi TabLineFill                                                          cterm=reverse
hi CursorColumn                                 ctermbg=DarkGray
hi CursorLine                                                           cterm=underline
" Syntax {{{2
hi MatchParen                                   ctermbg=DarkCyan
hi Comment              ctermfg=Green
hi Constant             ctermfg=Red
hi String               ctermfg=Magenta
hi Boolean              ctermfg=Blue
hi Identifier           ctermfg=Cyan                                    cterm=none
hi Function             ctermfg=Cyan
hi Statement            ctermfg=Blue
hi Operator             ctermfg=Blue
hi PreProc              ctermfg=DarkCyan
hi Type                 ctermfg=Yellow
hi Special              ctermfg=DarkRed
hi Underlined           ctermfg=Magenta                                 cterm=underline
hi Ignore               ctermfg=bg
hi Error                ctermfg=White           ctermbg=Red
hi Todo                 ctermfg=DarkBlue        ctermbg=Yellow
" 8-color terminal extras {{{2
if &t_Co == 8
hi Identifier                                                           cterm=bold
endif
