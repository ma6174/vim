" Vim color file
" Maintainer:   Walter Hutchins
" Last Change:  $Date: 2006/03/25 09:37:49 $
" Version:      $Id: crt.vim version 1.0
"               Colors in the spirit of old crts (7 in 1)
"               Works with gui, 8, 16+, and 256 color terms.
" Note:         Best with gui or xterm-256color 
"               (see www.vim.org Tip #827: XTerm and 256 Colors).
"
" Special settings for gui and xterm-256color:
"               Normally in gvim and vim xterm-256color,
"               t_Co is not set or is set to 256 and you get a crt.
"               You can:
"               :set            and you get
"                 t_Co=8          8 color variation
"                 t_Co=16         16 color variation
"                 t_Co=257        high-contrast (black bg).
"                 t_Co=258        crt with brightness turned all the way up.
"                 t_Co=259        a blackboard
"                 t_Co=260        a dark blue background
"                 t_Co=261        a blue background
"                 t_Co=262-273    other assorted colors
"                 t_Co=280        look like gvim "out-of-the-box" defaults
"                 t_Co=281        white on blue -- no syntax initially
"                 Note: 280 wont change after -- must exit and restart
"               You can set T_CO in vimrc to 8,16,256-273 if you want.
"               (vimrc ex: let T_CO = 257)
"               If T_CO is not set in vimrc; uses the default for term/gui.
"               Note - T_CO case sensitive and not same as t_Co.
"               Note - T_CO only effective once. 
"                      Your :set t_Co command(s) override any T_CO in vimrc
"               Note - If your vimrc does syntax off; I make fg color white.
"                      Sometimes, it is easier to read with no syntax highlight
" Another section of notes appears below the code.

" cool help screens
" :he group-name
" :he highlight-groups
" :he cterm-colors
" :highlight

" Special Case: turn initital syntax off for certain variants
if !exists("foo2") "foo2 is expected not to exist anywhere when vim starts
  let foo2=0
  if exists("T_CO")
    if T_CO == 281 "get white on blue -- no syntax initially
      let foo2=1
    endif
    if T_CO == 282 "paper (blue on white) -- no syntax initially
      let foo2=1
    endif
  endif
endif
if foo2 == 1
  syntax off "you could then toggle; :syntax on or :syntax off
endif

set background=dark
if version > 580
    " no guarantees for version 5.8 and below, but this makes it stop
    " complaining
    hi clear
    if exists("syntax_on")
        syntax reset
    endif
endif
let g:colors_name="crt"

if exists("T_CO") && !exists("foo")
  "You can set T_CO in vimrc to 8,16,260-273 if you want
  let foo=T_CO
  let &t_Co=foo
endif


hi Cursor       guibg=#00ff5f guifg=#303030
" highlight groups
"hi CursorIM
"hi Directory
"hi DiffAdd
"hi DiffChange
"hi DiffDelete
"hi DiffText
"hi ErrorMsg
hi VertSplit    guibg=#c2bfa5 guifg=grey50 gui=none
hi Folded       guibg=grey30 guifg=gold
hi FoldColumn   guibg=grey30 guifg=tan
hi IncSearch    guifg=slategrey guibg=khaki
"hi LineNr
hi ModeMsg      guifg=goldenrod
hi MoreMsg      guifg=SeaGreen
hi NonText      guifg=LightGray
hi Question     guifg=springgreen
hi SpecialKey   guifg=yellowgreen
hi StatusLine   guibg=#c2bfa5 guifg=black gui=none
hi StatusLineNC guibg=#c2bfa5 guifg=grey50 gui=none
hi Visual       gui=none guifg=khaki guibg=olivedrab
"hi VisualNOS
hi WarningMsg   guifg=salmon
"hi WildMenu
"hi Menu
"hi Scrollbar
"hi Tooltip

if exists("syntax_on")
  hi Normal     ctermfg=47 guifg=#00ff5f
else
  hi Normal     ctermfg=251 guifg=#c6c6c6
endif

" syntax highlighting groups

if &t_Co == 256 || &t_Co == '' "crt
  hi Normal     ctermbg=235 guibg=#262626
elseif &t_Co == 257 "high contrast
    hi Normal   ctermbg=0 guibg=Black
elseif &t_Co == 258 "bightness turned up
    hi Normal   ctermbg=59 guibg=#5f5f5f
elseif &t_Co == 259 "blackboard
    hi Normal   ctermbg=22 guibg=#005f00
elseif &t_Co == 260 "dark blue background
    hi Normal   ctermbg=17 guibg=#00005f
elseif &t_Co == 261 "blue background
    hi Normal   ctermbg=20 guibg=#0000d7
elseif &t_Co == 262 "dark khaki background
    hi Normal   ctermbg=94 guibg=#875f00
elseif &t_Co == 263 "medium steel grey background
    hi Normal   ctermbg=240 guibg=#585858
elseif &t_Co == 264 "medium reddish purple background
    hi Normal   ctermbg=53 guibg=#5f005f
elseif &t_Co == 265 "greyish/salmon background
    hi Normal   ctermbg=95 guibg=#875f5f
elseif &t_Co == 266 "greenish/grey background
    hi Normal   ctermbg=23 guibg=#005f5f
elseif &t_Co == 267 "medium blue/grey background
    hi Normal   ctermbg=60 guibg=#005f87
elseif &t_Co == 268 "pastel purple/blue background
    hi Normal   ctermbg=61 guibg=#5f5faf
elseif &t_Co == 269 "medium purple/blue background
    hi Normal   ctermbg=18 guibg=#000087
elseif &t_Co == 270 "faint grey/green
    hi Normal   ctermbg=66 guibg=#5f8787
elseif &t_Co == 271 "faint pastel
    hi Normal   ctermbg=62 guibg=#875fd7
elseif &t_Co == 272 "faint grey
    hi Normal   ctermbg=102 guibg=#878787
elseif &t_Co == 273 "olive background
    hi Normal   ctermbg=58 guibg=#5f5f00
endif

if &t_Co >= 256 || &t_Co == ''
  hi Type       ctermfg=34 guifg=#00af00
  hi Search     cterm=NONE ctermfg=47 ctermbg=34 guifg=#00ff00 guibg=#00af00 
  hi Comment    ctermfg=251 guifg=#c6c6c6
  hi Constant   ctermfg=221 guifg=#ffd75f "#ffaf00 "214 "221 "180 "153
  hi Special    ctermfg=3   guifg=DarkYellow
  hi Identifier ctermfg=10 cterm=NONE guifg=#00ff00
  hi Statement  ctermfg=228 guifg=#ffff87
  hi PreProc    ctermfg=190 guifg=#d7ff00
  hi Underlined cterm=underline ctermfg=47 guifg=#00ff00
  hi NonText    ctermfg=84 guifg=#5fff87
  hi Ignore     cterm=bold ctermfg=84 guifg=#5fff87
  hi Directory  ctermfg=84 guifg=#5fff87
  hi Title      ctermfg=117 gui=NONE guifg=#87dfff "147 "#afafff "#87d7ff "189 "117 "#d7d7ff "#87d7ff
elseif &t_Co >= 16
  hi Normal     ctermfg=15 ctermbg=0 guifg=#ffffff guibg=#000000
  hi Type       ctermfg=2 guifg=#00cb00 gui=NONE
  hi Search     cterm=NONE ctermfg=7 ctermbg=6
  hi Comment    ctermfg=7 guifg=#e7e3e7
  hi Constant   ctermfg=3 guifg=#cecb00
  hi Special    ctermfg=8 guifg=#7b7d7b
  hi Identifier ctermfg=10 guifg=#00ff00
  hi Statement  ctermfg=11 guifg=#ffff00 gui=NONE
  hi PreProc    ctermfg=2 cterm=bold guifg=#00cb00 gui=bold
  hi Underlined cterm=underline ctermfg=2 guifg=#00cb00 gui=underline
  hi NonText    ctermfg=7
  hi Ignore     cterm=bold ctermfg=7
  hi Directory  ctermfg=darkcyan
else
  hi Normal     ctermfg=7 ctermbg=0 guifg=#e7e3e7 guibg=#000000
  hi Type       ctermfg=2 guifg=#00cb00 gui=NONE
  hi Search     cterm=NONE ctermfg=7 ctermbg=2 guifg=#e7e3e7 guibg=#00cb00
  hi Comment    ctermfg=7 cterm=bold guifg=#e7e3e7 gui=bold
  hi Constant   ctermfg=3 cterm=bold guifg=#cecb00 gui=bold
  hi Special    ctermfg=0 cterm=bold guifg=#7b7d7b
  hi Identifier cterm=bold ctermfg=2 guifg=#00cb00 gui=bold
  hi Statement  ctermfg=3 guifg=#cecb00 gui=NONE
  hi PreProc    cterm=bold ctermfg=2 guifg=#00cb00 gui=bold
  hi Underlined cterm=underline ctermfg=2 guifg=#00cb00 gui=underline
  hi NonText    ctermfg=7
  hi Ignore     cterm=bold ctermfg=7
  hi Directory  ctermfg=darkcyan
endif

" get gvim 'out-of-the-box' looking colors
" -- 280 -- if you want to change to the others, must do :color crt
if &t_Co == 280
  set background=light
  hi clear
  " gui
  hi Normal guibg=white guifg=black
  " color term
  hi Normal ctermbg=15 ctermfg=0
endif

" get white on blue
if &t_Co == 281
  " gui
  hi Normal guibg=#0000d7 guifg=white
  " color term
  hi Normal ctermbg=261 ctermfg=15
  "see 'foo2' - you could then toggle; :syntax on or :syntax off
