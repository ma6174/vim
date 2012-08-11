"=============================================================================
"
"     FileName: python.vim
"         Desc: 修改了缩进的bug
"
"       Author: dantezhu - http://www.vimer.cn
"        Email: zny2008@gmail.com
"
"      Created: 2011-02-21 23:55:50
"      Version: 0.0.9
"      History:
"               0.0.9 | dantezhu | 2011-03-15 10:15:05 | 注释和string不缩进
"               0.0.8 | dantezhu | 2011-03-10 18:41:15 | 之前修正的有点问题
"               0.0.7 | dantezhu | 2011-03-10 11:06:01 | 向cindent看齐，函数名
"                                                      | 太短则和匹配的地方对齐
"               0.0.6 | dantezhu | 2011-02-26 23:45:18 | 只约束是字母太弱了，
"                                                      | 还有数字和下划线
"               0.0.5 | dantezhu | 2011-02-26 23:28:16 | 修正对调用函数时，多
"                                                      | 行参数的)的缩进
"               0.0.4 | dantezhu | 2011-02-24 19:32:14 | 之前的fix有问题，重写
"               0.0.3 | dantezhu | 2011-02-22 14:53:40 | 修正了Comment或者
"                                                      | String中存在:时就会缩
"                                                      | 进的问题
"               0.0.2 | dantezhu | 2011-02-22 01:15:53 | 增加了对class,if,elif
"                                                      | 等的兼容
"               0.0.1 | dantezhu | 2011-02-21 23:55:50 | initialization
"
"=============================================================================

" Python indent file
" Language:	    Python
" Maintainer:	    Eric Mc Sween <em@tomcom.de>
" Original Author:  David Bustos <bustos@caltech.edu> 
" Last Change:      2004 Jun 07

" Only load this indent file when no other was loaded.
if exists("b:did_indent")
    finish
endif
let b:did_indent = 1

setlocal expandtab
setlocal nolisp
setlocal autoindent
setlocal indentexpr=GetPythonIndent(v:lnum)
setlocal indentkeys=!^F,o,O,<:>,0),0],0},=elif,=except

let s:maxoff = 50

" Find backwards the closest open parenthesis/bracket/brace.
function! s:SearchParensPair()
    let line = line('.')
    let col = col('.')
    
    " Skip strings and comments and don't look too far
    let skip = "line('.') < " . (line - s:maxoff) . " ? dummy :" .
                \ 'synIDattr(synID(line("."), col("."), 0), "name") =~? ' .
                \ '"string\\|comment"'

    " Search for parentheses
    call cursor(line, col)
    let parlnum = searchpair('(', '', ')', 'bW', skip)
    let parcol = col('.')

    " Search for brackets
    call cursor(line, col)
    let par2lnum = searchpair('\[', '', '\]', 'bW', skip)
    let par2col = col('.')

    " Search for braces
    call cursor(line, col)
    let par3lnum = searchpair('{', '', '}', 'bW', skip)
    let par3col = col('.')

    " Get the closest match
    if par2lnum > parlnum || (par2lnum == parlnum && par2col > parcol)
        let parlnum = par2lnum
        let parcol = par2col
    endif
    if par3lnum > parlnum || (par3lnum == parlnum && par3col > parcol)
        let parlnum = par3lnum
        let parcol = par3col
    endif 

    " Put the cursor on the match
    if parlnum > 0
        call cursor(parlnum, parcol)
    endif
    return parlnum
endfunction

" Find the start of a multi-line statement
function! s:StatementStart(lnum)
    let lnum = a:lnum
    while 1
        if getline(lnum - 1) =~ '\\$'
            let lnum = lnum - 1
        else
            call cursor(lnum, 1)
            let maybe_lnum = s:SearchParensPair()
            if maybe_lnum < 1
                return lnum
            else
                let lnum = maybe_lnum
            endif
        endif
    endwhile
endfunction

" Find the block starter that matches the current line
function! s:BlockStarter(lnum, block_start_re)
    let lnum = a:lnum
    let maxindent = 10000       " whatever
    while lnum > 1
        let lnum = prevnonblank(lnum - 1)
        if indent(lnum) < maxindent
            if getline(lnum) =~ a:block_start_re
                return lnum
            else 
                let maxindent = indent(lnum)
                " It's not worth going further if we reached the top level
                if maxindent == 0
                    return -1
                endif
            endif
        endif
    endwhile
    return -1
endfunction
                
function! GetPythonIndent(lnum)

    " First line has indent 0
    if a:lnum == 1
        return 0
    endif

"Add-Begin by dantezhu in 2011-03-15 10:14:01
"修正注释和字符串缩进的问题
    " If the start of the line is in a string don't change the indent.
    if has('syntax_items')
               \ && synIDattr(synID(a:lnum, col('.')-1, 1), 'name') =~ '\(Comment\|String\)$'
       return -1
    endif
"Add-End

    " If we can find an open parenthesis/bracket/brace, line up with it.
    call cursor(a:lnum, 1)
    let parlnum = s:SearchParensPair()
    if parlnum > 0
        let parcol = col('.')
        let closing_paren = match(getline(a:lnum), '^\s*[])}]') != -1
        if match(getline(parlnum), '[([{]\s*$', parcol - 1) != -1
            if closing_paren
                "Mod-Begin by dantezhu in 2011-02-21 23:38:24
                "FROM
                "return indent(parlnum)
                "TO
                "为了支持如下的格式:
                "def fun(
                "    a,
                "    b
                "    ):
                "    print a,b
                "又不影响如下格式:
                "val = {
                "    (
                "        1,
                "        2
                "    ):1
                "}

                "Add-Begin by dantezhu in 2011-02-26 23:23:08
                "增加了对
                "x = user.getdata1_(
                "   a,
                "   b,
                "   c
                "   )
                "的支持
                if match(getline(parlnum), '\(\a\|\d\|_\)\s*(\s*$', 0) != -1
                    "增加了对
                    "x(
                    "    1,
                    "    2,
                    "    3
                    " )
                    "user.login(
                    "    1,
                    "    2,
                    "    3
                    "    )
                    " 的支持
                    if (parcol -1 - indent(parlnum)) < 4
                        return parcol - 1
                    else
                        return indent(parlnum) + &sw
                    endif
                endif
                "Add-End
                if match(getline(a:lnum), ')\s*:') != -1 && 
                            \ match(getline(parlnum), '\(def\|class\|if\|elif\|while\)\(\s\+\|(\)') != -1
                    return indent(parlnum) + &sw
                else
                    return indent(parlnum)
                endif
                "Mod-End
            else
                return indent(parlnum) + &sw
            endif
        else
            if closing_paren
                return parcol - 1
            else
                return parcol
            endif
        endif
    endif

    " Examine this line
    let thisline = getline(a:lnum)
    let thisindent = indent(a:lnum)

    " If the line starts with 'elif' or 'else', line up with 'if' or 'elif'
    if thisline =~ '^\s*\(elif\|else\)\>'
        let bslnum = s:BlockStarter(a:lnum, '^\s*\(if\|elif\)\>')
        if bslnum > 0
            return indent(bslnum)
        else
            return -1
        endif
    endif

    " If the line starts with 'except' or 'finally', line up with 'try'
    " or 'except'
    if thisline =~ '^\s*\(except\|finally\)\>'
        let bslnum = s:BlockStarter(a:lnum, '^\s*\(try\|except\)\>')
        if bslnum > 0
            return indent(bslnum)
        else
            return -1
        endif
    endif

    " Examine previous line
    let plnum = a:lnum - 1
    let pline = getline(plnum)
    let sslnum = s:StatementStart(plnum)

    " If the previous line is blank, keep the same indentation
    if pline =~ '^\s*$'
        return -1
    endif

    " If this line is explicitly joined, try to find an indentation that looks
    " good. 
    if pline =~ '\\$'
        let compound_statement = '^\s*\(if\|while\|for\s.*\sin\|except\)\s*'
            let maybe_indent = matchend(getline(sslnum), compound_statement)
            if maybe_indent != -1
                return maybe_indent
            else
                return indent(sslnum) + &sw * 2
            endif
        endif

        " If the previous line ended with a colon, indent relative to
        " statement start.
        if pline =~ ':\s*$'
            "Mod-Begin by dantezhu in 2011-02-24 19:30:52
            "FROM
            "return indent(sslnum) + &sw
            "TO
            let t_col = match(pline,':\s*$')+1
            if synIDattr(synID(a:lnum-1, t_col, 1), 'name') !~ '\(Comment\|String\)$'
                return indent(sslnum) + &sw
            endif
            "Mod-End
        endif

        " If the previous line was a stop-execution statement or a pass
        if getline(sslnum) =~ '^\s*\(break\|continue\|raise\|return\|pass\)\>'
            " See if the user has already dedented
            if indent(a:lnum) > indent(sslnum) - &sw
                " If not, recommend one dedent
                return indent(sslnum) - &sw
            endif
            " Otherwise, trust the user
            return -1
        endif

        " In all other cases, line up with the start of the previous statement.
        return indent(sslnum)
    endfunction
