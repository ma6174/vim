" Vim color file:  calmar256-dark.vim
" Last Change: 02. March 2007
" License: public domain
" Maintainer:: calmar <mac@calmar.ws>
"
" for a 256 color capable terminal like xterm-256color, ... or gvim as well
" "{{{
" it only works in such a terminal and when you have:
" set t_Co=256
" in your vimrc"}}}
"

" {{{ t_Co=256 is set - check 
if &t_Co != 256 && ! has("gui_running")
    echomsg ""
    echomsg "write 'set t_Co=256' in your .vimrc or this file won't load"
    echomsg ""
    finish
endif
" }}}
" {{{ reset colors and set colors_name and store cpo setting
set background=dark
hi clear
if exists("syntax_on")
    syntax reset
endif

let g:colors_name = "calmar256"

let s:save_cpo = &cpo
set cpo&vim
" }}}

" Format:"{{{
" \ ["color-item", "style", "foreground", "background" ],
"
" in vim  :help help hl-<highlight-group>  
"         :help highlight-groups
"
" Color numbers (0-255) see:
" http://www.calmar.ws/vim/256-xterm-24bit-rgb-color-chart.html
 
" ----------------------"}}}
" EDIT/ADD style/colors below
 
let s:colors256 = [ 
            \ ["Normal",        "NONE", "41",   "232"   ],
            \ ["Cursor",        "NONE", "255", "33"  ],
            \ ["CursorLine",    "NONE", "NONE", "233"   ],
            \ ["CursorColumn",  "NONE", "NONE", "233"   ],
            \ ["Incsearch",     "BOLD", "195",  "124"   ],
            \ ["Search",        "NONE", "NONE", "52"    ],
            \ ["ErrorMsg",      "BOLD", "16",   "202"   ],
            \ ["WarningMsg",    "BOLD", "16",   "190"   ],
            \ ["ModeMsg",       "NONE", "226",   "18"    ],
            \ ["MoreMsg",       "BOLD", "16",   "154"   ],
            \ ["Question",      "BOLD", "70",   "NONE"  ],
            \ ["StatusLine",    "NONE", "190",  "22"    ],
            \ ["StatusLineNC",  "NONE", "84",   "234"   ],
            \ ["User1",         "BOLD", "28",   "NONE"  ],
            \ ["User2",         "BOLD", "39",   "NONE"  ],
            \ ["VertSplit",     "NONE", "84",   "22"    ],
            \ ["WildMenu",      "BOLD", "87",   "35"    ],
            \ ["DiffText",      "NONE", "16",   "190"   ],
            \ ["DiffChange",    "NONE", "18",   "83"    ],
            \ ["DiffDelete",    "NONE", "79",   "124"   ],
            \ ["DiffAdd",       "NONE", "79",   "21"    ],
            \ ["Folded",        "NONE", "38",   "234"   ],
            \ ["FoldedColumn",  "NONE", "39",   "190"   ],
            \ ["Directory",     "NONE", "28",   "NONE"  ],
            \ ["LineNr",        "NONE", "28",   "16"    ],
            \ ["NonText",       "NONE", "244",  "16"    ],
            \ ["SpecialKey",    "NONE", "190",  "NONE"  ],
            \ ["Title",         "BOLD", "98",   "NONE"  ],
            \ ["Visual",        "BOLD", "NONE", "238"   ],
            \ ["Comment",       "NONE", "37",   "NONE"  ],
            \ ["Costant",       "NONE", "73",   "NONE"  ],
            \ ["String",        "NONE", "190",  "NONE"  ],
            \ ["Error",         "NONE", "69",   "NONE"  ],
            \ ["Identifier",    "NONE", "81",   "NONE"  ],
            \ ["Ignore",        "NONE", "NONE", "NONE"  ],
            \ ["Number",        "NONE", "50",   "NONE"  ],
            \ ["PreProc",       "NONE", "178",  "NONE"  ],
            \ ["Special",       "NONE", "15",   "234"   ],
            \ ["SpecialChar",   "NONE", "155",  "NONE"  ],
            \ ["Statement",     "NONE", "120",  "NONE"  ],
            \ ["Todo",          "BOLD", "16",   "148"   ],
            \ ["Type",          "NONE", "71",   "NONE"  ],
            \ ["Underlined",    "BOLD", "77",   "NONE"  ],
            \ ["TaglistTagName","BOLD", "48",   "124"   ],
            \ ]

