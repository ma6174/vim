" File: maroloccio3.vim

" Description: a colour scheme for Vim (GUI only)

" Scheme: maroloccio3
" Maintainer: Marco Ippolito < m a r o l o c c i o [at] g m a i l . c o m >

" Comment: only works in GUI mode

" Version: v0.0.1
" Date: 19  December 2008
" History:
" 0.1.0 Inital upload to vim.org

" ------------------------------------------------------------------------------

highlight clear
if exists("syntax_on")
  syntax reset
endif

let g:colors_name="maroloccio3"

" ------------------------------------------------------------------------------

highlight!  Normal        guifg=#a2a2a2       guibg=black       gui=none

highlight!  Statement     guifg=#5d5d5d       gui=none
highlight!  Comment       guifg=#464646       gui=italic
highlight!  Constant      guifg=#e8e8e8       gui=none

highlight!  Visual        guifg=#0e1219       guibg=#464646
highlight!  Search        guifg=#0e1219       guibg=#e8e8e8
highlight!  IncSearch     guifg=#0e1219       guibg=#5d5d5d

highlight!  Todo          guifg=#e8e8e8       guibg=#0e1219
highlight!  Todo          guisp=#5d5d5d       gui=bold,undercurl
highlight!  Error         guifg=#a2a2a2       guibg=#8f3231

highlight!  Cursor        guifg=#0e1219       guibg=#a2a2a2
highlight!  CursorLine    guibg=#2c3138

highlight!  StatusLine    guifg=#a2a2a2       guibg=#0e1219
highlight!  StatusLineNC  guifg=#2c3138       guibg=#a2a2a2

highlight!  VertSplit     guifg=#2c3138       guibg=#a2a2a2
highlight!  LineNr        guifg=#2c3138       guibg=#0e1219

highlight!  Pmenu         guifg=#a2a2a2       guibg=#2c3138
highlight!  PmenuSel      guifg=#0e1219       guibg=#a2a2a2

highlight!  NonText       guifg=#2c3138

highlight!  Underlined    gui=bold,underline

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
