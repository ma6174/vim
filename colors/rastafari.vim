" Vim color file
" Maintainer:  Dominique Pelle <dominique.pelle at gmail.com>
" Last Change: 25 Mar 2008
" URL:         http://dominique.pelle.free.fr/rastafari.vim
" Screenshot:  http://dominique.pelle.free.fr/rastafari.vim.png

set background=dark
hi clear
if exists("syntax on")
    syntax reset
endif

let g:color_name="rastafari"
" Normal colors {{{1
hi Normal      guifg=#aaaaaa guibg=#000000 gui=none term=none     cterm=none    ctermfg=gray
hi Ignore      guifg=#888888 guibg=bg      gui=bold term=bold     cterm=bold    ctermfg=darkgrey
hi Comment     guifg=#00aa00 guibg=bg      gui=none term=none     cterm=none    ctermfg=darkgreen
hi LineNr      guifg=#ffff00 guibg=bg      gui=none term=none     cterm=none    ctermfg=yellow
hi Include     guifg=#666666 guibg=bg      gui=bold term=bold     cterm=bold    ctermfg=darkgrey
hi Define      guifg=#666666 guibg=bg      gui=bold term=bold     cterm=bold    ctermfg=darkgrey
hi Macro       guifg=#666666 guibg=bg      gui=bold term=bold     cterm=bold    ctermfg=darkgrey
hi PreProc     guifg=#666666 guibg=bg      gui=bold term=bold     cterm=bold    ctermfg=darkgrey
hi PreCondit   guifg=#666666 guibg=bg      gui=bold term=bold     cterm=bold    ctermfg=darkgrey
hi NonText     guifg=#ffff00 guibg=bg      gui=none term=none     cterm=none    ctermfg=yellow
hi Directory   guifg=#ffff00 guibg=bg      gui=none term=none     cterm=none    ctermfg=yellow
hi SpecialKey  guifg=#ffff00 guibg=bg      gui=none term=none     cterm=none    ctermfg=yellow
hi Type        guifg=#ffffff guibg=bg      gui=none term=none     cterm=none    ctermfg=white
hi String      guifg=#bb0000 guibg=bg      gui=none term=none     cterm=none    ctermfg=darkred
hi Constant    guifg=#bb0000 guibg=bg      gui=none term=none     cterm=none    ctermfg=darkred
hi Special     guifg=#ff8800 guibg=bg      gui=none term=none     cterm=none    ctermfg=darkyellow
hi Number      guifg=#bb0000 guibg=bg      gui=none term=none     cterm=none    ctermfg=darkred
hi Identifier  guifg=#ffffff guibg=bg      gui=none term=none     cterm=none    ctermfg=white
hi Conditional guifg=#ffffff guibg=bg      gui=none term=none     cterm=none    ctermfg=white
hi Repeat      guifg=#ffffff guibg=bg      gui=none term=none     cterm=none    ctermfg=white
hi Statement   guifg=#ffffff guibg=bg      gui=none term=none     cterm=none    ctermfg=white
hi Label       guifg=fg      guibg=bg      gui=none term=none     cterm=none    ctermfg=gray
hi Operator    guifg=#ffffff guibg=bg      gui=none term=none     cterm=none    ctermfg=white
hi Function    guifg=#ffffff guibg=bg      gui=none term=none     cterm=none    ctermfg=white
hi MatchParen  guifg=#ffffff guibg=#0000aa gui=none term=none     cterm=none    ctermfg=grey       ctermbg=blue
hi ErrorMsg    guifg=#ffff00 guibg=#ff0000 gui=none term=none     cterm=none    ctermfg=yellow     ctermbg=red
hi WildMenu    guifg=#888800 guibg=#444444 gui=none term=none     cterm=none    ctermfg=yellow     ctermbg=darkgrey
hi Folded      guifg=#000000 guibg=#00aaaa gui=none term=reverse  cterm=reverse ctermfg=cyan       ctermbg=black
hi Search      guifg=#ffffff guibg=#0000ff gui=none term=none     cterm=none    ctermfg=white      ctermbg=blue
hi IncSearch   guifg=#ffffff guibg=#8888ff gui=none term=none     cterm=none    ctermfg=white      ctermbg=cyan
hi WarningMsg  guifg=#ffff00 guibg=#00ff00 gui=none term=none     cterm=none    ctermfg=yellow     ctermbg=lightgreen
hi Question    guifg=#00ff00 guibg=#008800 gui=none term=standout cterm=bold    ctermfg=lightgreen ctermbg=lightgreen
hi Pmenu       guifg=#00ff00 guibg=#00aa00 gui=none term=standout cterm=bold    ctermfg=green      ctermbg=green
hi PmenuSel    guifg=#ffcc00 guibg=#aa0000 gui=bold term=standout cterm=bold    ctermfg=yellow     ctermbg=red
hi Visual      guifg=#00ff00 guibg=#00aa00 gui=bold term=standout cterm=bold    ctermfg=green      ctermbg=green
" Specific for Vim script {{{1
hi vimCommentTitle guifg=#00ff00 guibg=bg      gui=none term=none cterm=none    ctermfg=lightgreen
hi vimFold         guifg=#888888 guibg=#222222 gui=none term=none cterm=none    ctermfg=darkgrey   ctermbg=grey
" Specific for help files {{{1
hi helpHyperTextJump guifg=#ffaa00" guibg=bg ctermfg=darkyellow
" Specific for Perl {{{1
hi perlSharpBang        guifg=#00ff00 guibg=bg gui=bold ctermfg=lightgreen cterm=bold term=standout
hi perlStatement        guifg=#aaaaaa guibg=bg gui=none ctermfg=gray
hi perlStatementStorage guifg=#ffffff guibg=bg gui=none ctermfg=white
hi perlVarPlain         guifg=#aaaaaa guibg=bg gui=none ctermfg=gray
hi perlVarPlain2        guifg=#aaaaaa guibg=bg gui=none ctermfg=gray
" Specific for Ruby {{{1
hi rubySharpBang guifg=#00ff00 guibg=bg gui=bold ctermfg=lightgreen cterm=bold term=standout
" Specific for diff {{{1
hi diffLine    guifg=#00ff00 guibg=bg gui=bold ctermfg=lightgreen cterm=bold
hi diffOldLine guifg=#00cc00 guibg=bg gui=none ctermfg=green      cterm=none
hi diffOldFile guifg=#00cc00 guibg=bg gui=none ctermfg=green      cterm=none
hi diffNewFile guifg=#00cc00 guibg=bg gui=none ctermfg=green      cterm=none
hi diffAdded   guifg=#ffaa00 guibg=bg gui=none ctermfg=darkyellow cterm=none
hi diffRemoved guifg=#ff0000 guibg=bg gui=none ctermfg=red        cterm=none
hi diffChanged guifg=#00ccff guibg=bg gui=none ctermfg=cyan       cterm=none
" Specific for doxygen {{{1
hi doxygenStart                guifg=#00ff00 guibg=bg gui=none term=none cterm=none ctermfg=lightgreen
hi doxygenStartL               guifg=#00ff00 guibg=bg gui=none term=none cterm=none ctermfg=lightgreen
hi doxygenBriefLine            guifg=#00aa00 guibg=bg gui=none term=none cterm=none ctermfg=darkgreen
hi doxygenBriefL               guifg=#00aa00 guibg=bg gui=none term=none cterm=none ctermfg=darkgreen
hi doxygenComment              guifg=#00ff00 guibg=bg gui=none term=none cterm=none ctermfg=lightgreen
hi doxygenCommentL             guifg=#00aa00 guibg=bg gui=none term=none cterm=none ctermfg=darkgreen
hi doxygenSpecialMultiLineDesc guifg=#00aa00 guibg=bg gui=none term=none cterm=none ctermfg=darkgreen
hi doxygenSpecial              guifg=#00ff00 guibg=bg gui=none term=none cterm=none ctermfg=lightgreen
hi doxygenParam                guifg=#00ff00 guibg=bg gui=none term=none cterm=none ctermfg=lightgreen
hi doxygenParamName            guifg=#0000ff guibg=bg gui=none term=none cterm=none ctermfg=blue
hi doxygenParamDirection       guifg=#cccc00 guibg=bg gui=none term=none cterm=none ctermfg=darkyellow
hi doxygenParamDirection       guifg=#ffff00 guibg=bg gui=none term=none cterm=none ctermfg=yellow
hi doxygenArgumentWord         guifg=#0000ff guibg=bg gui=none term=none cterm=none ctermfg=blue
" Spell checking {{{1
if version >= 700
  hi clear SpellBad
  hi clear SpellCap
  hi clear SpellRare
  hi clear SpellLocal
  hi SpellBad    guisp=red    gui=undercurl cterm=underline
  hi SpellCap    guisp=yellow gui=undercurl cterm=underline
  hi SpellRare   guisp=blue   gui=undercurl cterm=underline
  hi SpellLocal  guisp=orange gui=undercurl cterm=underline
endif
" vim: foldmethod=marker foldmarker={{{,}}}:
