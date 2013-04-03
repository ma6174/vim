"------------------------------------------------------------------------------
"   Name Of File: tasklist.vim
"
"    Description: Vim plugin to search for a list of tokens and display a
"                 window with matches.
"
"         Author: Juan Frias (juandfrias at gmail.com)
"
"    Last Change: 2009 Apr 11
"        Version: 1.0.1
"
"      Copyright: Permission is hereby granted to use and distribute this code,
"                 with or without modifications, provided that this header
"                 is included with it.
"
"                 This script is to be distributed freely in the hope that it
"                 will be useful, but is provided 'as is' and without warranties
"                 as to performance of merchantability or any other warranties
"                 whether expressed or implied. Because of the various hardware
"                 and software environments into which this script may be put,
"                 no warranty of fitness for a particular purpose is offered.
"
"                 GOOD DATA PROCESSING PROCEDURE DICTATES THAT ANY SCRIPT BE
"                 THOROUGHLY TESTED WITH NON-CRITICAL DATA BEFORE RELYING ON IT.
"
"                 THE USER MUST ASSUME THE ENTIRE RISK OF USING THE SCRIPT.
"
"                 The author does not retain any liability on any damage caused
"                 through the use of this script.
"
"        Install: 1. Read the section titled 'Options'
"                 2. Setup any variables need in your vimrc file
"                 3. Copy 'tasklist.vim' to your plugin directory.
"
"    Mapped Keys: <Leader>t   Display list.
"
"          Usage: Start the script with the mapped key, a new window appears
"                 with the matches found, moving around the window will also
"                 update the position of the current document.
"
"                 The following keys are mapped to the results window:
"
"                     q - Quit, and restore original cursor position.
"
"                     e - Exit, and keep results window open note that
"                         movements on the result window will no longer be
"                         updated.
"
"                     <cr> - Quit and place the cursor on the selected line.
"
" Aknowledgments: Many thanks to Zhang Shuhan for taking the time to beta
"                 test and suggest many of the improvements and features
"                 found in the script.  I don't think I would have
"                 implemented it wihout his help. Thanks!
"
"------------------------------------------------------------------------------
" Please send me any bugs you find, so I can keep the script up to date.
"------------------------------------------------------------------------------

" History: {{{1
"------------------------------------------------------------------------------
"
" 1.00  Initial version.
"
" User Options: {{{1
"------------------------------------------------------------------------------
"
" <Leader>t
"       This is the default key map to view the task list.
"       to overwrite use something like:
"           map <leader>v <Plug>TaskList
"       in your vimrc file
"
" g:tlWindowPosition
"       This is specifies the position of the window to be opened. By
"       default it will open at on top. To overwrite use:
"           let g:tlWindowPosition = 1
"       in your vimrc file, options are as follows:
"           0 = Open on top
"           1 = Open on the bottom
"
" g:tlTokenList
"       This is the list of tokens to search for default is
"       'FIXME TODO XXX'. The results are groupped and displayed in the
"       order that they appear. to overwrite use:
"           let g:tlTokenList = ['TOKEN1', 'TOKEN2', 'TOKEN3']
"       in your vimrc file
"
" g:tlRememberPosition
"       If this is set to 1 then the script will try to get back to the
"       position where it last was closed. By default it will find the line
"       closest to the current cursor position.
"       to overwrite use:
"           let g:tlRememberPosition = 1
"       in your vimrc file
"

" Global variables: {{{1
"------------------------------------------------------------------------------

" Load script once
"------------------------------------------------------------------------------
if exists("g:loaded_tasklist") || &cp
    finish
endif
let g:loaded_tasklist = 1

" Set where the window opens
"------------------------------------------------------------------------------
if !exists('g:tlWindowPosition')
"   0 = Open at top
    let g:tlWindowPosition = 0
endif

" Set the token list
"------------------------------------------------------------------------------
if !exists('g:tlTokenList')
"   default list of tokens
    let g:tlTokenList = ["FIXME", "TODO", "XXX"]
endif

" Remember position
"------------------------------------------------------------------------------
if !exists('g:tlRememberPosition')
"   0 = Donot remember, find closest match
    let g:tlRememberPosition = 0
endif

" Script variables: {{{1
"------------------------------------------------------------------------------

" Function: Open Window {{{1
"--------------------------------------------------------------------------
function! s:OpenWindow(buffnr, lineno)
    " Open results window and place items there.
    if g:tlWindowPosition == 0
      execute 'sp -TaskList_'.a:buffnr.'-'
    else
      execute 'botright sp -TaskList_'.a:buffnr.'-'
    endif

    let b:original_buffnr = a:buffnr
    let b:original_line = a:lineno

    set noswapfile
    set modifiable
    normal! "zPGddgg
    set fde=getline(v:lnum)[0]=='L'
    set foldmethod=expr
    set foldlevel=0
    normal! zR

    " Resize line if too big.
    let l:hits = line("$")
    if l:hits < winheight(0)
        sil! exe "resize ".l:hits
    endif

    " Clean up.
    let @z = ""
    set nomodified
endfunction