endif

"paper
if &t_Co == 282
  hi Cursor     guibg=#005fd7 guifg=#ffffff
  hi Normal     ctermfg=26 guifg=#005fd7 ctermbg=15 guibg=#ffffff
  hi Type       cterm=bold
  hi Search     cterm=NONE ctermfg=15 ctermbg=45 guifg=#ffffff guibg=#00d7ff 
  hi Statement  ctermfg=172 guifg=#d78700
  hi Comment    ctermfg=102 guifg=#878787 "248
  hi Constant   ctermfg=214 guifg=#ffaf00 "214 "221 "180 "153
  hi PreProc    ctermfg=202 guifg=#ff5f00
  hi Identifier ctermfg=34 guifg=#00af00 "#5faf00 "#00d700
  hi Underlined cterm=underline ctermfg=2 guifg=#00cb00 gui=underline
endif

"must deal with these

hi Ignore       guifg=grey40
"hi Error
hi Todo         guifg=orangered guibg=yellow2

" color terminal definitions
hi SpecialKey   ctermfg=darkgreen
hi ErrorMsg     cterm=bold ctermfg=7 ctermbg=1
hi IncSearch    cterm=NONE ctermfg=yellow ctermbg=green
hi MoreMsg      ctermfg=darkgreen
hi ModeMsg      cterm=NONE ctermfg=brown
hi LineNr       ctermfg=3
hi Question     ctermfg=green
hi StatusLine   cterm=bold,reverse
hi StatusLineNC cterm=reverse
hi VertSplit    cterm=reverse
hi Visual       cterm=reverse
hi VisualNOS    cterm=bold,underline
hi WarningMsg   ctermfg=1
hi WildMenu     ctermfg=0 ctermbg=3
hi Folded       ctermfg=darkgrey ctermbg=NONE
hi FoldColumn   ctermfg=darkgrey ctermbg=NONE
hi DiffAdd      ctermbg=4
hi DiffChange   ctermbg=5
hi DiffDelete   cterm=bold ctermfg=4 ctermbg=6
hi DiffText     cterm=bold ctermbg=1
hi Ignore       ctermfg=darkgrey
hi Error        cterm=bold ctermfg=7 ctermbg=1



" More notes:
"
" I prefer to start xterm in one of three ways:
" xterm -fg gray90 -bg gray13 -fn 10x20
" xterm -fg gray90 -bg gray13 -fa 10x20 -fs 11 -bd gray13 -geometry +0+0
" xterm -fg gray90 -bg gray13 -fa 10x20 -fs 12
" The 1st form makes the screen big with font similar to console.
" The 2nd form makes the screen gvim-size with anti-aliased font.
"     The -geometry +0+0 puts it in the upper-left corner where I like it.
" The 3nd form makes the screen big with anti-aliased font (sizeof 1st form).
" xterm scrollbar wont work in vim like gvim scrollbar -- oh well,
" but you can :set mouse=a and wheel mouse does work -- cool.
"
" On RH Fedora Core 4, I extracted files from xterm-200-6.src.rpm and
" made with:
" ./configure --enable-luit --enable-warnings --enable-wide-chars \
"   --with-utempter --enable-256-color --prefix=/usr
" make
" make install
"
" Then added to .bashrc:
" if [ "$TERM" = "xterm" ]
" then
"  TERM=xterm-256color
"  export TERM
" fi
"
" After compiling, if I wanted xterm scrollbars (but I don't), I could
" Add to .Xresources:
" XTerm*scrollBar: on
" XTerm*rightScrollBar: on

"
" Added to .vimrc:
" "fix funny backspace in insert mode and cmd line for some linux xterms
" "the ^? was entered in insert mode by typing CTRL-V and a BACKSPACE (on mine)
" map! ^? <C-H>
" "Overcome xterm keycodes <Esc>OA and <Esc>OB for correct operation
" "of <UP> and <DOWN> in insert mode and commandline history
"  "-- see Help - find> xterm-cursor-keys
"  set notimeout         " don't timeout on mappings
"  set ttimeout          " do timeout on terminal key codes
"  set timeoutlen=100    " timeout after 100 msec

" This is my FC4, Gnome xterm.desktop entry:
"  [Desktop Entry]
"  Comment=(with anti-aliasing)
"  Name=xterm
"  Exec=xterm -fg gray90 -bg gray13 -fa 10x20 -fs 11 -bd gray13 -geometry +0+0
"  Icon[en_US]=/usr/share/pixmaps/gnome-term.png
"  Encoding=UTF-8
"  Terminal=false
"  Comment[en_US]=(with anti-aliasing)
"  Version=1.0
"  Name[en_US]=xterm
"  Type=Application
"  Categories=Application;Utility;TextEditor;
"  Icon=/usr/share/pixmaps/gnome-term.png



"vim: sw=4
