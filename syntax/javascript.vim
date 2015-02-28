" Vim syntax file
" Language:     JavaScript
" Maintainer:   Jose Elera Campana <https://github.com/jelera>
" Last Change:  February 6, 2012
" Version:      0.7.9
" Changes:      Go to https://github.com/jelera/vim-javascript-syntax for
"               recent changes.
" Credits:      Zhao Yi, Claudio Fleiner, Scott Shattuck (This file is based
"               on their hard work), gumnos (From the #vim IRC Channel in
"               Freenode)

if !exists("main_syntax")
  if version < 600
    syntax clear
  elseif exists("b:current_syntax")
    finish
  endif
  let main_syntax = 'javascript'
endif

" Drop fold if it set but vim doesn't support it.
if version < 600 && exists("javaScript_fold")
  unlet javaScript_fold
endif

"" dollar sign is permitted anywhere in an identifier
setlocal iskeyword+=$

"" Remove dollar sign from identifier when embedded in a PHP file
if &filetype == 'php'
  setlocal iskeyword-=$
endif

syntax sync fromstart

"" syntax coloring for Node.js shebang line
syn match shebang "^#!.*/bin/env\s\+node\>"
hi link shebang Comment

"" JavaScript comments"{{{
syn keyword javaScriptCommentTodo      TODO FIXME XXX TBD contained
syn match   javaScriptLineComment      "\/\/.*" contains=@Spell,javaScriptCommentTodo
syn match   javaScriptCommentSkip      "^[ \t]*\*\($\|[ \t]\+\)"
syn region  javaScriptComment	       start="/\*"  end="\*/" contains=@Spell,javaScriptCommentTodo
"}}}
"" JSDoc support start"{{{
if !exists("javascript_ignore_javaScriptdoc")
  syntax case ignore

" syntax coloring for JSDoc comments (HTML)
  "unlet b:current_syntax

  syntax region javaScriptDocComment    matchgroup=javaScriptComment start="/\*\*\s*$"  end="\*/" contains=javaScriptDocTags,javaScriptCommentTodo,javaScriptCvsTag,@javaScriptHtml,@Spell fold
  syntax match  javaScriptDocTags       contained "@\(param\|argument\|returns\=\|requires\|exception\|throws\|type\|class\|extends\|see\|link\|member\|module\|method\|title\|namespace\|optional\|default\|base\|file\)\>" nextgroup=javaScriptDocParam,javaScriptDocSeeTag skipwhite
  syntax match  javaScriptDocTags       contained "@\(beta\|deprecated\|description\|fileoverview\|author\|license\|version\|constructor\|private\|protected\|final\|ignore\|addon\|exec\)\>"
  syntax match  javaScriptDocParam      contained "\%(#\|\w\|\.\|:\|\/\)\+"
  syntax region javaScriptDocSeeTag     contained matchgroup=javaScriptDocSeeTag start="{" end="}" contains=javaScriptDocTags

  syntax case match
endif   "" JSDoc end
"}}}
syntax case match

"" Syntax in the JavaScript code"{{{
syn match   javaScriptSpecial	       "\\\d\d\d\|\\."
syn region  javaScriptStringD	       start=+"+  skip=+\\\\\|\\"+  end=+"\|$+	contains=javaScriptSpecial,@htmlPreproc
syn region  javaScriptStringS	       start=+'+  skip=+\\\\\|\\'+  end=+'\|$+	contains=javaScriptSpecial,@htmlPreproc

