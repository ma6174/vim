"==================================================
" File:         echofunc.vim
" Brief:        Echo the function declaration in
"               the command line for C/C++, as well
"               as other languages that ctags
"               supports.
" Authors:      Ming Bai <mbbill AT gmail DOT com>,
"               Wu Yongwei <wuyongwei AT gmail DOT com>
" Last Change:  2012-02-04 19:18:00
" Version:      2.0
"
" Install:      1. Put echofunc.vim to /plugin directory.
"               2. Use the command below to create tags
"                  file including the language and
"                  signature fields.
"                    ctags -R --fields=+lS .
"
" Usage:        When you type '(' after a function name
"               in insert mode, the function declaration
"               will be displayed in the command line
"               automatically. Then you may use Alt+- and
"               Alt+= (configurable via EchoFuncKeyPrev
"               and EchoFuncKeyNext) to cycle between
"               function declarations (if exists).
"
"               Another feature is to provide a balloon tip
"               when the mouse cursor hovers a function name,
"               macro name, etc. This works with when
"               +balloon_eval is compiled in.
"
"               Because the message line often cleared by
"               some other plugins (e.g. ominicomplete), an
"               other choice is to show message in status line.
"               First, add  %{EchoFuncGetStatusLine()}  to
"               your 'statusline' option.
"               Second, add the following line to your vimrc
"               let g:EchoFuncShowOnStatus = 1
"               to avoid echoing function name in message line.
"
" Options:      g:EchoFuncLangsDict
"                 Dictionary to map the Vim file types to
"                 tags languages that should be used. You do
"                 not need to touch it in most cases.
"
"               g:EchoFuncLangsUsed
"                 File types to enable echofunc, in case you
"                 do not want to use EchoFunc on all file
"                 types supported. Example:
"                   let g:EchoFuncLangsUsed = ["java","cpp"]
"
"               g:EchoFuncMaxBalloonDeclarations
"                 Maximum lines to display in balloon declarations.
"
"               g:EchoFuncKeyNext
"                 Key to echo the next function.
"
"               g:EchoFuncKeyPrev
"                 Key to echo the previous function.
"
"               g:EchoFuncShowOnStatus
"                 Show function name on status line. NOTE,
"                 you should manually add %{EchoFuncGetStatusLine()}
"                 to your 'statusline' option.
"
"               g:EchoFuncAutoStartBalloonDeclaration
"                 Automatically start balloon declaration if not 0.
"
"               g:EchoFuncPathMappingEnabled
"               g:EchoFuncPathMapping
"                 The new feature added by Zhao Cai provides ability
"                 to shorten file path in some specific directory. e.g.
"                 /home/username/veryveryvery/long/file/path/blabla
"                 could be showed as
"                 ~/veryveryvery/long/file/path/blabla
"                 If you want to disable this feature, add
"                 let g:EchoFuncPathMappingEnabled = 0
"                 to your vimrc. It's enabled by default.
"                 To add more mappings in g:EchoFuncPathMapping, search
"                 this script and you will know how to do it.
"
"
" Thanks:       edyfox
"               minux
"               Zhao Cai
"
"==================================================

if &compatible == 1
    finish
endif

" Vim version 7.x is needed.
if v:version < 700
     echohl ErrorMsg | echomsg "Echofunc.vim needs vim version >= 7.0!" | echohl None
     finish
endif

" Change cpoptions to make sure line continuation works
let s:cpo_save=&cpo
set cpo&vim

let s:res=[]
let s:count=1

if !exists("g:EchoFuncPathMapping")
	" Note: longest match first
	let g:EchoFuncPathMapping = [
				\ [expand("$HOME") , '~'],
				\ [expand("$VIM") , '$VIM']
				\]
endif

if !exists("g:EchoFuncPathMappingEnabled")
	let g:EchoFuncPathMappingEnabled = 1
endif