let s:colorvim7 = [
            \ ["Pmenu",         "NONE", "228",  "236"   ],
            \ ["PmenuSel",      "BOLD", "226",  "232"   ],
            \ ["PmenuSbar",     "NONE", "119",  "16"    ],
            \ ["PmenuThumb",    "NONE", "11",   "16"    ],
            \ ["SpellBad",      "NONE", "46",   "233"   ],
            \ ["SpellRare",     "NONE", "82",   "233"   ],
            \ ["SpellLocal",    "NONE", "227",  "234"   ],
            \ ["SpellCap",      "NONE", "46",   "236"   ],
            \ ["MatchParen",    "BOLD", "15",   "22"    ],
            \ ["TabLine",       "NONE", "252",  "22"    ],
            \ ["TabLineSel",    "BOLD", "253",  "30"    ],
            \ ["TabLineFill",   "NONE", "247",  "16"    ],
            \ ]

"=========================================
" NO NEED to edit below (unless bugfixing)
"=========================================
" {{{ check args helper function
function! s:checkargs(arg)
    if a:arg+0 == 0 && a:arg != "0"  "its a string
        return a:arg
    else
        return s:cmap[a:arg+0]       "get rgb color based on the number
    endif
endfunction
" }}}
" {{{ color setup for terminal
if ! has("gui_running")
    for s:col in s:colors256
        exec "hi ".s:col[0]." cterm=".s:col[1]." ctermfg=".s:col[2]." ctermbg=".s:col[3]
    endfor
    if v:version >= 700
        for s:col in s:colorvim7
            exec "hi ".s:col[0]." cterm=".s:col[1]." ctermfg=".s:col[2]." ctermbg=".s:col[3]
        endfor
    endif