" Function: Search file {{{1
"--------------------------------------------------------------------------
function! s:SearchFile(hits, word)
    " Search at the beginning and keep adding them to the register
    let l:match_count = 0
    normal! gg0
    let l:max = strlen(line('$'))
    let l:last_match = -1
    let l:div = 0
    while search(a:word, "Wc") > 0
        let l:curr_line = line('.')
        if l:last_match == l:curr_line
            if l:curr_line == line('$')
                break
            endif
            normal! j0
            continue
        endif
        let l:last_match = l:curr_line
        if foldlevel(l:curr_line) != 0
            normal! 99zo
        endif
        if l:div == 0 
            if a:hits != 0
                let @z = @z."\n"
            endif
            let l:div = 1
        endif
        normal! 0
        let l:lineno = '     '.l:curr_line
        let @z = @z.'Ln '.strpart(l:lineno, strlen(l:lineno) - l:max).': '
        let l:text = getline(".")
        let @z = @z.strpart(l:text, stridx(l:text, a:word))
        let @z = @z."\n"
        normal! $
        let l:match_count = l:match_count + 1
    endwhile
    return l:match_count
endfunction

" Function: Get line number {{{1
"--------------------------------------------------------------------------
function! s:LineNumber()
    let l:text = getline(".")
    if strpart(l:text, 0, 5) == "File:"
        return 0
    endif
    if strlen(l:text) == 0
        return -1
    endif
    let l:num = matchstr(l:text, '[0-9]\+')
    if l:num == ''
        return -1
    endif
    return l:num
endfunction

" Function: Update document position {{{1
"--------------------------------------------------------------------------
function! s:UpdateDoc()
    let l:line_hit = <sid>LineNumber()

    match none
    if l:line_hit == -1
        redraw
        return
    endif

    let l:buffnr = b:original_buffnr
    exe 'match Search /\%'.line(".").'l.*/'
    if line(".") < (line("$") - (winheight(0) / 2)) + 1
        normal! zz
    endif
    execute bufwinnr(l:buffnr)." wincmd w"
    match none
    if l:line_hit == 0
        normal! 1G
    else
        exe "normal! ".l:line_hit."Gzz"
        exe 'match Search /\%'.line(".").'l.*/'
    endif
    execute bufwinnr('-TaskList_'.l:buffnr.'-')." wincmd w"
    redraw
endfunction

" Function: Clean up on exit {{{1
"--------------------------------------------------------------------------
function! s:Exit(key)

    call <sid>UpdateDoc()
    match none

    let l:original_line = b:original_line
    let l:last_position = line('.')

    if a:key == -1
        nunmap <buffer> e
        nunmap <buffer> q
        nunmap <buffer> <cr>
        execute bufwinnr(b:original_buffnr)." wincmd w"
    else
        bd!
    endif

    let b:last_position = l:last_position

    if a:key == 0
        exe "normal! ".l:original_line."G"
    endif

    match none
    normal! zz

    execute "set updatetime=".s:old_updatetime
endfunction

" Function: Check for screen update {{{1
"--------------------------------------------------------------------------
function! s:CheckForUpdate()
    if stridx(expand("%:t"), '-TaskList_') == -1
        return
    endif
    if b:selected_line != line(".")
        call <sid>UpdateDoc()
        let b:selected_line = line(".")
    endif
endfunction

" Function: Start the search. {{{1
"--------------------------------------------------------------------------
function! s:TaskList()
    let l:original_buffnr = bufnr('%')
    let l:original_line = line(".")

    " last position
    if !exists('b:last_position')
        let b:last_position = 1
    endif
    let l:last_position = b:last_position


    " get file name
    let @z = "File:".expand("%:p")."\n\n"

    " search file
    let l:index = 0
    let l:count = 0
    let l:hits = 0
    while l:index < len(g:tlTokenList)
        let l:search_word = g:tlTokenList[l:index]
        let l:hits = s:SearchFile(l:hits, l:search_word)
        let l:count = l:count + l:hits
        let l:index = l:index + 1
    endwhile

    " Make sure we at least have one hit.
    if l:count == 0
        echohl Search
        echo "tasklist.vim: No task information found."
        echohl None
        execute 'normal! '.l:original_line.'G'
        return
    endif

    " display window
    call s:OpenWindow(l:original_buffnr, l:original_line)

    " restore the cursor position
    if g:tlRememberPosition != 0
        exec 'normal! '.l:last_position.'G'
    else
        normal! gg
    endif

    " Map exit keys
    nnoremap <buffer> <silent> q :call <sid>Exit(0)<cr>
    nnoremap <buffer> <silent> <cr> :call <sid>Exit(1)<cr>
    nnoremap <buffer> <silent> e :call <sid>Exit(-1)<cr>

    " Setup syntax highlight {{{
    syntax match tasklistFileDivider       /^File:.*$/
    syntax match tasklistLineNumber        /^Ln\s\+\d\+:/

    highlight def link tasklistFileDivider  Title
    highlight def link tasklistLineNumber   LineNr
    highlight def link tasklistSearchWord   Search
    " }}}

    " Save globals and change updatetime
    let b:selected_line = line(".")
    let s:old_updatetime = &updatetime
    set updatetime=350

    " update the doc and hook the CheckForUpdate function.
    call <sid>UpdateDoc()
    au! CursorHold <buffer> nested call <sid>CheckForUpdate()

endfunction
"}}}

" Command
command! TaskList call s:TaskList()

" Default key map
if !hasmapto('<Plug>TaskList')
    map <unique> <Leader>T <Plug>TaskList
endif

" Key map to Command
nnoremap <unique> <script> <Plug>TaskList :TaskList<CR>

" vim:fdm=marker:tw=75:ff=unix:
