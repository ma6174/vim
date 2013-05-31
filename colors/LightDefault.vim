" LIGHT colorscheme.  The purpose of this colorscheme is to make small
" adjustments to the default.

" Restore default colors
hi clear
set background=light 


if exists("syntax_on")
  syntax reset
endif

let g:colors_name = "LightDefault"

"hi Normal guifg=black guibg=#D6D3CE
hi Normal guifg=black guibg=ivory3
hi NonText guibg=#BDBDB1  " slightly darker than ivory3
hi Constant guifg=Magenta3
hi WarningMsg gui=bold
hi Search guibg=Yellow2
hi Function guifg=IndianRed