syn match   javaScriptSpecialCharacter "'\\.'"
syn match   javaScriptNumber	       "-\=\<\d\+L\=\>\|0[xX][0-9a-fA-F]\+\>"
syn region  javaScriptRegexpString     start=+/[^/*]+me=e-1 skip=+\\\\\|\\/+ end=+/[gi]\{0,2\}\s*$+ end=+/[gi]\{0,2\}\s*[;.,)\]}]+me=e-1 contains=@htmlPreproc oneline
" syntax match   javaScriptSpecial        "\\\d\d\d\|\\x\x\{2\}\|\\u\x\{4\}\|\\."
" syntax region  javaScriptStringD        start=+"+  skip=+\\\\\|\\$"+  end=+"+  contains=javaScriptSpecial,@htmlPreproc
" syntax region  javaScriptStringS        start=+'+  skip=+\\\\\|\\$'+  end=+'+  contains=javaScriptSpecial,@htmlPreproc
" syntax region  javaScriptRegexpString   start=+/\(\*\|/\)\@!+ skip=+\\\\\|\\/+ end=+/[gim]\{,3}+ contains=javaScriptSpecial,@htmlPreproc oneline
" syntax match   javaScriptNumber         /\<-\=\d\+L\=\>\|\<0[xX]\x\+\>/
syntax match   javaScriptFloat          /\<-\=\%(\d\+\.\d\+\|\d\+\.\|\.\d\+\)\%([eE][+-]\=\d\+\)\=\>/
" syntax match   javaScriptLabel          /\(?\s*\)\@<!\<\w\+\(\s*:\)\@=/
"}}}
"" JavaScript Prototype"{{{
syntax keyword javaScriptPrototype      prototype
"}}}
"  DOM, Browser and Ajax Support   {{{
""""""""""""""""""""""""
syntax keyword javaScriptBrowserObjects           window navigator screen history location

syntax keyword javaScriptDOMObjects               document event HTMLElement Anchor Area Base Body Button Form Frame Frameset Image Link Meta Option Select Style Table TableCell TableRow Textarea
syntax keyword javaScriptDOMMethods               createTextNode createElement insertBefore replaceChild removeChild appendChild  hasChildNodes  cloneNode  normalize  isSupported  hasAttributes  getAttribute  setAttribute  removeAttribute  getAttributeNode  setAttributeNode  removeAttributeNode  getElementsByTagName  hasAttribute  getElementById adoptNode close compareDocumentPosition createAttribute createCDATASection createComment createDocumentFragment createElementNS createEvent createExpression createNSResolver createProcessingInstruction createRange createTreeWalker elementFromPoint evaluate getBoxObjectFor getElementsByClassName getSelection getUserData hasFocus importNode
syntax keyword javaScriptDOMProperties            nodeName  nodeValue  nodeType  parentNode  childNodes  firstChild  lastChild  previousSibling  nextSibling  attributes  ownerDocument  namespaceURI  prefix  localName  tagName

syntax keyword javaScriptAjaxObjects              XMLHttpRequest
syntax keyword javaScriptAjaxProperties           readyState responseText responseXML statusText
syntax keyword javaScriptAjaxMethods              onreadystatechange abort getAllResponseHeaders getResponseHeader open send setRequestHeader

syntax keyword javaScriptPropietaryObjects        ActiveXObject
syntax keyword javaScriptPropietaryMethods        attachEvent detachEvent cancelBubble returnValue

syntax keyword javaScriptHtmlElemProperties       className  clientHeight  clientLeft  clientTop  clientWidth  dir  href  id  innerHTML  lang  length  offsetHeight  offsetLeft  offsetParent  offsetTop  offsetWidth  scrollHeight  scrollLeft  scrollTop  scrollWidth  style  tabIndex  target  title

syntax keyword javaScriptEventListenerKeywords    blur click focus mouseover mouseout load item

syntax keyword javaScriptEventListenerMethods     scrollIntoView  addEventListener  dispatchEvent  removeEventListener preventDefault stopPropagation
" }}}
"" Programm Keywords"{{{
syntax keyword javaScriptSource         import export
syntax keyword javaScriptIdentifier     arguments this let var void yield
syntax keyword javaScriptOperator       delete new instanceof typeof
syntax keyword javaScriptBoolean        true false
syntax keyword javaScriptNull           null undefined
syntax keyword javaScriptMessage		alert confirm prompt status
syntax keyword javaScriptGlobal         self top parent
syntax keyword javaScriptDeprecated     escape unescape all applets alinkColor bgColor fgColor linkColor vlinkColor xmlEncoding
"}}}
"" Statement Keywords"{{{
syntax keyword javaScriptConditional    if else switch
syntax keyword javaScriptRepeat         do while for in
syntax keyword javaScriptBranch         break continue
syntax keyword javaScriptLabel          case default
syntax keyword javaScriptStatement      return with

syntax keyword javaScriptGlobalObjects  Array Boolean Date Function Infinity Math Number NaN Object Packages RegExp String netscape

syntax keyword javaScriptExceptions     try catch throw finally Error EvalError RangeError ReferenceError SyntaxError TypeError URIError

syntax keyword javaScriptReserved     abstract enum int short boolean export interface static byte extends long super char final native synchronized class float package throws const goto private transient debugger implements protected volatile double import public
"}}}
"" DOM/HTML/CSS specified things"{{{

  " DOM2 Objects"{{{
  syntax keyword javaScriptType  DOMImplementation DocumentFragment Node NodeList NamedNodeMap CharacterData Attr Element Text Comment CDATASection DocumentType Notation Entity EntityReference ProcessingInstruction
  syntax keyword javaScriptExceptions     DOMException
"}}}
  " DOM2 CONSTANT"{{{
  syntax keyword javaScriptDomErrNo       INDEX_SIZE_ERR DOMSTRING_SIZE_ERR HIERARCHY_REQUEST_ERR WRONG_DOCUMENT_ERR INVALID_CHARACTER_ERR NO_DATA_ALLOWED_ERR NO_MODIFICATION_ALLOWED_ERR NOT_FOUND_ERR NOT_SUPPORTED_ERR INUSE_ATTRIBUTE_ERR INVALID_STATE_ERR SYNTAX_ERR INVALID_MODIFICATION_ERR NAMESPACE_ERR INVALID_ACCESS_ERR
  syntax keyword javaScriptDomNodeConsts  ELEMENT_NODE ATTRIBUTE_NODE TEXT_NODE CDATA_SECTION_NODE ENTITY_REFERENCE_NODE ENTITY_NODE PROCESSING_INSTRUCTION_NODE COMMENT_NODE DOCUMENT_NODE DOCUMENT_TYPE_NODE DOCUMENT_FRAGMENT_NODE NOTATION_NODE
"}}}
  " HTML events and internal variables"{{{
  syntax case ignore
  syntax keyword javaScriptHtmlEvents     onblur onclick oncontextmenu ondblclick onfocus onkeydown onkeypress onkeyup onmousedown onmousemove onmouseout onmouseover onmouseup onresize onload onsubmit
  syntax case match
"}}}

" Follow stuff should be highligh within a special context
" While it can't be handled with context depended with Regex based highlight
" So, turn it off by default
if exists("javascript_enable_domhtmlcss")

    " DOM2 things"{{{
    syntax match javaScriptDomElemAttrs     contained /\%(nodeName\|nodeValue\|nodeType\|parentNode\|childNodes\|firstChild\|lastChild\|previousSibling\|nextSibling\|attributes\|ownerDocument\|namespaceURI\|prefix\|localName\|tagName\)\>/
    syntax match javaScriptDomElemFuncs     contained /\%(insertBefore\|replaceChild\|removeChild\|appendChild\|hasChildNodes\|cloneNode\|normalize\|isSupported\|hasAttributes\|getAttribute\|setAttribute\|removeAttribute\|getAttributeNode\|setAttributeNode\|removeAttributeNode\|getElementsByTagName\|getAttributeNS\|setAttributeNS\|removeAttributeNS\|getAttributeNodeNS\|setAttributeNodeNS\|getElementsByTagNameNS\|hasAttribute\|hasAttributeNS\)\>/ nextgroup=javaScriptParen skipwhite
	"}}}
    " HTML things"{{{
    syntax match javaScriptHtmlElemAttrs    contained /\%(className\|clientHeight\|clientLeft\|clientTop\|clientWidth\|dir\|id\|innerHTML\|lang\|length\|offsetHeight\|offsetLeft\|offsetParent\|offsetTop\|offsetWidth\|scrollHeight\|scrollLeft\|scrollTop\|scrollWidth\|style\|tabIndex\|title\)\>/
    syntax match javaScriptHtmlElemFuncs    contained /\%(blur\|click\|focus\|scrollIntoView\|addEventListener\|dispatchEvent\|removeEventListener\|item\)\>/ nextgroup=javaScriptParen skipwhite
"}}}
    " CSS Styles in JavaScript"{{{
    syntax keyword javaScriptCssStyles      contained color font fontFamily fontSize fontSizeAdjust fontStretch fontStyle fontVariant fontWeight letterSpacing lineBreak lineHeight quotes rubyAlign rubyOverhang rubyPosition
    syntax keyword javaScriptCssStyles      contained textAlign textAlignLast textAutospace textDecoration textIndent textJustify textJustifyTrim textKashidaSpace textOverflowW6 textShadow textTransform textUnderlinePosition
    syntax keyword javaScriptCssStyles      contained unicodeBidi whiteSpace wordBreak wordSpacing wordWrap writingMode
    syntax keyword javaScriptCssStyles      contained bottom height left position right top width zIndex
    syntax keyword javaScriptCssStyles      contained border borderBottom borderLeft borderRight borderTop borderBottomColor borderLeftColor borderTopColor borderBottomStyle borderLeftStyle borderRightStyle borderTopStyle borderBottomWidth borderLeftWidth borderRightWidth borderTopWidth borderColor borderStyle borderWidth borderCollapse borderSpacing captionSide emptyCells tableLayout
    syntax keyword javaScriptCssStyles      contained margin marginBottom marginLeft marginRight marginTop outline outlineColor outlineStyle outlineWidth padding paddingBottom paddingLeft paddingRight paddingTop
    syntax keyword javaScriptCssStyles      contained listStyle listStyleImage listStylePosition listStyleType
    syntax keyword javaScriptCssStyles      contained background backgroundAttachment backgroundColor backgroundImage gackgroundPosition backgroundPositionX backgroundPositionY backgroundRepeat
    syntax keyword javaScriptCssStyles      contained clear clip clipBottom clipLeft clipRight clipTop content counterIncrement counterReset cssFloat cursor direction display filter layoutGrid layoutGridChar layoutGridLine layoutGridMode layoutGridType
    syntax keyword javaScriptCssStyles      contained marks maxHeight maxWidth minHeight minWidth opacity MozOpacity overflow overflowX overflowY verticalAlign visibility zoom cssText
    syntax keyword javaScriptCssStyles      contained scrollbar3dLightColor scrollbarArrowColor scrollbarBaseColor scrollbarDarkShadowColor scrollbarFaceColor scrollbarHighlightColor scrollbarShadowColor scrollbarTrackColor
"}}}
    " Highlight ways"{{{
    syntax match javaScriptDotNotation      "\." nextgroup=javaScriptPrototype,javaScriptDomElemAttrs,javaScriptDomElemFuncs,javaScriptHtmlElemAttrs,javaScriptHtmlElemFuncs
    syntax match javaScriptDotNotation      "\.style\." nextgroup=javaScriptCssStyles
"}}}
endif "DOM/HTML/CSS

"" end DOM/HTML/CSS specified things""}}}


"" Code blocks
syntax cluster javaScriptAll       contains=javaScriptComment,javaScriptLineComment,javaScriptDocComment,javaScriptStringD,javaScriptStringS,javaScriptRegexpString,javaScriptNumber,javaScriptFloat,javaScriptLabel,javaScriptSource,javaScriptType,javaScriptOperator,javaScriptBoolean,javaScriptNull,javaScriptFuncKeyword,javaScriptConditional,javaScriptGlobal,javaScriptRepeat,javaScriptBranch,javaScriptStatement,javaScriptGlobalObjects,javaScriptMessage,javaScriptIdentifier,javaScriptExceptions,javaScriptReserved,javaScriptDeprecated,javaScriptDomErrNo,javaScriptDomNodeConsts,javaScriptHtmlEvents,javaScriptDotNotation,javaScriptBrowserObjects,javaScriptDOMObjects,javaScriptAjaxObjects,javaScriptPropietaryObjects,javaScriptDOMMethods,javaScriptHtmlElemProperties,javaScriptDOMProperties,javaScriptEventListenerKeywords,javaScriptEventListenerMethods,javaScriptAjaxProperties,javaScriptAjaxMethods,javaScriptFuncArg

if main_syntax == "javascript"
  syntax sync clear
  syntax sync ccomment javaScriptComment minlines=200
  " syntax sync match javaScriptHighlight grouphere javaScriptBlock /{/
endif

syntax keyword   javaScriptFuncKeyword function contained
syntax region  javaScriptFuncDef start="function" end="\([^)]*\)" contains=javaScriptFuncKeyword,javaScriptFuncArg keepend
syntax match  javaScriptFuncArg "\(([^()]*)\)" contains=javaScriptParens,javaScriptFuncComma contained
syntax match  javaScriptFuncComma /,/ contained
" syntax region  javaScriptFuncBlock      contained matchgroup=javaScriptFuncBlock start="{" end="}" contains=@javaScriptAll,javaScriptParensErrA,javaScriptParensErrB,javaScriptParen,javaScriptBracket,javaScriptBlock fold

syn match	javaScriptBraces	   "[{}\[\]]"
syn match	javaScriptParens	   "[()]"
syn match	javaScriptOpSymbols	   "=\{1,3}\|!==\|!=\|<\|>\|>=\|<=\|++\|+=\|--\|-="
syn match   javaScriptEndColons    "[;,]"
syn match   javaScriptLogicSymbols "\(&&\)\|\(||\)"

" JavaScriptFold Function {{{

function! JavaScriptFold()
	setl foldmethod=syntax
	setl foldlevelstart=1
	syn region foldBraces start=/{/ end=/}/ transparent fold keepend extend

	setl foldtext=FoldText()
endfunction

" }}}

" Define the default highlighting.
" For version 5.7 and earlier: only when not done already
" For version 5.8 and later: only when an item doesn't have highlighting yet
if version >= 508 || !exists("did_javascript_syn_inits")
  if version < 508
    let did_javascript_syn_inits = 1
    command -nargs=+ HiLink hi link <args>
  else
    command -nargs=+ HiLink hi def link <args>
  endif

  HiLink javaScriptEndColons             Exception
  HiLink javaScriptOpSymbols             Operator
  HiLink javaScriptLogicSymbols         Boolean
  HiLink javaScriptBraces	        	Function
  HiLink javaScriptParens	        	Operator
  HiLink javaScriptComment              Comment
  HiLink javaScriptLineComment          Comment
  HiLink javaScriptDocComment           Comment
  HiLink javaScriptCommentTodo          Todo
  HiLink javaScriptCvsTag               Function
  HiLink javaScriptDocTags              Special
  HiLink javaScriptDocSeeTag            Function
  HiLink javaScriptDocParam             Function
  HiLink javaScriptStringS              String
  HiLink javaScriptStringD              String
  HiLink javaScriptRegexpString         String
  HiLink javaScriptGlobal               Constant
  HiLink javaScriptCharacter            Character
  HiLink javaScriptPrototype            Type
  HiLink javaScriptConditional          Conditional
  HiLink javaScriptBranch               Conditional
  HiLink javaScriptIdentifier           Identifier
  HiLink javaScriptRepeat               Repeat
  HiLink javaScriptStatement            Statement
  HiLink javaScriptFuncKeyword             Function
  HiLink javaScriptMessage              Keyword
  HiLink javaScriptDeprecated           Exception
  HiLink javaScriptError                Error
  HiLink javaScriptParensError          Error
  HiLink javaScriptParensErrA           Error
  HiLink javaScriptParensErrB           Error
  HiLink javaScriptParensErrC           Error
  HiLink javaScriptReserved             Keyword
  HiLink javaScriptOperator             Operator
  HiLink javaScriptType                 Type
  HiLink javaScriptNull                 Type
  HiLink javaScriptNumber               Number
  HiLink javaScriptFloat                Number
  HiLink javaScriptBoolean              Boolean
  HiLink javaScriptLabel                Label
  HiLink javaScriptSpecial              Special
  HiLink javaScriptSource               Special
  HiLink javaScriptGlobalObjects        Special
  HiLink javaScriptExceptions           Special

  HiLink javaScriptDomErrNo             Constant
  HiLink javaScriptDomNodeConsts        Constant
  HiLink javaScriptDomElemAttrs         Label
  HiLink javaScriptDomElemFuncs         PreProc

  HiLink javaScriptHtmlElemAttrs        Label
  HiLink javaScriptHtmlElemFuncs        PreProc

  HiLink javaScriptCssStyles            Label

  " Ajax Highlighting
	HiLink javaScriptBrowserObjects     Constant

	HiLink javaScriptDOMObjects         Constant
	HiLink javaScriptDOMMethods         Exception
	HiLink javaScriptDOMProperties      Type

	HiLink javaScriptAjaxObjects        htmlH1
	HiLink javaScriptAjaxMethods        Exception
	HiLink javaScriptAjaxProperties     Type

	HiLink javaScriptFuncDef            Title
    HiLink javaScriptFuncArg            Special
    HiLink javaScriptFuncComma          Operator  

	HiLink javaScriptHtmlEvents         Special
	HiLink javaScriptHtmlElemProperties Type

	HiLink javaScriptEventListenerKeywords Keyword

	HiLink javaScriptNumber            Number
	HiLink javaScriptPropietaryObjects Constant

  delcommand HiLink
endif

" Define the htmlJavaScript for HTML syntax html.vim
"syntax clear htmlJavaScript
"syntax clear javaScriptExpression
syntax cluster  htmlJavaScript contains=@javaScriptAll,javaScriptBracket,javaScriptParen,javaScriptBlock,javaScriptParenError
syntax cluster  javaScriptExpression contains=@javaScriptAll,javaScriptBracket,javaScriptParen,javaScriptBlock,javaScriptParenError,@htmlPreproc

let b:current_syntax = "javascript"
if main_syntax == 'javascript'
  unlet main_syntax
endif

" vim: ts=4