func! s:EchoFuncPathMapping(path)
    if g:EchoFuncPathMappingEnabled != 1
        return a:path
    endif
	let l:path = a:path
	for item in g:EchoFuncPathMapping
		"let l:path = substitute(l:path, escape(item[0],'/'), escape(item[1],'/'), 'ge' )
		let l:path = substitute(l:path, '\V'.escape(item[0],'\'), item[1], 'ge' )
	endfor
	return l:path
endf

function! EchoFuncGetStatusLine()
    if len(s:res) == 0
        return ''
    endif
    return '[' . substitute(s:res[s:count-1],'^\s*','','') . ']'
endfunction

function! s:EchoFuncDisplay()
    if len(s:res) == 0
        return
    endif
    if g:EchoFuncShowOnStatus == 1
        exec "redrawstatus"
        return
    endif

    set noshowmode
    let content=s:res[s:count-1]
    let wincols=&columns
    let allowedheight=&lines/5
    let statusline=(&laststatus==1 && winnr('$')>1) || (&laststatus==2)
    let reqspaces_lastline=(statusline || !&ruler) ? 12 : 29
    let width=len(content)
    let height=width/wincols+1
    let cols_lastline=width%wincols
    if cols_lastline > wincols-reqspaces_lastline
        let height=height+1
    endif
    if height > allowedheight
        let height=allowedheight
    endif
    let &cmdheight=height
    echohl Type | echo content | echohl None
endfunction

" add this function to avoid E432
function! s:CallTagList(str)
    let ftags = []
    try
        let ftags=taglist(a:str)
    catch /^Vim\%((\a\+)\)\=:E/
        " if error occured, reset tagbsearch option and try again.
        let bak=&tagbsearch
        set notagbsearch
        let ftags=taglist(a:str)
        let &tagbsearch=bak
    endtry
    return ftags
endfunction

function! s:GetFunctions(fun, fn_only)
    let s:res=[]
    let funpat=escape(a:fun,'[\*~^')
    let ftags=s:CallTagList('^'.funpat.'$')

    if (type(ftags)==type(0) || ((type(ftags)==type([])) && ftags==[]))
        if &filetype=='cpp' && funpat!~'^\(catch\|if\|for\|while\|switch\)$'
            " Namespaces may be omitted
            let ftags=s:CallTagList('::'.funpat.'$')
            if (type(ftags)==type(0) || ((type(ftags)==type([])) && ftags==[]))
                return
            endif
        endif
    endif
    let fil_tag=[]
    for i in ftags
        if !has_key(i,'name')
            continue
        endif
        if has_key(i,'language')
            if !has_key(g:EchoFuncLangsDict,&filetype)
                continue
            endif
            if eval('index(g:EchoFuncLangsDict.' . &filetype . ',i.language)')
                        \== -1
                continue
            endif
        endif
        if has_key(i,'kind')
            " p: prototype/procedure; f: function; m: member
            if (!a:fn_only || (i.kind=='p' || i.kind=='f') ||
                        \(i.kind == 'm' && has_key(i,'cmd') &&
                        \                  match(i.cmd,'(') != -1)) &&
                        \i.name=~funpat
                if &filetype!='cpp' || !has_key(i,'class') ||
                            \i.name!~'::' || i.name=~i.class
                    let fil_tag+=[i]
                endif
            endif
        else
            if !a:fn_only && i.name == a:fun
                let fil_tag+=[i]
            endif
        endif
    endfor
    if fil_tag==[]
        return
    endif
    let s:count=1
    for i in fil_tag
        if has_key(i,'kind') && has_key(i,'name') && has_key(i,'signature')
            let tmppat=substitute(escape(i.name,'[\*~^'),'^.*::','','')
            if &filetype == 'cpp'
                let tmppat=substitute(tmppat,'\<operator ','operator\\s*','')
                "let tmppat=substitute(tmppat,'^\(.*::\)','\\(\1\\)\\?','')
                let tmppat=tmppat . '\s*(.*'
                let tmppat='\([A-Za-z_][A-Za-z_0-9]*::\)*'.tmppat
            else
                let tmppat=tmppat . '\>.*'
            endif
            let name=substitute(i.cmd[2:-3],tmppat,'','').i.name.i.signature
        elseif has_key(i,'kind')
            if i.kind == 'd'
                let name='macro ' . i.name
            elseif i.kind == 'c'
                let name='class ' . i.name
            elseif i.kind == 's'
                let name='struct ' . i.name
            elseif i.kind == 'u'
                let name='union ' . i.name
            elseif (match('fpmvt',i.kind) != -1) &&
                        \(has_key(i,'cmd') && i.cmd[0] == '/')
                let tmppat='\(\<'.i.name.'\>.\{-}\)'
                if &filetype == 'c' ||
                            \&filetype == 'cpp' ||
                            \&filetype == 'cs' ||
                            \&filetype == 'java' ||
                            \&filetype == 'javascript'
                    let tmppat=tmppat . ';.*'
                elseif &filetype == 'python' &&
                            \(i.kind == 'm' || i.kind == 'f')
                    let tmppat=tmppat . ':.*'
                elseif &filetype == 'tcl' &&
                            \(i.kind == 'm' || i.kind == 'p')
                    let tmppat=tmppat . '\({\)\?$'
                endif
                if i.kind == 'm' && &filetype == 'cpp'
                    let tmppat=substitute(tmppat,'^\(.*::\)','\\(\1\\)\\?','')
                endif
                if match(i.cmd[2:-3],tmppat) != -1
                    let name=substitute(i.cmd[2:-3],tmppat,'\1','')
                    if i.kind == 't' && name !~ '^\s*typedef\>'
                        let name='typedef ' . i.name
                    endif
                elseif i.kind == 't'
                    let name='typedef ' . i.name
                elseif i.kind == 'v'
                    let name='var ' . i.name
                else
                    let name=i.name
                endif
                if i.kind == 'm'
                    if has_key(i,'class')
                        let name=name . ' <-- class ' . i.class
                    elseif has_key(i,'struct')
                        let name=name . ' <-- struct ' . i.struct
                    elseif has_key(i,'union')
                        let name=name . ' <-- union ' . i.union
                    endif
                endif
            else
                let name=i.name
            endif
        else
            let name=i.name
        endif
        let name=substitute(name,'^\s\+','','')
        let name=substitute(name,'\s\+$','','')
        let name=substitute(name,'\s\+',' ','g')
        let file_line=s:EchoFuncPathMapping(i.filename)
        if i.cmd > 0
            let file_line=file_line . ':' . i.cmd
        endif
        let s:res+=[name.' ('.(index(fil_tag,i)+1).'/'.len(fil_tag).') '.file_line]
    endfor
endfunction

function! s:GetFuncName(text)
    let name=substitute(a:text,'.\{-}\(\(\k\+::\)*\(\~\?\k*\|'.
                \'operator\s\+new\(\[]\)\?\|'.
                \'operator\s\+delete\(\[]\)\?\|'.
                \'operator\s*[[\]()+\-*/%<>=!~\^&|]\+'.
                \'\)\)\s*$','\1','')
    if name =~ '\<operator\>'  " tags have exactly one space after 'operator'
        let name=substitute(name,'\<operator\s*','operator ','')
    endif
    return name
endfunction

function! EchoFunc()
    let name=s:GetFuncName(getline('.')[:(col('.')-3)])
    if name==''
        return ''
    endif
    call s:GetFunctions(name, 1)
    call s:EchoFuncDisplay()
    return ''
endfunction

function! EchoFuncN()
    if s:res==[]
        return ''
    endif
    if s:count==len(s:res)
        let s:count=1
    else
        let s:count+=1
    endif
    call s:EchoFuncDisplay()
    return ''
endfunction

function! EchoFuncP()
    if s:res==[]
        return ''
    endif
    if s:count==1
        let s:count=len(s:res)
    else
        let s:count-=1
    endif
    call s:EchoFuncDisplay()
    return ''
endfunction

function! EchoFuncStart()
    if exists('b:EchoFuncStarted')
        return
    endif
    let b:EchoFuncStarted=1
    let s:ShowMode=&showmode
    let s:CmdHeight=&cmdheight
    inoremap <silent> <buffer>  (   (<c-r>=EchoFunc()<cr>
    inoremap <silent> <buffer>  )    <c-r>=EchoFuncClear()<cr>)
    exec 'inoremap <silent> <buffer> ' . g:EchoFuncKeyNext . ' <c-r>=EchoFuncN()<cr>'
    exec 'inoremap <silent> <buffer> ' . g:EchoFuncKeyPrev . ' <c-r>=EchoFuncP()<cr>'
endfunction

function! EchoFuncClear()
    echo ''
    let s:res=[]
    return ''
endfunction

function! EchoFuncStop()
    if !exists('b:EchoFuncStarted')
        return
    endif
    iunmap      <buffer>    (
    iunmap      <buffer>    )
    exec 'iunmap <buffer> ' . g:EchoFuncKeyNext
    exec 'iunmap <buffer> ' . g:EchoFuncKeyPrev
    unlet b:EchoFuncStarted
endfunction

function! s:RestoreSettings()
    if !exists('b:EchoFuncStarted')
        return
    endif
    if s:ShowMode
        set showmode
    endif
    exec "set cmdheight=".s:CmdHeight
    echo
endfunction

function! BalloonDeclaration()
    let line=getline(v:beval_lnum)
    let pos=v:beval_col - 1
    let endpos=match(line, '\W', pos)
    if endpos != -1 && &filetype == 'cpp'
        if v:beval_text == 'operator'
            if line[endpos :] =~ '^\s*\(new\(\[]\)\?\|delete\(\[]\)\?\|[[\]+\-*/%<>=!~\^&|]\+\|()\)'
                let endpos=matchend(line, '^\s*\(new\(\[]\)\?\|delete\(\[]\)\?\|[[\]+\-*/%<>=!~\^&|]\+\|()\)',endpos)
            endif
        elseif v:beval_text == 'new' || v:beval_text == 'delete'
            if line[:endpos+1] =~ 'operator\s\+\(new\|delete\)\[]$'
                let endpos=endpos+2
            endif
        endif
    endif
    if (endpos != -1)
        let endpos=endpos - 1
    endif
    let name=s:GetFuncName(line[0:endpos])
    if name==''
        return ''
    endif
    call s:GetFunctions(name, 0)
    let result = ""
    let cnt=0
    for item in s:res
        if cnt < g:EchoFuncMaxBalloonDeclarations
            let result = result . item . "\n"
        endif
        let cnt=cnt+1
    endfor
    return strpart(result, 0, len(result) - 1)
endfunction

function! BalloonDeclarationStart()
    set ballooneval
    set balloonexpr=BalloonDeclaration()
endfunction

function! BalloonDeclarationStop()
    set balloonexpr=
    set noballooneval
endfunction

if !exists('g:EchoFuncLangsDict')
    let g:EchoFuncLangsDict={
                \ 'asm':['Asm'],
                \ 'aspvbs':['Asp'],
                \ 'awk':['Awk'],
                \ 'basic':['Basic'],
                \ 'c':['C','C++'],
                \ 'cpp':['C','C++'],
                \ 'cs':['C#'],
                \ 'cobol':['Cobol'],
                \ 'eiffel':['Eiffel'],
                \ 'erlang':['Erlang'],
                \ 'fortran':['Fortran'],
                \ 'html':['HTML'],
                \ 'java':['Java'],
                \ 'javascript':['JavaScript'],
                \ 'lisp':['Lisp'],
                \ 'lua':['Lua'],
                \ 'make':['Make'],
                \ 'pascal':['Pascal'],
                \ 'perl':['Perl'],
                \ 'php':['PHP'],
                \ 'python':['Python'],
                \ 'rexx':['REXX'],
                \ 'ruby':['Ruby'],
                \ 'scheme':['Scheme'],
                \ 'sh':['Sh'],
                \ 'zsh':['Sh'],
                \ 'sql':['SQL'],
                \ 'slang':['SLang'],
                \ 'sml':['SML'],
                \ 'tcl':['Tcl'],
                \ 'vera':['Vera'],
                \ 'verilog':['verilog'],
                \ 'vim':['Vim'],
                \ 'yacc':['YACC']}
endif

if !exists("g:EchoFuncLangsUsed")
    let g:EchoFuncLangsUsed=sort(keys(g:EchoFuncLangsDict))
endif

if !exists("g:EchoFuncMaxBalloonDeclarations")
    let g:EchoFuncMaxBalloonDeclarations=20
endif

if !exists("g:EchoFuncKeyNext")
    if has ("mac")
        let g:EchoFuncKeyNext='≠'
    else
        let g:EchoFuncKeyNext='<M-=>'
    endif
endif

if !exists("g:EchoFuncKeyPrev")
    if has ("mac")
        let g:EchoFuncKeyPrev='±'
    else
        let g:EchoFuncKeyPrev='<M-->'
    endif
endif

if !exists("g:EchoFuncShowOnStatus")
    let g:EchoFuncShowOnStatus = 0
endif

if !exists("g:EchoFuncAutoStartBalloonDeclaration")
    let g:EchoFuncAutoStartBalloonDeclaration = 1
endif

function! s:CheckTagsLanguage(filetype)
    return index(g:EchoFuncLangsUsed, a:filetype) != -1
endfunction

function! CheckedEchoFuncStart()
    if s:CheckTagsLanguage(&filetype)
        call EchoFuncStart()
    endif
endfunction

function! CheckedBalloonDeclarationStart()
    if s:CheckTagsLanguage(&filetype) && g:EchoFuncAutoStartBalloonDeclaration
        call BalloonDeclarationStart()
    endif
endfunction

function! s:EchoFuncInitialize()
    augroup EchoFunc
        autocmd!
        autocmd InsertLeave * call s:RestoreSettings()
        autocmd BufRead,BufNewFile * call CheckedEchoFuncStart()
        if has('gui_running')
            menu    &Tools.Echo\ F&unction.Echo\ F&unction\ Start   :call EchoFuncStart()<CR>
            menu    &Tools.Echo\ F&unction.Echo\ Function\ Sto&p    :call EchoFuncStop()<CR>
        endif

        if has("balloon_eval")
            autocmd BufRead,BufNewFile * call CheckedBalloonDeclarationStart()
            if has('gui_running')
                menu    &Tools.Echo\ Function.&Balloon\ Declaration\ Start  :call BalloonDeclarationStart()<CR>
                menu    &Tools.Echo\ Function.Balloon\ Declaration\ &Stop   :call BalloonDeclarationStop()<CR>
            endif
        endif
    augroup END

    call CheckedEchoFuncStart()
    if has("balloon_eval")
        call CheckedBalloonDeclarationStart()
    endif
endfunction

augroup EchoFunc
    autocmd BufRead,BufNewFile * call s:EchoFuncInitialize()
augroup END

" Restore cpoptions
let &cpo=s:cpo_save

" vim: set et sts=4 sw=4:
