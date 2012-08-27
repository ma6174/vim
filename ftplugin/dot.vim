" wmgraphviz.vim plugin
" Author: Wannes Meert
" Email: wannesm@gmail.com
" Version: 1.0.3

if exists('s:loaded')
	finish
endif
let s:loaded = 1

" Settings

if !exists('g:WMGraphviz_dot')
	let g:WMGraphviz_dot = 'dot'
endif

if !exists('g:WMGraphviz_output')
	let g:WMGraphviz_output = 'pdf'
endif

if !exists('g:WMGraphviz_viewer')
	if has('mac')
		let g:WMGraphviz_viewer = 'open'
	elseif has ('unix')
		if executable('xdg-open')
			let g:WMGraphviz_viewer = 'xdg-open'
		else
			if g:WMGraphviz_output == 'ps'
				let g:WMGraphviz_viewer = 'gv'
			else
				let g:WMGraphviz_viewer = 'acroread'
			endif
		endif
	else
		let g:WMGraphviz_viewer = 'open'
	endif
endif

if !exists('g:WMGraphviz_shelloptions')
	let g:WMGraphviz_shelloptions = ''
endif

if !exists('g:WMGraphviz_dot2tex')
	let g:WMGraphviz_dot2tex = 'dot2tex'
endif

if !exists('g:WMGraphviz_dot2texoptions')
	let g:WMGraphviz_dot2texoptions = '-tmath'
endif

" Compilation
" If argument given, use it as output
fu! GraphvizCompile(...)
	if !executable(g:WMGraphviz_dot)
		echoerr 'The "'.g:WMGraphviz_dot.'" executable was not found.'
		return
	endif

	let s:output = a:0 >= 1 ? a:1 : g:WMGraphviz_output
	let s:logfile = expand('%:p:r').'.log'
	" DOT command uses -O option instead of -o because this doesn't work if
	" there are multiple graphs in the file.
	let cmd = '!('.g:WMGraphviz_dot.' -O -T'.s:output.' '.g:WMGraphviz_shelloptions.' '.shellescape(expand('%:p')).' 2>&1) | tee '.shellescape(expand('%:p:r').'.log')
	exec cmd
	exec 'cfile '.escape(s:logfile, ' \"!?''')
endfu

fu! GraphvizCompileToLaTeX(...)
	if !executable(g:WMGraphviz_dot2tex)
		echoerr 'The "'.g:WMGraphviz_dot2tex.'" executable was not found.'
		return
	endif

	let s:logfile = expand('%:p:r').'.log'
	" DOT command uses -O option instead of -o because this doesn't work if
	" there are multiple graphs in the file.
	let cmd = '!(('.g:WMGraphviz_dot2tex.' '.g:WMGraphviz_dot2texoptions.' '.shellescape(expand('%:p')).' > '.shellescape(expand('%:p:r').'.tex').') 2>&1) | tee '.shellescape(expand('%:p:r').'.log')
	exec cmd
	exec 'cfile '.escape(s:logfile, ' \"!?''')
endfu

" Viewing
fu! GraphvizShow()
	if !filereadable(expand('%:p').'.'.g:WMGraphviz_output)
		call GraphvizCompile()
	endif

	if !executable(g:WMGraphviz_viewer)
		echoerr 'Viewer program not found: "'.g:WMGraphviz_viewer.'"'
		return
	endif

	exec '!'.g:WMGraphviz_viewer.' '.shellescape(expand('%:p').'.'.g:WMGraphviz_output)
endfu

" Available functions
com! -nargs=0 GraphvizCompile :call GraphvizCompile()
com! -nargs=0 GraphvizCompilePS :call GraphvizCompile('ps')
com! -nargs=0 GraphvizCompilePDF :call GraphvizCompile('pdf')
com! -nargs=0 GraphvizCompileToLaTeX :call GraphvizCompileToLaTeX()
com! -nargs=0 GraphvizShow : call GraphvizShow()

" Mappings
nmap <silent> <buffer> <LocalLeader>ll :GraphvizCompile<CR>
nmap <silent> <buffer> <LocalLeader>lt :GraphvizCompileToLaTeX<CR>
nmap <silent> <buffer> <LocalLeader>lv :GraphvizShow<CR>

" Completion
let s:completion_type = ''

" Completion dictionaries

let s:attrs = [
\	{'word': 'arrowhead=',     'menu': 'Style of arrowhead at head end [E]'},
\	{'word': 'arrowsize=',     'menu': 'Scaling factor for arrowheads [E]'},
\	{'word': 'arrowtail=',     'menu': 'Style of arrowhead at tail end [E]'},
\	{'word': 'bgcolor=',       'menu': 'Background color [G]'},
\	{'word': 'color=',         'menu': 'Node shape/edge/cluster color [E,G,N]'},
\	{'word': 'comment=',       'menu': 'Any string [E,G,N]'},
\	{'word': 'compound=',      'menu': 'Allow edges between clusters [G]'},
\	{'word': 'concentrate=',   'menu': 'Enables edge concentrators [G]'},
\	{'word': 'constraints=',   'menu': 'Use edge to affect node ranking [E]'},
\	{'word': 'decorate=',      'menu': 'If set, line between label and edge [E]'},
\	{'word': 'dir=',           'menu': 'Direction of edge [E]'},
\	{'word': 'distortion=',    'menu': 'Node distortion [N]'},
\	{'word': 'fillcolor=',     'menu': 'Node/cluster fill color [G,N]'},
\	{'word': 'fixedsize=',     'menu': 'Label text has no effect on node size [N]'},
\	{'word': 'fontcolor=',     'menu': 'Font face color [E,G,N]'},
\	{'word': 'fontname=',      'menu': 'Font family [E,G,N]'},
\	{'word': 'fontsize=',      'menu': 'Point size of label [E,G,N]'},
\	{'word': 'group=',         'menu': 'Name of node group [N]'},
\	{'word': 'headlabel=',     'menu': 'Label placed near head of edge [E]'},
\	{'word': 'headport=',      'menu': 'Location of label [E]'},
\	{'word': 'height=',        'menu': 'Height in inches [N]'},
\	{'word': 'label=',         'menu': 'Any string [E,N]'},
\	{'word': 'labelangle=',    'menu': 'Ange in degrees [E]'},
\	{'word': 'labeldistance=', 'menu': 'Scaling factor for distance for head or tail label [E]'},
\	{'word': 'labelfontcolor=','menu': 'Type face color for head and tail labels [E]'},
\	{'word': 'labelfontname=', 'menu': 'Font family for head and tail labels [E]'},
\	{'word': 'labelfontsize=', 'menu': 'Point size for head and tail labels [E]'},
\	{'word': 'labeljust=',     'menu': 'Label justficiation [G]'},
\	{'word': 'labelloc=',      'menu': 'Label vertical justficiation [G]'},
\	{'word': 'layer=',         'menu': 'Overlay range [E,N]'},
\	{'word': 'lhead=',         'menu': '[E]'},
\	{'word': 'ltail=',         'menu': '[E]'},
\	{'word': 'minlen=',        'menu': '[E]'},
\	{'word': 'nodesep=',       'menu': 'Separation between nodes, in inches [G]'},
\	{'word': 'orientation=',   'menu': 'Node rotation angle [N]'},
\	{'word': 'peripheries=',   'menu': 'Number of node boundaries [N]'},
\	{'word': 'rank=',          'menu': '[G]'},
\	{'word': 'rankdir=',       'menu': '[G]'},
\	{'word': 'ranksep=',       'menu': 'Separation between ranks, in inches [G]'},
\	{'word': 'ratio=',         'menu': 'Aspect ratio [G]'},
\	{'word': 'regular=',       'menu': 'Force polygon to be regular [N]'},
\	{'word': 'rotate=',        'menu': 'If 90, set orientation to landscape [G]'},
\	{'word': 'samehead=',      'menu': '[E]'},
\	{'word': 'sametail=',      'menu': '[E]'},
\	{'word': 'shape=',         'menu': 'Node shape [N]'},
\	{'word': 'shapefile=',     'menu': 'External custom shape file [N]'},
\	{'word': 'sides=',         'menu': 'Number of sides for shape=polygon [N]'},
\	{'word': 'skew=',          'menu': 'Skewing node for for shape=polygon [N]'},
\	{'word': 'style=',         'menu': 'Graphics options [E,N]'},
\	{'word': 'taillabel=',     'menu': 'Label placed near tail of edge [E]'},
\	{'word': 'tailport=',      'menu': '[E]'},
\	{'word': 'weight=',        'menu': 'Integer cost of stretching an edge [E]'},
\	{'word': 'width=',         'menu': 'width in inches [N]'}
\	]

