" Vimball Archiver by Charles E. Campbell, Jr., Ph.D.
UseVimball
finish
colors/bandit.vim	[[[1
260
" vim: tw=0 ts=4 sw=4 noet ft=colours_bandit foldmethod=diff
" Vim colour file
" Maintainer:	A. S. Budden

hi clear
if exists("syntax_on")
  syntax reset
endif
let g:colors_name = "bandit"

let ColourAssignment = {}

" Unspecified colours default to NONE, EXCEPT cterm(.*) which default to matching gui(.*)
" ctermfg will default to 'Blue' and ctermbg to 'NONE' if gui(.*) are RGB
"
" In most cases, only GUIFG is therefore important unless support for Black and White
" terminals is essential

" By default, assume the background colour is dark (changes for light backgrounds are handled later)
let ColourAssignment['Normal']          = {"GUIFG": 'White',       "GUIBG":  'Black'}

" Comments are green
let ColourAssignment['Comment']         = {"GUIFG": '#00ff00',     "CTERMFG": 'Green',     "TERM":   'Bold'}

" These are considered to be a different sort of comment, so they get a different shade
" of green: this also allows the doxygen todo error highlighter to be able to spot
" erroneous @todo flags in non-doxygen comments (requires Doxygen Comment Matcher)
let ColourAssignment['DoxygenComment']  = {"GUIFG": '#008800',     "CTERMFG": 'Green',     "TERM":  'Bold'}
let ColourAssignment['DoxygenKeyword']  = {"GUIFG": '#88ffdd',     "CTERMFG": 'Blue'}
let ColourAssignment['DoxygenLink']     = {"GUIFG": '#8888ff',     "CTERMFG": 'Blue'}
let ColourAssignment['DoxygenTable']    = {"GUIFG": '#00bb00',     "CTERMFG": 'Green',     "TERM":  'Bold'}
let ColourAssignment['DoxygenTableLines']  = {"GUIFG": '#88ffdd',     "CTERMFG": 'Blue'}

" These are PC-Lint related comments
let ColourAssignment['LintComment']     = {"GUIFG": '#00ff88',     "CTERMFG": 'Green',     "TERM":  'Bold'}

" Constants are shades of yellow or brown
let ColourAssignment['Constant']        = {"GUIFG": '#FFFF66',     "CTERMFG": 'Yellow',    "TERM":  'Underline'}
let ColourAssignment['String']          = {"GUIFG": 'LightYellow'}
let ColourAssignment['Character']       = {"GUIFG": 'DarkYellow'}

" Preprocessor directives are bold shades of blue
let ColourAssignment['PreProc']         = {"GUIFG": 'Blue',        "GUI":     'Bold',      "TERM":  'Underline'}
let ColourAssignment['Include']         = {"GUIFG": 'Blue',        "GUI":     'Bold'} " preprocessor #include
let ColourAssignment['Define']          = {"GUIFG": '#5555FF',     "GUI":     'Bold'} " preprocessor #define
let ColourAssignment['Macro']           = {"GUIFG": '#5555FF',     "GUI":     'Bold'} " same as Define
let ColourAssignment['PreCondit']       = {"GUIFG": '#8888FF',     "GUI":     'Bold'} " preprocessor #if, #else, #endif, etc.

" Statements are shades of Blue
let ColourAssignment['Statement']       = {"GUIFG": 'Blue',        "TERM":    'Bold'}
let ColourAssignment['Conditional']     = {"GUIFG": '#5555FF'} " if, then, else, endif, switch, etc.
let ColourAssignment['Repeat']          = {"GUIFG": '#8888FF'} " for, do, while, etc.
let ColourAssignment['Label']           = {"GUIFG": '#2222FF'} " case, default, etc.
let ColourAssignment['Exception']       = {"GUIFG": '#5555AA'} " try, catch, throw

" Identifiers are shades of Cyan
let ColourAssignment['Identifier']      = {"GUIFG": 'Cyan',        "TERM":    'Underline'}
let ColourAssignment['Function']        = {"GUIFG": '#007777',     "CTERMFG": 'Cyan'}

" Special additions created by mktypes.py are shades of Purple or Grey
let ColourAssignment['ClassName']       = {"GUIFG": 'Purple',      "GUI":     'Bold',      "TERM":  'Underline'}
let ColourAssignment['DefinedName']     = {"GUIFG": '#ee82ee',     "TERM":    'Underline'}
let ColourAssignment['Enumerator']      = {"GUIFG": '#c000c0'}
let ColourAssignment['EnumerationName'] = {"GUIFG": '#c000c0',     "GUI":     'Bold',      "TERM":  'Underline'}
let ColourAssignment['Member']          = {"GUIFG": 'DarkGrey',    "TERM":    'Underline'}
let ColourAssignment['Union']           = {"GUIFG": 'Grey',        "TERM":    'Underline'}
let ColourAssignment['GlobalVariable']  = {"GUIFG": '#666600',     "CTERMFG": 'Cyan',      "TERM":  'Underline'}
let ColourAssignment['LocalVariable']   = {"GUIFG": '#aaa14c',     "CTERMFG": 'Cyan'}
let ColourAssignment['GlobalConstant']  = {"GUIFG": '#bbbb00',     "CTERMFG": 'Yellow',      "TERM":  'Underline'}

" Types/storage classes etc are shades of orangey-red
let ColourAssignment['Type']            = {"GUIFG": '#ff8000',     "TERM":    'Underline'}
let ColourAssignment['StorageClass']    = {"GUIFG": '#ff4040'} " static, register, volatile, etc.
let ColourAssignment['Structure']       = {"GUIFG": '#ff8080'} " struct, union, enum, etc.

" Special Stuff
let ColourAssignment['Special']         = {"GUIFG": 'Red',         "TERM":    'Bold'}
let ColourAssignment['SpecialChar']     = {"GUIFG": '#AA0000'}     " special character in a constant
let ColourAssignment['MatchParen']      = {"GUI":   'Underline,Bold', "GUIFG": "Yellow"}   " Highlighting of matching parentheses

" Errors
let ColourAssignment['Error']           = {"GUIFG": 'White',       "GUIBG":   'Red',       "TERM":  'Reverse'}

" Stuff needing doing
let ColourAssignment['Todo']            = {"GUIFG": 'Blue',        "GUIBG":   'Yellow',    "TERM":  'Standout'}

" Folding
let ColourAssignment['FoldColumn']      = {"GUIFG": 'DarkBlue',    "GUIBG":   'Gray'}

" Popup Menu
let ColourAssignment['Pmenu']           = {"GUIFG": '#442206',     "GUIBG": '#ffff77',     "CTERMFG": "Black",   "CTERMBG": "Yellow"}

" Line Numbering
let ColourAssignment['LineNr']          = {"GUIFG": 'Purple',      "GUIBG": 'LightGrey'}

" Status Lines
let ColourAssignment['StatusLine']      = {"GUIFG": 'Black',       "GUIBG": 'LightGrey',   "GUI": "Bold"}
let ColourAssignment['StatusLineNC']    = {"GUIFG": 'Black',       "GUIBG": 'DarkGrey',    "GUI": "Bold"}

" Vertical Splits
let ColourAssignment['VertSplit']       = {"GUIFG": 'Black',       "GUIBG": "DarkGrey",    "GUI": "Bold"}


" Delimiters
let ColourAssignment['Delimiter']       = {"GUIFG": 'DarkCyan'}
" Rainbow highlighting of nested brackets
" TODO: Find the closest ctermfg match to the various guifg colours
let ColourAssignment['hlLevel0']        = {"GUIFG": 'DarkCyan',    "CTERMFG": 'DarkCyan'}
let ColourAssignment['hlLevel1']        = {"GUIFG": '#bfbf00',     "CTERMFG": 'DarkCyan'}
let ColourAssignment['hlLevel2']        = {"GUIFG": '#990033',     "CTERMFG": 'DarkCyan'}
let ColourAssignment['hlLevel3']        = {"GUIFG": '#334488',     "CTERMFG": 'DarkCyan'}
let ColourAssignment['hlLevel4']        = {"GUIFG": '#996622',     "CTERMFG": 'DarkCyan'}
let ColourAssignment['hlLevel5']        = {"GUIFG": '#ff2222',     "CTERMFG": 'DarkCyan'}
let ColourAssignment['hlLevel6']        = {"GUIFG": '#4444ff',     "CTERMFG": 'DarkCyan'}
let ColourAssignment['hlLevel7']        = {"GUIFG": '#ffff44',     "CTERMFG": 'DarkCyan'}
let ColourAssignment['hlLevel8']        = {"GUIFG": '#96cdcd',     "CTERMFG": 'DarkCyan'}
let ColourAssignment['hlLevel9']        = {"GUIFG": '#698b22',     "CTERMFG": 'DarkCyan'}
" Stop rainbow.vim from overwriting these colours (requires modifications to rainbow.vim v2a
let g:rainbow_delimiter_colours_defined = 1

" ========================================================================
" Other available highlighting groups are listed at the bottom of the file
" Light Background stuff is below the MakeDarker function
" ========================================================================

function! s:MakeDarker(rgb)
	let rgbSplitter = '^#\(\x\{2}\)\(\x\{2}\)\(\x\{2}\)$'
	let matches = matchlist(a:rgb, rgbSplitter)
	if empty(matches)
		return a:rgb
	endif
	let Red = matches[1]
	let Green = matches[2]
	let Blue = matches[3]
	let percentage = 70
	let darken_above_here = 0x7f*3

	let Red = str2nr(Red, 16)
	let Green = str2nr(Green, 16)
	let Blue = str2nr(Blue, 16)
	if (Red+Green+Blue) < darken_above_here
		return a:rgb
	endif

	let Red = Red*percentage/100
	let Green = Green*percentage/100
	let Blue = Blue*percentage/100

	let result = printf("#%02x%02x%02x", Red, Green, Blue)

	return result
	
endfunction


" Now change those that are different for the light background
if &background == 'light'
	" Automatically change any LightXxxxx Colours to DarkXxxxx
	for s:group in keys(ColourAssignment)
		for s:Component in keys(ColourAssignment[s:group])
			if match(ColourAssignment[s:group][s:Component], 'Light') == 0
				let ColourAssignment[s:group][s:Component] = 'Dark'.ColourAssignment[s:group][s:Component][5:]
			elseif match(ColourAssignment[s:group][s:Component], '^#\x\{6}$') != -1
				let ColourAssignment[s:group][s:Component] = s:MakeDarker(ColourAssignment[s:group][s:Component])
			endif
		endfor
	endfor

	" Now add manual alterations
	let ColourAssignment['Normal']            = {"GUIFG": 'Black',     "GUIBG": 'White'}
	let ColourAssignment['Comment']["GUIFG"]  = 'DarkGreen'
	let ColourAssignment['String']["GUIFG"]   = '#663300'
	let ColourAssignment['String']["CTERMFG"] = 'DarkYellow'
	let ColourAssignment['Union']["GUIFG"]    = 'DarkGrey'
	let ColourAssignment['Identifier']["GUIFG"] = 'Blue'
	let ColourAssignment['LineNr']["GUIBG"]   = 'Grey'
	let ColourAssignment['StatusLine']["GUIBG"] = 'Black'
	let ColourAssignment['StatusLine']["GUIFG"] = 'White'
endif

hi Ignore ctermfg=DarkGrey guifg=grey20

" Unless there is a need to change the links at the bottom, don't change anything below this line

let s:colours = {}
let valid_cterm_colours = 
			\ [
			\     'Black', 'DarkBlue', 'DarkGreen', 'DarkCyan',
			\     'DarkRed', 'DarkMagenta', 'Brown', 'DarkYellow',
			\     'LightGray', 'LightGrey', 'Gray', 'Grey',
			\     'DarkGray', 'DarkGrey', 'Blue', 'LightBlue',
			\     'Green', 'LightGreen', 'Cyan', 'LightCyan',
			\     'Red', 'LightRed', 'Magenta', 'LightMagenta',
			\     'Yellow', 'LightYellow', 'White',
			\ ]
for key in keys(ColourAssignment)
	let s:colours = ColourAssignment[key]
	if has_key(s:colours, 'TERM')
		let term = s:colours['TERM']
	else
		let term = 'NONE'
	endif
	if has_key(s:colours, 'GUI')
		let gui = s:colours['GUI']
	else
		let gui='NONE'
	endif
	if has_key(s:colours, 'GUIFG')
		let guifg = s:colours['GUIFG']
	else
		let guifg='NONE'
	endif
	if has_key(s:colours, 'GUIBG')
		let guibg = s:colours['GUIBG']
	else
		let guibg='NONE'
	endif
	if has_key(s:colours, 'CTERM')
		let cterm = s:colours['CTERM']
	else
		let cterm=gui
	endif
	if has_key(s:colours, 'CTERMFG')
		let ctermfg = s:colours['CTERMFG']
	else
		if index(valid_cterm_colours, guifg) != -1
			let ctermfg=guifg
		else
			let ctermfg='Blue'
		endif
	endif
	if has_key(s:colours, 'CTERMBG')
		let ctermbg = s:colours['CTERMBG']
	else
		if index(valid_cterm_colours, guibg) != -1
			let ctermbg=guibg
		else
			let ctermbg='NONE'
		endif
	endif
	if has_key(s:colours, 'GUISP')
		let guisp = s:colours['GUISP']
	else
		let guisp='NONE'
	endif
	execute "hi ".key." term=".term." cterm=".cterm." gui=".gui." ctermfg=".ctermfg." guifg=".guifg." ctermbg=".ctermbg." guibg=".guibg." guisp=".guisp
endfor

hi! link MoreMsg        Comment
hi! link ErrorMsg       Visual
hi! link WarningMsg     ErrorMsg
hi! link Question       Comment
hi  link Number         Constant
hi  link Boolean        Number
hi  link Float          Number
hi  link Operator       Statement
hi  link Keyword        Statement
hi  link Typedef        Type
hi  link SpecialComment Special
hi  link Debug          Special
syntax/colours_bandit.vim	[[[1
25
syn clear

" Highlight colors/bandit.vim in the bandit.vim colour scheme!

runtime! syntax/vim.vim

redir => highlights
silent hi
redir END

let lines = split(highlights, '\n')
let keywords = []
for line in lines
	let keyword = split(line)[0]
	let keywords += [keyword,]
endfor

syn clear vimVar

for keyword in keywords
	execute 'syn match '.keyword." /ColourAssignment\\['".keyword."'\\]/me=s+16"
endfor


let b:current_syntax = "colours_bandit"
