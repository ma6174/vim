" File: maroloccio2.vim

" Description: a colour scheme for Vim (GUI only)

" Scheme: maroloccio2
" Maintainer: Marco Ippolito < m a r o l o c c i o [at] g m a i l . c o m >

" Comment: only works in GUI mode

" Version: v0.0.1, inspired by watermark
" Date: 19  December 2008
" History:
" 0.1.0 Inital upload to vim.org

" ------------------------------------------------------------------------------

highlight clear
if exists("syntax_on")
  syntax reset
endif

let g:colors_name="maroloccio2"

" ------------------------------------------------------------------------------

highlight!  Normal        guifg=#8b9aaa       guibg=#1a202a       gui=none
highlight!  Visual        guifg=#0e1219       guibg=#6d5279
highlight!  StatusLine    guifg=#8b9aaa       guibg=#0e1219
highlight!  Cursor        guifg=#0e1219       guibg=#8b9aaa
highlight!  CursorLine    guibg=#0e1219
highlight!  CursorLine    guibg=#2c3138
highlight!  Search        guifg=#0e1219       guibg=#82ade0
highlight!  PmenuSel      guifg=#0e1219       guibg=#8b9aaa
highlight!  IncSearch     guifg=#0e1219       guibg=#2680af
highlight!  LineNr        guifg=#2c3138       guibg=#0e1219
highlight!  NonText       guifg=#2c3138
highlight!  Statement     guifg=#2680af
highlight!  Comment       guifg=#6d5279
highlight!  Constant      guifg=#82ade0
highlight!  Todo          guifg=#82ade0       guibg=#0e1219
highlight!  Todo          guisp=#2680af       gui=bold,undercurl
highlight!  Underlined    gui=bold,underline
highlight   Error         guifg=#8b9aaa       guibg=#8f3231
highlight!  Pmenu         guifg=#8b9aaa       guibg=#2c3138
highlight!  StatusLineNC  guifg=#2c3138       guibg=#8b9aaa
highlight!  VertSplit     guifg=#2c3138       guibg=#8b9aaa
highlight!  link          Boolean             Constant
highlight!  link          Character           Constant
highlight!  link          Conditional         Statement
highlight!  link          CursorColumn        CursorLine
highlight!  link          Define              Statement
highlight!  link          Delimiter           Comment
highlight!  link          Delimiter           Statement
highlight!  link          Exception           Statement
highlight!  link          Float               Constant
highlight!  link          Folded              Pmenu
highlight!  link          Function            Statement
highlight!  link          Include             Statement
highlight!  link          Label               Statement
highlight!  link          Macro               Statement
highlight!  link          Number              Constant
highlight!  link          Operator            Statement
highlight!  link          PreCondit           Statement
highlight!  link          PreProc             Statement
highlight!  link          Repeat              Statement
highlight!  link          Special             Comment
highlight!  link          Special             Statement
highlight!  link          SpecialChar         Comment
highlight!  link          SpecialChar         Statement
highlight!  link          SpecialComment      Comment
highlight!  link          SpecialKey          NonText
highlight!  link          StorageClass        Statement
highlight!  link          String              Constant
highlight!  link          Structure           Statement
highlight!  link          TabLine             StatusLine
highlight!  link          Tag                 Comment
highlight!  link          Tag                 Statement
highlight!  link          Type                Statement
highlight!  link          Typedef             Statement
highlight!  link          WildMenu            StatusLine

" ------------------------------------------------------------------------------