else
" }}}
    " color-mapping array {{{
    " number of vim colors and #html colors equivalent for gui
    let s:cmap =   [ 
                \ "#000000", "#800000", "#008000", "#808000", 
                \ "#000080", "#800080", "#008080", "#c0c0c0", 
                \ "#808080", "#ff0000", "#00ff00", "#ffff00", 
                \ "#0000ff", "#ff00ff", "#00ffff", "#ffffff", 
                \
                \ "#000000", "#00005f", "#00008f", "#0000af", "#0000d7", "#0000ff", 
                \ "#005f00", "#005f5f", "#005f8f", "#005faf", "#005fd7", "#005fff", 
                \ "#008f00", "#008f5f", "#008f8f", "#008faf", "#008fd7", "#008fff", 
                \ "#00af00", "#00af5f", "#00af8f", "#00afaf", "#00afd7", "#00afff", 
                \ "#00d700", "#00d75f", "#00d78f", "#00d7af", "#00d7d7", "#00d7ff", 
                \ "#00ff00", "#00ff5f", "#00ff8f", "#00ffaf", "#00ffd7", "#00ffff", 
                \ "#5f0000", "#5f005f", "#5f008f", "#5f00af", "#5f00d7", "#5f00ff", 
                \ "#5f5f00", "#5f5f5f", "#5f5f8f", "#5f5faf", "#5f5fd7", "#5f5fff", 
                \ "#5f8f00", "#5f8f5f", "#5f8f8f", "#5f8faf", "#5f8fd7", "#5f8fff", 
                \ "#5faf00", "#5faf5f", "#5faf8f", "#5fafaf", "#5fafd7", "#5fafff", 
                \ "#5fd700", "#5fd75f", "#5fd78f", "#5fd7af", "#5fd7d7", "#5fd7ff", 
                \ "#5fff00", "#5fff5f", "#5fff8f", "#5fffaf", "#5fffd7", "#5fffff", 
                \ "#8f0000", "#8f005f", "#8f008f", "#8f00af", "#8f00d7", "#8f00ff", 
                \ "#8f5f00", "#8f5f5f", "#8f5f8f", "#8f5faf", "#8f5fd7", "#8f5fff", 
                \ "#8f8f00", "#8f8f5f", "#8f8f8f", "#8f8faf", "#8f8fd7", "#8f8fff", 
                \ "#8faf00", "#8faf5f", "#8faf8f", "#8fafaf", "#8fafd7", "#8fafff", 
                \ "#8fd700", "#8fd75f", "#8fd78f", "#8fd7af", "#8fd7d7", "#8fd7ff", 
                \ "#8fff00", "#8fff5f", "#8fff8f", "#8fffaf", "#8fffd7", "#8fffff", 
                \ "#af0000", "#af005f", "#af008f", "#af00af", "#af00d7", "#af00ff", 
                \ "#af5f00", "#af5f5f", "#af5f8f", "#af5faf", "#af5fd7", "#af5fff", 
                \ "#af8f00", "#af8f5f", "#af8f8f", "#af8faf", "#af8fd7", "#af8fff", 
                \ "#afaf00", "#afaf5f", "#afaf8f", "#afafaf", "#afafd7", "#afafff", 
                \ "#afd700", "#afd75f", "#afd78f", "#afd7af", "#afd7d7", "#afd7ff", 
                \ "#afff00", "#afff5f", "#afff8f", "#afffaf", "#afffd7", "#afffff", 
                \ "#d70000", "#d7005f", "#d7008f", "#d700af", "#d700d7", "#d700ff", 
                \ "#d75f00", "#d75f5f", "#d75f8f", "#d75faf", "#d75fd7", "#d75fff", 
                \ "#d78f00", "#d78f5f", "#d78f8f", "#d78faf", "#d78fd7", "#d78fff", 
                \ "#d7af00", "#d7af5f", "#d7af8f", "#d7afaf", "#d7afd7", "#d7afff", 
                \ "#d7d700", "#d7d75f", "#d7d78f", "#d7d7af", "#d7d7d7", "#d7d7ff", 
                \ "#d7ff00", "#d7ff5f", "#d7ff8f", "#d7ffaf", "#d7ffd7", "#d7ffff", 
                \ "#ff0000", "#ff005f", "#ff008f", "#ff00af", "#ff00d7", "#ff00ff", 
                \ "#ff5f00", "#ff5f5f", "#ff5f8f", "#ff5faf", "#ff5fd7", "#ff5fff", 
                \ "#ff8f00", "#ff8f5f", "#ff8f8f", "#ff8faf", "#ff8fd7", "#ff8fff", 
                \ "#ffaf00", "#ffaf5f", "#ffaf8f", "#ffafaf", "#ffafd7", "#ffafff", 
                \ "#ffd700", "#ffd75f", "#ffd78f", "#ffd7af", "#ffd7d7", "#ffd7ff", 
                \ "#ffff00", "#ffff5f", "#ffff8f", "#ffffaf", "#ffffd7", "#ffffff", 
                \
                \ "#080808", "#121212", "#1c1c1c", "#262626", "#303030", "#3a3a3a", 
                \ "#444444", "#4e4e4e", "#585858", "#606060", "#666666", "#767676", 
                \ "#808080", "#8a8a8a", "#949494", "#9e9e9e", "#a8a8a8", "#b2b2b2", 
                \ "#bcbcbc", "#c6c6c6", "#d0d0d0", "#dadada", "#e4e4e4", "#eeeeee" ]
    " }}}
" {{{ color setup for gvim
    for s:col in s:colors256
        let fg = s:checkargs(s:col[2])
        let bg = s:checkargs(s:col[3])
        exec "hi ".s:col[0]." gui=".s:col[1]." guifg=".fg." guibg=".bg
    endfor
    if v:version >= 700
        for s:col in s:colorvim7
            let fg = s:checkargs(s:col[2])
            let bg = s:checkargs(s:col[3])
            exec "hi ".s:col[0]." gui=".s:col[1]." guifg=".fg." guibg=".bg
        endfor
    endif
endif
" }}}
let &cpo = s:save_cpo   " restoring &cpo value
" vim: set fdm=marker fileformat=unix:
