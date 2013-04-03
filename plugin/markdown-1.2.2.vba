" Vimball Archiver by Charles E. Campbell, Jr., Ph.D.
UseVimball
finish
ftdetect/markdown.vim	[[[1
2
" Markdown
autocmd BufNewFile,BufRead *.{md,mkd,mkdn,mark*} set filetype=markdown
snippets/markdown.snippets	[[[1
43
# [link][]
snippet []
	[${1:link_id}][]${2}
# [link][id]
snippet [[
	[${1:link}][${2:id}]${3}
# [link](url)
snippet [(
	[${1:link}](http://${2:url})${3}
# [link](email)
snippet [@
	[${1:link}(mailto:${2:email})${3}
# [link](url "title")
snippet [("
	[${1:link}](${2:url} "${3:title}")${4}
# [id]: url "title"
snippet [:
	[${1:id}]: http://${2:url} "${3:title}"
# [id]: email "title"
snippet [:@
	[${1:id}]: mailto:${2:url} "${3:title}"
# ![alt][id]
snippet ![
	![${1:alt}][${2:id}]${3}
# ![alt](url)
snippet !(
	![${1:alt}](${2:url})${3}
# ![alt](url "title")
snippet !("
	![${1:alt}](${2:url} "${3:title}")${4}
# *emphasis* or _emphasis_
snippet *
	*${1}*${2}
snippet _
	_${1}_${2}
# **strong** or __strong__
snippet **
	**${1}**${2}
snippet __
	__${1}__${2}
# `code`
snippet `
	\`${1}\`${2}
syntax/markdown.vim	[[[1
110
" Vim syntax file
" Language:     Markdown
" Author:       Ben Williams <benw@plasticboy.com>
" Maintainer:   Hallison Batista <email@hallisonbatista.com>
" URL:          http://plasticboy.com/markdown-vim-mode/
" Version:      1.0.1
" Last Change:  Fri Dec  4 08:36:48 AMT 2009
" Remark:       Uses HTML syntax file
" Remark:       I don't do anything with angle brackets (<>) because that would too easily
"               easily conflict with HTML syntax
" TODO: Handle stuff contained within stuff (e.g. headings within blockquotes)

" Read the HTML syntax to start with
if version < 600
  so <sfile>:p:h/html.vim
else
  runtime! syntax/html.vim
  unlet b:current_syntax
endif

if version < 600
  syntax clear
elseif exists("b:current_syntax")
  finish
endif

" Don't use standard HiLink, it will not work with included syntax files
if version < 508
  command! -nargs=+ HtmlHiLink hi link <args>
else
  command! -nargs=+ HtmlHiLink hi def link <args>
endif

syntax spell toplevel
syntax case ignore
syntax sync linebreaks=1

" Additions to HTML groups
syntax region htmlBold    start=/\\\@<!\(^\|\A\)\@=\*\@<!\*\*\*\@!\S/  end=/\S\\\@<!\*\@<!\*\*\*\@!\($\|\A\)\@=/  contains=htmlItalic,@Spell


syntax region htmlItalic  start=/\\\@<!\(^\|\A\)\@=\*\@<!\*\*\@!\S/    end=/\S\\\@<!\*\@<!\*\*\@!\($\|\A\)\@=/    contains=htmlBold,@Spell
syntax region htmlItalic  start=/\\\@<!\(^\|\A\)\@=\<_\@<!___\@!\S/      end=/\S\\\@<!_\@<!___\@!\($\|\A\)\@=/       contains=htmlBold,@Spell
syntax region htmlItalic  start=/\\\@<!\(^\|\A\)\@=\<_\@<!__\@!\S/       end=/\S\\\@<!_\@<!__\@!\($\|\A\)\@=/       contains=htmlBold,@Spell

" [link](URL) | [link][id] | [link][]
syntax region mkdLink matchgroup=mkdDelimiter start="\!\?\["  end="\]\ze\s*[[(]" contains=@Spell nextgroup=mkdURL,mkdID skipwhite
syntax region mkdID   matchgroup=mkdDelimiter start="\["      end="\]" contained
syntax region mkdURL  matchgroup=mkdDelimiter start="("       end=")"  contained

" Link definitions: [id]: URL (Optional Title)
" TODO handle automatic links without colliding with htmlTag (<URL>)
syntax region mkdLinkDef matchgroup=mkdDelimiter   start="^ \{,3}\zs\[" end="]:" oneline nextgroup=mkdLinkDefTarget skipwhite
syntax region mkdLinkDefTarget start="<\?\zs\S" excludenl end="\ze[>[:space:]\n]"   contained nextgroup=mkdLinkTitle,mkdLinkDef skipwhite skipnl oneline
syntax region mkdLinkTitle matchgroup=mkdDelimiter start=+"+     end=+"+  contained
syntax region mkdLinkTitle matchgroup=mkdDelimiter start=+'+     end=+'+  contained
syntax region mkdLinkTitle matchgroup=mkdDelimiter start=+(+     end=+)+  contained

" Define Markdown groups
syntax match  mkdLineContinue ".$" contained
syntax match  mkdRule      /^\s*\*\s\{0,1}\*\s\{0,1}\*$/
syntax match  mkdRule      /^\s*-\s\{0,1}-\s\{0,1}-$/
syntax match  mkdRule      /^\s*_\s\{0,1}_\s\{0,1}_$/
syntax match  mkdRule      /^\s*-\{3,}$/
syntax match  mkdRule      /^\s*\*\{3,5}$/
syntax match  mkdListItem  /^\s*[-*+]\s\+.*\n\(\(^.\+\n\)*\n\?\)\(\(^\(\s\{4}\|\t\)\+.*\n\)\(^.\+\n\)*\n\?\)*/ contains=mkdListCode,mkdCode,htmlBold,htmlItalic,htmlSpecialChar
syntax match  mkdListItem  /^\s*\d\+\.\s\+.*\n\(\(^.\+\n\)*\n\?\)\(\(^\(\s\{4}\|\t\)\+.*\n\)\(^.\+\n\)*\n\?\)*/ contains=mkdListCode,mkdCode,htmlBold,htmlItalic,htmlSpecialChar
"
syntax match  mkdBlockCode  /^\s*\n\(^\(\s\{4}\|\t\).*\n\)\+/
syntax match  mkdListCode   /^\s*\n\(^\(\s\{8}\|\t{2}\).*\n\)\+/
syntax match  mkdLineBreak /  \+$/
syntax region mkdCode       start=/\\\@<!`/     end=/\\\@<!`/
syntax region mkdCode       start=/\s*``[^`]*/  end=/[^`]*``\s*/
syntax region mkdBlockquote start=/^\s*>/       end=/$/           contains=mkdLineBreak,mkdLineContinue,@Spell
syntax region mkdCode       start="<pre[^>]*>"  end="</pre>"
syntax region mkdCode       start="<code[^>]*>" end="</code>"

" HTML headings
syntax region htmlH1       start="^\s*#"                   end="\($\|#\+\)" contains=@Spell
syntax region htmlH2       start="^\s*##"                  end="\($\|#\+\)" contains=@Spell
syntax region htmlH3       start="^\s*###"                 end="\($\|#\+\)" contains=@Spell
syntax region htmlH4       start="^\s*####"                end="\($\|#\+\)" contains=@Spell
syntax region htmlH5       start="^\s*#####"               end="\($\|#\+\)" contains=@Spell
syntax region htmlH6       start="^\s*######"              end="\($\|#\+\)" contains=@Spell
syntax match  htmlH1       /^.\+\n=\+$/ contains=@Spell
syntax match  htmlH2       /^.\+\n-\+$/ contains=@Spell

"highlighting for Markdown groups
HtmlHiLink mkdString        String
HtmlHiLink mkdCode          String
HtmlHiLink mkdListCode      String
HtmlHiLink mkdBlockCode     String
HtmlHiLink mkdBlockquote    Comment
HtmlHiLink mkdLineContinue  Comment
HtmlHiLink mkdListItem      Identifier
HtmlHiLink mkdRule          Identifier
HtmlHiLink mkdLineBreak     Todo
HtmlHiLink mkdLink          htmlLink
HtmlHiLink mkdURL           htmlString
HtmlHiLink mkdID            Identifier
HtmlHiLink mkdLinkDef       mkdID
HtmlHiLink mkdLinkDefTarget mkdURL
HtmlHiLink mkdLinkTitle     htmlString

HtmlHiLink mkdDelimiter     Delimiter

let b:current_syntax = "markdown"

delcommand HtmlHiLink
" vim: tabstop=2