let s:shapes = [
\	{'word': 'box'},
\	{'word': 'circle'},
\	{'word': 'diamond'},
\	{'word': 'doublecircle'},
\	{'word': 'doubleoctagon'},
\	{'word': 'egg'},
\	{'word': 'ellipse'},
\	{'word': 'hexagon'},
\	{'word': 'house'},
\	{'word': 'invhouse'},
\	{'word': 'invtrapezium'},
\	{'word': 'invtriangle'},
\	{'word': 'octagon'},
\	{'word': 'plaintext'},
\	{'word': 'parallelogram'},
\	{'word': 'point'},
\	{'word': 'polygon'},
\	{'word': 'record'},
\	{'word': 'traingle'},
\	{'word': 'trapezium'},
\	{'word': 'tripleoctagon'},
\	{'word': 'Mcircle'},
\	{'word': 'Mdiamon'},
\	{'word': 'Mrecord'},
\	{'word': 'Msquare'}
\	]

let s:arrowheads =  [
\	{'word': 'normal'},
\	{'word': 'dot'},
\	{'word': 'odot'},
\	{'word': 'inv'},
\	{'word': 'invdot'},
\	{'word': 'invodot'},
\	{'word': 'none'}
\	]

" More colornames are available but make the menu too long.
let s:colors =  [
\	{'word': '#000000'},
\	{'word': '0.0 0.0 0.0'},
\	{'word': 'beige'},
\	{'word': 'black'},
\	{'word': 'blue'},
\	{'word': 'brown'},
\	{'word': 'cyan'},
\	{'word': 'gray'},
\	{'word': 'gray[0-100]'},
\	{'word': 'green'},
\	{'word': 'magenta'},
\	{'word': 'orange'},
\	{'word': 'orchid'},
\	{'word': 'red'},
\	{'word': 'violet'},
\	{'word': 'white'},
\	{'word': 'yellow'}
\	]

let s:fonts =  [
\	{'abbr': 'Courier'          , 'word': '"Courier"'},
\	{'abbr': 'Courier-Bold'     , 'word': '"Courier-Bold"'},
\	{'abbr': 'Courier-Oblique'  , 'word': '"Courier-Oblique"'},
\	{'abbr': 'Helvetica'        , 'word': '"Helvetica"'},
\	{'abbr': 'Helvetica-Bold'   , 'word': '"Helvetica-Bold"'},
\	{'abbr': 'Helvetica-Narrow' , 'word': '"Helvetica-Narrow"'},
\	{'abbr': 'Helvetica-Oblique', 'word': '"Helvetica-Oblique"'},
\	{'abbr': 'Symbol'           , 'word': '"Symbol"'},
\	{'abbr': 'Times-Bold'       , 'word': '"Times-Bold"'},
\	{'abbr': 'Times-BoldItalic' , 'word': '"Times-BoldItalic"'},
\	{'abbr': 'Times-Italic'     , 'word': '"Times-Italic"'},
\	{'abbr': 'Times-Roman'      , 'word': '"Times-Roman"'}
\	]

let s:style =  [
\	{'word': 'bold'},
\	{'word': 'dotted'},
\	{'word': 'filled'}
\	]

let s:dir =  [
\	{'word': 'forward'},
\	{'word': 'back'},
\	{'word': 'both'},
\	{'word': 'none'}
\	]

let s:port =  [
\	{'word': '_',   'menu': 'appropriate side or center (default)' },
\	{'word': 'c',   'menu': 'center'},
\	{'word': 'e'},
\	{'word': 'n'},
\	{'word': 'ne'},
\	{'word': 'nw'},
\	{'word': 's'},
\	{'word': 'se'},
\	{'word': 'sw'},
\	{'word': 'w'},
\	]

let s:rank =  [
\	{'word': 'same'},
\	{'word': 'min'},
\	{'word': 'max'},
\	{'word': 'source'},
\	{'word': 'sink'}
\	]

let s:rankdir =  [
\	{'word': 'BT'},
\	{'word': 'LR'},
\	{'word': 'RL'},
\	{'word': 'TB'},
\	]

let s:just =  [
\	{'word': 'centered'},
\	{'word': 'l'},
\	{'word': 'r'}
\	]

let s:loc =  [
\	{'word': 'b', 'menu': 'bottom'},
\	{'word': 'c', 'menu': 'center'},
\	{'word': 't', 'menu': 'top'},
\	]

let s:boolean =  [
\	{'word': 'true'},
\	{'word': 'false'}
\	]

