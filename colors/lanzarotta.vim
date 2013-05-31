" Vim color file
" Maintainer: Jeff Lanzarotta <jefflanzarotta@yahoo.com>
" Last Change: January 24, 2002

set background=dark

" Remove all existing highlighting.
hi clear

" Reset syntax hightlighting to the defaults if needed.
if exists("syntax_on")
  syntax reset
endif

if has("gui_running")
  let colors_name = "lanzarotta"

  hi Boolean      guifg=LightMagenta
  hi Character    guifg=LightRed
  hi Comment      guifg=SteelBlue
  hi Conditional  guifg=LightYellow
  hi Constant     gui=None guifg=Orange
  hi Cursor       gui=None guifg=bg guibg=DarkGoldenrod1
  hi DiffAdd      guibg=Blue
  hi DiffChange   guibg=Purple
  hi DiffDelete   gui=Bold guifg=Blue guibg=Cyan
  hi DiffText     gui=Bold guibg=Red
  hi Directory    guifg=LightRed
  hi Error        guifg=White guibg=Red
  hi ErrorMsg     guifg=Black guibg=Red
  hi Exception    guifg=Red
  hi Float        guifg=LightMagenta
  hi FoldColumn   guibg=Grey guifg=DarkBlue
  hi Folded       guibg=LightGrey guifg=DarkBlue
  hi Function     guifg=GoldenRod
  hi Identifier   guifg=#99cc99
  hi IncSearch    guifg=Yellow guibg=Black
  hi Keyword      guifg=Salmon
  hi Label        guifg=LightYellow
  hi LineNr       guifg=DarkGrey
  hi Macro        guifg=Orange
  hi ModeMsg      gui=None guifg=Blue guibg=White
  hi MoreMsg      gui=Bold guifg=SeaGreen
  hi NonText      guifg=DarkGrey
  hi Normal       guifg=LightCyan guibg=Black
  hi Number       guifg=LightMagenta
  hi Operator     guifg=LightGrey
  hi Preproc      guifg=Green
  hi Question     gui=Bold guifg=Cyan
  hi Repeat       guifg=LightYellow
  hi Search       guifg=Black guibg=Yellow
  hi Special      guifg=White
  hi SpecialKey   gui=Reverse guifg=Gray
  hi Statement    gui=None guifg=LightYellow
  hi StatusLine   gui=None guifg=White guibg=OrangeRed3
  hi StatusLineNC gui=None guifg=Gray guibg=#333333
  hi String       guifg=LightRed
  hi Title        guifg=DarkGrey
  hi Todo         guifg=Blue guibg=Yellow
  hi Type         gui=None guifg=LightGreen
  hi VertSplit    gui=Reverse
  hi Visual       gui=None guifg=Black guibg=Gray
  hi VisualNOS    gui=Underline,Bold
  hi WarningMsg   guifg=Red
  hi WildMenu     guifg=Black guibg=Yellow
endif

" vim: sw=8
