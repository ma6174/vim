" Darkdevel Vim color scheme
"
" Name:         darkdevel.vim
" Maintainer:   Hallison Batista <email@hallisonbatista.com> 
" Last Change:  2009-03-17 
" License:      Public Domain
" Version:      1.1.1

highlight clear

if exists("syntax_on")
  syntax reset
endif

let g:colors_name = "darkdevel"

" General settings
" ================
set background=dark
if v:version > 700
  set cursorline
  "set cursorcolumn
endif

let g:Darkdevel = {}
let g:Darkdevel.cursor = {}
let g:Darkdevel.cursor.ctermfg = 'NONE'
let g:Darkdevel.cursor.guifg   = '#000000'
let g:Darkdevel.cursor.ctermbg = 'NONE'
let g:Darkdevel.cursor.guibg   = '#FFFFFF'

let g:Darkdevel.comment = {}
let g:Darkdevel.comment.ctermfg = 'DarkGray'
let g:Darkdevel.comment.guifg   = '#646464'
let g:Darkdevel.comment.ctermbg = 'NONE'
let g:Darkdevel.comment.guibg   = 'NONE'

" Cursor style
" ============
  highlight Cursor          ctermfg=NONE        guifg=#000000     ctermbg=NONE        guibg=#FFFFFF
  "highlight CursorIM      
  highlight CursorColumn    ctermfg=NONE        guifg=NONE        ctermbg=DarkGray    guibg=#0F0F0F
  highlight CursorLine      ctermfg=NONE        guifg=NONE        ctermbg=DarkGray    guibg=#0F0F0F

" Directory style
" ===============
  "highlight Directory       ctermbg=NONE        guifg=NONE        ctermbg=NONE        guibg=NONE      cterm=bold    gui=underline

" Diff text style
" ===============
  highlight DiffAdd         ctermfg=DarkGreen   guifg=#32BE32     ctermbg=NONE        guibg=NONE
  "highlight DiffChange  
  highlight DiffDelete      ctermfg=DarkRed     guifg=#BE3232     ctermbg=NONE        guibg=NONE
  "highlight DiffText  

" Text and message style
" ======================
  highlight ErrorMsg        ctermfg=Red         guifg=#FF0000     ctermbg=NONE        guibg=NONE
  highlight WarningMsg      ctermfg=Yellow      guifg=Yellow      ctermbg=NONE        guibg=NONE
  highlight MoreMsg         ctermfg=Green       guifg=#00FF00     ctermbg=NONE        guibg=NONE
  highlight link ModeMsg    WarningMsg
  "highlight VertSplit
  highlight Folded          ctermfg=Gray        guifg=#777777     ctermbg=DarkGray    guibg=#0F0F0F
  "highlight FoldColumn
  "highlight SignColumn
  "highlight IncSearch
  highlight LineNr          ctermfg=DarkGray    guifg=#777777     ctermbg=DarkGray    guibg=#0F0F0F 
  "highlight MatchParen
  highlight NonText         ctermfg=Gray        guifg=#777777     ctermbg=NONE        guibg=#000000
  highlight Normal          ctermfg=Gray        guifg=#F0F0F0     ctermbg=NONE        guibg=#000000

" Popup menu style
" ================
  highlight Pmenu           ctermfg=Gray        guifg=#FFFFFF     ctermbg=DarkGray    guibg=#0F0F0F
  highlight PmenuSel        ctermfg=White       guifg=#0F0F0F     ctermbg=Gray        guibg=#F0F0F0
  highlight PmenuSbar       ctermfg=NONE        guifg=NONE        ctermbg=DarkGray    guibg=#777777
  highlight PmenuThumb      ctermfg=Gray        guifg=#F0F0F0     ctermbg=NONE        guibg=NONE

  "highlight Question
  "highlight Search
  "highlight SpecialKey
  "highlight Error                     guifg=#FFFFFF   guibg=#990000

" Spelling style
" ==============
  "highlight SpellBad
  "highlight SpellCap
  "highlight SpellLocal
  "highlight SpellRare

" Status style
" ============
  highlight StatusLine      ctermfg=DarkGray    guifg=#0F0F0F     ctermbg=Gray        guibg=#777777   cterm=bold  gui=bold
  highlight StatusLineNC    ctermfg=DarkGray    guifg=#777777     ctermbg=DarkGray    guibg=#0F0F0F   cterm=bold  gui=bold

  "highlight TabLine
  "highlight TabLineFill
  "highlight TabLineSel

  highlight Title           ctermfg=Gray        guifg=#F0F0F0     ctermbg=NONE        guibg=NONE
  highlight Visual          ctermfg=Gray        guifg=#FFFFFF     ctermbg=DarkBlue    guibg=#505064
  highlight VisualNOS       ctermfg=NONE        guifg=NONE        ctermbg=DarkGreen   guibg=#506450
  highlight WildMenu        ctermfg=NONE        guifg=#777777     ctermbg=DarkGray    guibg=#0F0F0F