fu! GraphvizComplete(findstart, base)
	"echomsg 'findstart='.a:findstart.', base='.a:base
	if a:findstart
		" return the starting point of the word
		let line = getline('.')
		let pos = col('.') - 1
		while pos > 0 && line[pos - 1] !~ '=\|,\|\[\|\s'
			let pos -= 1
		endwhile
		let withspacepos = pos
		if line[withspacepos - 1] =~ '\s'
			while withspacepos > 0 && line[withspacepos - 1] !~ '=\|,\|\['
				let withspacepos -= 1
			endwhile
		endif

		if line[withspacepos - 1] == '='
			" label=...?
			let labelpos = withspacepos - 1
			" ignore spaces
			while labelpos > 0 && line[labelpos - 1] =~ '\s'
				let labelpos -= 1
				let withspacepos -= 1
			endwhile
			while labelpos > 0 && line[labelpos - 1] =~ '[a-z]'
				let labelpos -= 1
			endwhile
			let labelstr=strpart(line, labelpos, withspacepos - 1 - labelpos)

			if labelstr == 'shape'
				let s:completion_type = 'shape'
			elseif labelstr =~ 'fontname'
				let s:completion_type = 'font'
			elseif labelstr =~ 'color'
				let s:completion_type = 'color'
			elseif labelstr == 'arrowhead'
				let s:completion_type = 'arrowhead'
			elseif labelstr == 'rank'
				let s:completion_type = 'rank'
			elseif labelstr == 'port'
				let s:completion_type = 'port'
			elseif labelstr == 'rankdir'
				let s:completion_type = 'rankdir'
			elseif labelstr == 'style'
				let s:completion_type = 'style'
			elseif labelstr == 'labeljust'
				let s:completion_type = 'just'
			elseif labelstr == 'fixedsize' || labelstr == 'regular' || labelstr == 'constraint' || labelstr == 'labelfloat' || labelstr == 'center' || labelstr == 'compound' || labelstr == 'concentrate'
				let s:completion_type = 'boolean'
			elseif labelstr == 'labelloc'
				let s:completion_type = 'loc'
			else
				let s:completion_type = ''
			endif
		elseif line[withspacepos - 1] =~ ',\|\['
			" attr
			let attrstr=line[0:withspacepos - 1]
			" skip spaces
			while line[withspacepos] =~ '\s'
				let withspacepos += 1
			endwhile

			if attrstr =~ '^\s*node'
				let s:completion_type = 'attrnode'
			elseif attrstr =~ '^\s*edge'
				let s:completion_type = 'attredge'
			elseif attrstr =~ '\( -> \)\|\( -- \)'
				let s:completion_type = 'attredge'
			elseif attrstr =~ '^\s*graph'
				let s:completion_type = 'attrgraph'
			else
				let s:completion_type = 'attrnode'
			endif
		else
			let s:completion_type = ''
		endif

		return pos
	else
		" return suggestions in an array
		let suggestions = []

		if s:completion_type == 'shape'
			for entry in s:shapes
				if entry.word =~ '^'.escape(a:base, '/')
					call add(suggestions, entry)
				endif
			endfor
		elseif s:completion_type == 'arrowhead'
			for entry in s:arrowheads
				if entry.word =~ '^'.escape(a:base, '/')
					call add(suggestions, entry)
				endif
			endfor
		elseif s:completion_type == 'boolean'
			for entry in s:boolean
				if entry.word =~ '^'.escape(a:base, '/')
					call add(suggestions, entry)
				endif
			endfor
		elseif s:completion_type == 'font'
			for entry in s:fonts
				if entry.word =~ '^'.escape(a:base, '/')
					call add(suggestions, entry)
				endif
			endfor
		elseif s:completion_type == 'color'
			for entry in s:colors
				if entry.word =~ '^'.escape(a:base, '/')
					call add(suggestions, entry)
				endif
			endfor
		elseif s:completion_type == 'rank'
			for entry in s:rank
				if entry.word =~ '^'.escape(a:base, '/')
					call add(suggestions, entry)
				endif
			endfor
		elseif s:completion_type == 'rankdir'
			for entry in s:rankdir
				if entry.word =~ '^'.escape(a:base, '/')
					call add(suggestions, entry)
				endif
			endfor
		elseif s:completion_type == 'style'
			for entry in s:style
				if entry.word =~ '^'.escape(a:base, '/')
					call add(suggestions, entry)
				endif
			endfor
		elseif s:completion_type == 'port'
			for entry in s:port
				if entry.word =~ '^'.escape(a:base, '/')
					call add(suggestions, entry)
				endif
			endfor
		elseif s:completion_type == 'just'
			for entry in s:just
				if entry.word =~ '^'.escape(a:base, '/')
					call add(suggestions, entry)
				endif
			endfor
		elseif s:completion_type == 'loc'
			for entry in s:loc
				if entry.word =~ '^'.escape(a:base, '/')
					call add(suggestions, entry)
				endif
			endfor
		elseif s:completion_type == 'attr'
			for entry in s:attrs
				if entry.word =~ '^'.escape(a:base, '/')
					call add(suggestions, entry)
				endif
			endfor
		elseif s:completion_type == 'attrnode'
			for entry in s:attrs
				if entry.word =~ '^'.escape(a:base, '/') && entry.menu =~ '\[.*N.*\]'
					call add(suggestions, entry)
				endif
			endfor
		elseif s:completion_type == 'attredge'
			for entry in s:attrs
				if entry.word =~ '^'.escape(a:base, '/') && entry.menu =~ '\[.*E.*\]'
					call add(suggestions, entry)
				endif
			endfor
		elseif s:completion_type == 'attrgraph'
			for entry in s:attrs
				if entry.word =~ '^'.escape(a:base, '/') && entry.menu =~ '\[.*G.*\]'
					call add(suggestions, entry)
				endif
			endfor
		endif
		if !has('gui_running')
			redraw!
		endif
		return suggestions
	endif
endfu

setlocal omnifunc=GraphvizComplete

" Quickfix list

setlocal errorformat=%EError:\ %f:%l:%m,%+Ccontext:\ %.%#,%WWarning:\ %m

" Comments

set commentstring="// %s"


