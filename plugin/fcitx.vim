" fcitx.vim  记住插入模式小企鹅输入法的状态
" Author:       lilydjwg
" Maintainer:   lilydjwg
" Last Change:  2010-11-18
" Note:         另有使用 Python3 接口的新版本
" ---------------------------------------------------------------------
" Load Once:
if (has("win32") || has("win95") || has("win64") || has("win16"))
  " Windows 下不要载入
  finish
endif
if !exists('$DISPLAY')
  " 没有 X，不要载入
  finish
endif
if &cp || exists("g:loaded_fcitx") || !executable("fcitx-remote")
  finish
endif
let s:keepcpo = &cpo
let g:loaded_fcitx = 1
set cpo&vim
" ---------------------------------------------------------------------
" Functions:
function Fcitx2en()
  let inputstatus = system("fcitx-remote")
  if inputstatus == 2
    let b:inputtoggle = 1
    call system("fcitx-remote -c")
  endif
endfunction
function Fcitx2zh()
  try
    if b:inputtoggle == 1
      call system("fcitx-remote -o")
      let b:inputtoggle = 0
    endif
  catch /inputtoggle/
    let b:inputtoggle = 0
  endtry
endfunction
" ---------------------------------------------------------------------
" Autocmds:
au InsertLeave * call Fcitx2en()
au InsertEnter * call Fcitx2zh()
" ---------------------------------------------------------------------
"  Restoration And Modelines:
let &cpo=s:keepcpo
unlet s:keepcpo
" vim:fdm=expr:fde=getline(v\:lnum-1)=~'\\v"\\s*-{20,}'?'>1'\:1