" Win32 specific style
" --------------------
  "highlight Menu
  "highlight Scrollbar
  "highlight Tooltip

" Syntax style
" ============

" Style for constants
" -------------------
  highlight Constant          ctermfg=DarkRed     guifg=#6496C8
  highlight String            ctermfg=DarkGreen   guifg=#64C896
  highlight Character         ctermfg=DarkBlue    guifg=#6496C8
  highlight Number            ctermfg=DarkGreen   guifg=#64C896
  highlight Boolean           ctermfg=DarkBlue    guifg=#6496C8
  highlight Float             ctermfg=DarkGreen   guifg=#64C896

  highlight Comment           ctermfg=DarkGray    guifg=#646464     ctermbg=NONE      guibg=NONE

" Style for identifier and variable names
" ----------------------------------------
  highlight Identifier        ctermfg=DarkCyan    guifg=#6496C8     gui=NONE
  highlight Function          ctermfg=Yellow      guifg=#FFC864     gui=NONE

" Style for statements
" ---------------------
  highlight Statement         ctermfg=Brown       guifg=#C89664     gui=NONE
  highlight link Conditional  Statement
  highlight link Repeat       Statement
  highlight link Label        Statement
  highlight Operator          ctermfg=Green       guifg=#64C864
  highlight Keyword           ctermfg=DarkRed     guifg=#C86432
  highlight link Exception    Statement

" Style for generic preprocessor
" ------------------------------
  highlight PreProc           ctermfg=Gray        guifg=#DCDCDC     ctermbg=NONE      guibg=NONE
  highlight Include           ctermfg=DarkRed     guifg=#C86432     ctermbg=NONE      guibg=NONE
  highlight link Define       Include
  highlight link Macro        Include
  highlight link PreCondit    Include

" Style for types and objects
" ---------------------------
  highlight Type              ctermfg=DarkRed     guifg=#DC4B32     gui=NONE
  highlight link StorageClass Type
  highlight link Structure    Type
  highlight link Typedef      Type

" Style for special symbols
" -------------------------
  "highlight Special         
  "highlight SpecialChar     
  "highlight Tag             
  "highlight Delimiter       
  "highlight SpecialComment  
  "highlight Debug           

" Style for text format
" ---------------------
  "highlight Underlined 
  "highlight Ignore     
  "highlight Error      
  "highlight Todo       

" Style for Shell Syntax
" ----------------------
  "highlight shTest
  "highlight shCase
  "highlight shCaseExSingleQuote
  "highlight shCaseEsac
  "highlight shDo
  "highlight shExpr
  "highlight shFor
  "highlight shIf
  "highlight shSubSh
  "highlight shComma
  "highlight shDerefVarArray
  "highlight shDblBrace
  "highlight shSpecialVar
  "highlight shDblParen
  "highlight shCurlyIn
  "highlight bashSpecialVariables
  "highlight bashStatement
  "highlight bashAdminStatement
  "highlight kshSpecialVariables
  "highlight kshStatement
  "highlight shSetIdentifier
  "highlight shFunctionTwo
  "highlight shFunctionStart
  "highlight shFunctionOne
  "highlight shDerefPattern
  "highlight shDerefEscape
  "highlight shDerefPPSleft
  "highlight shDerefPPSright
  "highlight shCaseEsacSync
  "highlight shDoSync
  "highlight shForSync
  "highlight shIfSync
  "highlight shUntilSync
  "highlight shWhileSync

" Style for Ruby Syntax
" ---------------------
  highlight rubyBlockParameter        guifg=#FFFFFF
  highlight rubyClass                 guifg=#FFFFFF
  highlight rubyConstant              guifg=#DA4939
  highlight rubyInstanceVariable      guifg=#D0D0FF
  highlight rubyInterpolation         guifg=#519F50
  highlight rubyLocalVariableOrMethod guifg=#D0D0FF
  highlight rubyPredefinedConstant    guifg=#DA4939
  highlight rubyPseudoVariable        guifg=#FFC66D
  highlight rubyStringDelimiter       guifg=#A5C261

" Style for XML and (X)HTML Syntax
  highlight xmlTag                    guifg=#E8BF6A
  highlight xmlTagName                guifg=#E8BF6A
  highlight xmlEndTag                 guifg=#E8BF6A

  highlight link htmlTag              xmlTag
  highlight link htmlTagName          xmlTagName
  highlight link htmlEndTag           xmlEndTag

