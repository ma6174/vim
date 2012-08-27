" Script Name: mark.vim
" Description: Highlight several words in different colors simultaneously.
"
" Copyright:   (C) 2005-2008 by Yuheng Xie
"              (C) 2008-2012 by Ingo Karkat
"   The VIM LICENSE applies to this script; see ':help copyright'.
"
" Maintainer:  Ingo Karkat <ingo@karkat.de>
"
" Dependencies:
"  - SearchSpecial.vim autoload script (optional, for improved search messages).
"
" Version:     2.7.0
" Changes:
" 04-Jul-2012, Ingo Karkat
" - ENH: Handle on-the-fly change of mark highlighting via mark#ReInit(), which
"   truncates / expands s:pattern and corrects the indices. Also, w:mwMatch List
"   size mismatches must be handled in s:MarkMatch().
"
" 23-Apr-2012, Ingo Karkat + fanhe
" - Force case via \c / \C instead of temporarily unsetting 'smartcase'.
" - Allow to override 'ignorecase' setting via g:mwIgnoreCase. Thanks to fanhe
"   for the idea and sending a patch.
"
" 26-Mar-2012, Ingo Karkat
" - ENH: When a [count] exceeding the number of available mark groups is given,
"   a summary of marks is given and the user is asked to select a mark group.
"   This allows to interactively choose a color via 99<Leader>m.
" - ENH: Include count of alternative patterns in :Marks list.
" - CHG: Use ">" for next mark and "/" for last search in :Marks.
"
" 23-Mar-2012, Ingo Karkat
" - ENH: Add :Marks command that prints all mark highlight groups and their
"   search patterns, plus information about the current search mark, next mark
"   group, and whether marks are disabled.
" - ENH: Show which mark group a pattern was set / added / removed / cleared.
" - Refactoring: Store index into s:pattern instead of pattern itself in
"   s:lastSearch. For that, mark#CurrentMark() now additionally returns the
"   index.
" - CHG: Show mark group number in same-mark search and rename search types from
"   "any-mark", "same-mark", and "new-mark" to the shorter "mark-*", "mark-N",
"   and "mark-N!", respectively.
"
" 22-Mar-2012, Ingo Karkat
" - ENH: Allow [count] for <Leader>m and :Mark to add / subtract match to / from
"   highlight group [count], and use [count]<Leader>n to clear only highlight
"   group [count]. This was also requested by Philipp Marek.
" - FIX: :Mark and <Leader>n actually toggled marks back on when they were
"   already off. Now, they stay off on multiple invocations. Use :call
"   mark#Toggle() / <Plug>MarkToggle if you want toggling.
"
" 09-Nov-2011, Ingo Karkat
" - BUG: With a single match and 'wrapscan' set, a search error was issued
"   instead of the wrap message. Add check for l:isStuckAtCurrentMark &&
"   l:isWrapped in the no-match part of s:Search().
" - FIX: In backwards search with single match, the :break short-circuits the
"   l:isWrapped logic, resets l:line and therefore also confuses the logic and
"   leads to wrong error message instead of wrap message. Don't reset l:line,
"   set l:isWrapped instead.
" - FIX: Wrong logic for determining l:isWrapped lets wrap-around go undetected
"   when v:count >= number of total matches. [l:startLine, l:startCol] must
"   be updated on every iteration, and should therefore be named [l:prevLine,
"   l:prevCol].
"
" 17-May-2011, Ingo Karkat
" - Make s:GetVisualSelection() public to allow use in suggested
"   <Plug>MarkSpaceIndifferent vmap.
" - FIX: == comparison in s:DoMark() leads to wrong regexp (\A vs. \a) being
"   cleared when 'ignorecase' is set. Use case-sensitive comparison ==# instead.
"
" 10-May-2011, Ingo Karkat
" - Refine :MarkLoad messages: Differentiate between nonexistent and empty
"   g:MARK_MARKS; add note when marks are disabled.
"
" 06-May-2011, Ingo Karkat
" - Also print status message on :MarkClear to be consistent with :MarkToggle.
"
" 21-Apr-2011, Ingo Karkat
" - Implement toggling of mark display (keeping the mark patterns, unlike the
"   clearing of marks), determined by s:enable. s:DoMark() now toggles on empty
"   regexp, affecting the \n mapping and :Mark. Introduced
"   s:EnableAndMarkScope() wrapper to correctly handle the highlighting updates
"   depending on whether marks were previously disabled.
" - Implement persistence of s:enable via g:MARK_ENABLED.
" - Generalize s:Enable() and combine with intermediate s:Disable() into
"   s:MarkEnable(), which also performs the persistence of s:enabled.
" - Implement lazy-loading of disabled persistent marks via g:mwDoDeferredLoad
"   flag passed from plugin/mark.vim.
"
" 20-Apr-2011, Ingo Karkat
" - Extract setting of s:pattern into s:SetPattern() and implement the automatic
"   persistence there.
"
" 19-Apr-2011, Ingo Karkat
" - ENH: Add enabling functions for mark persistence: mark#Load() and
"   mark#ToPatternList().
" - Implement :MarkLoad and :MarkSave commands in mark#LoadCommand() and
"   mark#SaveCommand().
" - Remove superfluous update autocmd on VimEnter: Persistent marks trigger the
"   update themselves, same for :Mark commands which could potentially be issued
"   e.g. in .vimrc. Otherwise, when no marks are defined after startup, the
"   autosource script isn't even loaded yet, so the autocmd on the VimEnter
"   event isn't yet defined.
"
" 18-Apr-2011, Ingo Karkat
" - BUG: Include trailing newline character in check for current mark, so that a
"   mark that matches the entire line (e.g. created by V<Leader>m) can be
"   cleared via <Leader>n. Thanks to ping for reporting this.
" - Minor restructuring of mark#MarkCurrentWord().
" - FIX: On overlapping marks, mark#CurrentMark() returned the lowest, not the
"   highest visible mark. So on overlapping marks, the one that was not visible
"   at the cursor position was removed; very confusing! Use reverse iteration
"   order.
" - FIX: To avoid an arbitrary ordering of highlightings when the highlighting
"   group names roll over, and to avoid order inconsistencies across different
"   windows and tabs, we assign a different priority based on the highlighting
"   group.
" - Rename s:cycleMax to s:markNum; the previous name was too
"   implementation-focused and off-by-one with regards to the actual value.
"
" 16-Apr-2011, Ingo Karkat
" - Move configuration variable g:mwHistAdd to plugin/mark.vim (as is customary)
"   and make the remaining g:mw... variables script-local, as these contain
"   internal housekeeping information that does not need to be accessible by the
"   user.
" - Add :MarkSave warning if 'viminfo' doesn't enable global variable
"   persistence.
"
" 15-Apr-2011, Ingo Karkat
" - Robustness: Move initialization of w:mwMatch from mark#UpdateMark() to
"   s:MarkMatch(), where the variable is actually used. I had encountered cases
"   where it w:mwMatch was undefined when invoked through mark#DoMark() ->
"   s:MarkScope() -> s:MarkMatch(). This can be forced by :unlet w:mwMatch
"   followed by :Mark foo.
" - Robustness: Checking for s:markNum == 0 in mark#DoMark(), trying to
"   re-detect the mark highlightings and finally printing an error instead of
"   choking. This can happen when somehow no mark highlightings are defined.
"
" 14-Jan-2011, Ingo Karkat
" - FIX: Capturing the visual selection could still clobber the blockwise yank
"   mode of the unnamed register.
"
" 13-Jan-2011, Ingo Karkat
" - FIX: Using a named register for capturing the visual selection on
"   {Visual}<Leader>m and {Visual}<Leader>r clobbered the unnamed register. Now
"   using the unnamed register.
"
" 13-Jul-2010, Ingo Karkat
" - ENH: The MarkSearch mappings (<Leader>[*#/?]) add the original cursor
"   position to the jump list, like the built-in [/?*#nN] commands. This allows
"   to use the regular jump commands for mark matches, like with regular search
"   matches.
"
" 19-Feb-2010, Andy Wokula
" - BUG: Clearing of an accidental zero-width match (e.g. via :Mark \zs) results
"   in endless loop. Thanks to Andy Wokula for the patch.
"
" 17-Nov-2009, Ingo Karkat + Andy Wokula
" - BUG: Creation of literal pattern via '\V' in {Visual}<Leader>m mapping
"   collided with individual escaping done in <Leader>m mapping so that an
"   escaped '\*' would be interpreted as a multi item when both modes are used
"   for marking. Replaced \V with s:EscapeText() to be consistent. Replaced the
"   (overly) generic mark#GetVisualSelectionEscaped() with
"   mark#GetVisualSelectionAsRegexp() and
"   mark#GetVisualSelectionAsLiteralPattern(). Thanks to Andy Wokula for the
"   patch.
"
" 06-Jul-2009, Ingo Karkat
" - Re-wrote s:AnyMark() in functional programming style.
" - Now resetting 'smartcase' before the search, this setting should not be
"   considered for *-command-alike searches and cannot be supported because all
"   mark patterns are concatenated into one large regexp, anyway.
"
" 04-Jul-2009, Ingo Karkat
" - Re-wrote s:Search() to handle v:count:
"   - Obsoleted s:current_mark_position; mark#CurrentMark() now returns both the
"     mark text and start position.
"   - s:Search() now checks for a jump to the current mark during a backward
"     search; this eliminates a lot of logic at its calling sites.
"   - Reverted negative logic at calling sites; using empty() instead of != "".
"   - Now passing a:isBackward instead of optional flags into s:Search() and
"     around its callers.
"   - ':normal! zv' moved from callers into s:Search().
" - Removed delegation to SearchSpecial#ErrorMessage(), because the fallback
"   implementation is perfectly fine and the SearchSpecial routine changed its
"   output format into something unsuitable anyway.
" - Using descriptive text instead of "@" (and appropriate highlighting) when
"   querying for the pattern to mark.
"
" 02-Jul-2009, Ingo Karkat
" - Split off functions into autoload script.

"- functions ------------------------------------------------------------------

silent! call SearchSpecial#DoesNotExist()	" Execute a function to force autoload.
if exists('*SearchSpecial#WrapMessage')
	function! s:WrapMessage( searchType, searchPattern, isBackward )
		redraw
		call SearchSpecial#WrapMessage(a:searchType, a:searchPattern, a:isBackward)
	endfunction
	function! s:EchoSearchPattern( searchType, searchPattern, isBackward )
		call SearchSpecial#EchoSearchPattern(a:searchType, a:searchPattern, a:isBackward)
	endfunction
else
	function! s:Trim( message )
		" Limit length to avoid "Hit ENTER" prompt.
		return strpart(a:message, 0, (&columns / 2)) . (len(a:message) > (&columns / 2) ? "..." : "")
	endfunction
	function! s:WrapMessage( searchType, searchPattern, isBackward )
		redraw
		let v:warningmsg = printf('%s search hit %s, continuing at %s', a:searchType, (a:isBackward ? 'TOP' : 'BOTTOM'), (a:isBackward ? 'BOTTOM' : 'TOP'))
		echohl WarningMsg
		echo s:Trim(v:warningmsg)
		echohl None
	endfunction
	function! s:EchoSearchPattern( searchType, searchPattern, isBackward )
		let l:message = (a:isBackward ? '?' : '/') .  a:searchPattern
		echohl SearchSpecialSearchType
		echo a:searchType
		echohl None
		echon s:Trim(l:message)
	endfunction
endif

function! s:EscapeText( text )
	return substitute( escape(a:text, '\' . '^$.*[~'), "\n", '\\n', 'ge' )
endfunction
function! s:IsIgnoreCase( expr )
	return ((exists('g:mwIgnoreCase') ? g:mwIgnoreCase : &ignorecase) && a:expr !~# '\\\@<!\\C')
endfunction
" Mark the current word, like the built-in star command.
" If the cursor is on an existing mark, remove it.
function! mark#MarkCurrentWord( groupNum )
	let l:regexp = (a:groupNum == 0 ? mark#CurrentMark()[0] : '')
	if empty(l:regexp)
		let l:cword = expand('<cword>')
		if ! empty(l:cword)
			let l:regexp = s:EscapeText(l:cword)
			" The star command only creates a \<whole word\> search pattern if the
			" <cword> actually only consists of keyword characters.
			if l:cword =~# '^\k\+$'
				let l:regexp = '\<' . l:regexp . '\>'
			endif
		endif
	endif
	return (empty(l:regexp) ? 0 : mark#DoMark(a:groupNum, l:regexp))
endfunction

function! mark#GetVisualSelection()
	let save_clipboard = &clipboard
	set clipboard= " Avoid clobbering the selection and clipboard registers.
	let save_reg = getreg('"')
	let save_regmode = getregtype('"')
	silent normal! gvy
	let res = getreg('"')
	call setreg('"', save_reg, save_regmode)
	let &clipboard = save_clipboard
	return res
endfunction
function! mark#GetVisualSelectionAsLiteralPattern()
	return s:EscapeText(mark#GetVisualSelection())
endfunction
function! mark#GetVisualSelectionAsRegexp()
	return substitute(mark#GetVisualSelection(), '\n', '', 'g')
endfunction

" Manually input a regular expression.
function! mark#MarkRegex( regexpPreset )
	call inputsave()
	echohl Question
	let l:regexp = input('Input pattern to mark: ', a:regexpPreset)
	echohl None
	call inputrestore()
	if ! empty(l:regexp)
		call mark#DoMark(0, l:regexp)
	endif
endfunction

function! s:Cycle( ... )
	let l:currentCycle = s:cycle
	let l:newCycle = (a:0 ? a:1 : s:cycle) + 1
	let s:cycle = (l:newCycle < s:markNum ? l:newCycle : 0)
	return l:currentCycle
endfunction
function! s:FreeGroupIndex()
	let i = 0
	while i < s:markNum
		if empty(s:pattern[i])
			return i
		endif
		let i += 1
	endwhile
	return -1
endfunction

" Set match / clear matches in the current window.
function! s:MarkMatch( indices, expr )
	if ! exists('w:mwMatch')
		let w:mwMatch = repeat([0], s:markNum)
	elseif len(w:mwMatch) != s:markNum
		" The number of marks has changed.
		if len(w:mwMatch) > s:markNum
			" Truncate the matches.
			for l:match in filter(w:mwMatch[s:markNum : ], 'v:val > 0')
				silent! call matchdelete(l:match)
			endfor
			let w:mwMatch = w:mwMatch[0 : (s:markNum - 1)]
		else
			" Expand the matches.
			let w:mwMatch += repeat([0], (s:markNum - len(w:mwMatch)))
		endif
	endif

	for l:index in a:indices
		if w:mwMatch[l:index] > 0
			silent! call matchdelete(w:mwMatch[l:index])
			let w:mwMatch[l:index] = 0
		endif
	endfor

	if ! empty(a:expr)
		let l:index = a:indices[0]	" Can only set one index for now.

		" Info: matchadd() does not consider the 'magic' (it's always on),
		" 'ignorecase' and 'smartcase' settings.
		" Make the match according to the 'ignorecase' setting, like the star command.
		" (But honor an explicit case-sensitive regexp via the /\C/ atom.)
		let l:expr = (s:IsIgnoreCase(a:expr) ? '\c' : '') . a:expr

		" To avoid an arbitrary ordering of highlightings, we assign a different
		" priority based on the highlight group, and ensure that the highest
		" priority is -10, so that we do not override the 'hlsearch' of 0, and still
		" allow other custom highlightings to sneak in between.
		let l:priority = -10 - s:markNum + 1 + l:index

		let w:mwMatch[l:index] = matchadd('MarkWord' . (l:index + 1), l:expr, l:priority)
	endif
endfunction
" Initialize mark colors in a (new) window.
function! mark#UpdateMark()
	let i = 0
	while i < s:markNum
		if ! s:enabled || empty(s:pattern[i])
			call s:MarkMatch([i], '')
		else
			call s:MarkMatch([i], s:pattern[i])
		endif
		let i += 1
	endwhile
endfunction
" Set / clear matches in all windows.
function! s:MarkScope( indices, expr )
	let l:currentWinNr = winnr()

	" By entering a window, its height is potentially increased from 0 to 1 (the
	" minimum for the current window). To avoid any modification, save the window
	" sizes and restore them after visiting all windows.
	let l:originalWindowLayout = winrestcmd()

	noautocmd windo call s:MarkMatch(a:indices, a:expr)
	execute l:currentWinNr . 'wincmd w'
	silent! execute l:originalWindowLayout
endfunction
" Update matches in all windows.
function! mark#UpdateScope()
	let l:currentWinNr = winnr()

	" By entering a window, its height is potentially increased from 0 to 1 (the
	" minimum for the current window). To avoid any modification, save the window
	" sizes and restore them after visiting all windows.
	let l:originalWindowLayout = winrestcmd()

	noautocmd windo call mark#UpdateMark()
	execute l:currentWinNr . 'wincmd w'
	silent! execute l:originalWindowLayout
endfunction

function! s:MarkEnable( enable, ...)
	if s:enabled != a:enable
		" En-/disable marks and perform a full refresh in all windows, unless
		" explicitly suppressed by passing in 0.
		let s:enabled = a:enable
		if g:mwAutoSaveMarks
			let g:MARK_ENABLED = s:enabled
		endif

		if ! a:0 || ! a:1
			call mark#UpdateScope()
		endif
	endif
endfunction
function! s:EnableAndMarkScope( indices, expr )
	if s:enabled
		" Marks are already enabled, we just need to push the changes to all
		" windows.
		call s:MarkScope(a:indices, a:expr)
	else
		call s:MarkEnable(1)
	endif
endfunction

" Toggle visibility of marks, like :nohlsearch does for the regular search
" highlighting.
function! mark#Toggle()
	if s:enabled
		call s:MarkEnable(0)
		echo 'Disabled marks'
	else
		call s:MarkEnable(1)

		let l:markCnt = len(filter(copy(s:pattern), '! empty(v:val)'))
		echo 'Enabled' (l:markCnt > 0 ? l:markCnt . ' ' : '') . 'marks'
	endif
endfunction


" Mark or unmark a regular expression.
function! s:SetPattern( index, pattern )
	let s:pattern[a:index] = a:pattern

	if g:mwAutoSaveMarks
		call s:SavePattern()
	endif
endfunction
function! mark#ClearAll()
	let i = 0
	let indices = []
	while i < s:markNum
		if ! empty(s:pattern[i])
			call s:SetPattern(i, '')
			call add(indices, i)
		endif
		let i += 1
	endwhile
	let s:lastSearch = -1

" Re-enable marks; not strictly necessary, since all marks have just been
" cleared, and marks will be re-enabled, anyway, when the first mark is added.
" It's just more consistent for mark persistence. But save the full refresh, as
" we do the update ourselves.
	call s:MarkEnable(0, 0)

	call s:MarkScope(l:indices, '')

	if len(indices) > 0
		echo 'Cleared all' len(indices) 'marks'
	else
		echo 'All marks cleared'
	endif
endfunction
function! s:SetMark( index, regexp, ... )
	if a:0
		if s:lastSearch == a:index
			let s:lastSearch = a:1
		endif
	endif
	call s:SetPattern(a:index, a:regexp)
	call s:EnableAndMarkScope([a:index], a:regexp)
endfunction
function! s:ClearMark( index )
	" A last search there is reset.
	call s:SetMark(a:index, '', -1)
endfunction
function! s:EchoMark( groupNum, regexp )
	call s:EchoSearchPattern('mark-' . a:groupNum, a:regexp, 0)
endfunction
function! s:EchoMarkCleared( groupNum )
	echohl SearchSpecialSearchType
	echo 'mark-' . a:groupNum
	echohl None
	echon ' cleared'
endfunction
function! s:EchoMarksDisabled()
	echo 'All marks disabled'
endfunction
function! mark#DoMark( groupNum, ...)
	if s:markNum <= 0
		" Uh, somehow no mark highlightings were defined. Try to detect them again.
		call mark#Init()
		if s:markNum <= 0
			" Still no mark highlightings; complain.
			let v:errmsg = 'No mark highlightings defined'
			echohl ErrorMsg
			echomsg v:errmsg
			echohl None
			return 0
		endif
	endif

	let l:groupNum = a:groupNum
	if l:groupNum > s:markNum
		" This highlight group does not exist.
		let l:groupNum = mark#QueryMarkGroupNum()
		if l:groupNum < 1 || l:groupNum > s:markNum
			return 0
		endif
	endif

	let regexp = (a:0 ? a:1 : '')
	if empty(regexp)
		if l:groupNum == 0
			" Disable all marks.
			call s:MarkEnable(0)
			call s:EchoMarksDisabled()
		else
			" Clear the mark represented by the passed highlight group number.
			call s:ClearMark(l:groupNum - 1)
			call s:EchoMarkCleared(l:groupNum)
		endif

		return 1
	endif

	if l:groupNum == 0
		" Clear the mark if it has been marked.
		let i = 0
		while i < s:markNum
			if regexp ==# s:pattern[i]
				call s:ClearMark(i)
				call s:EchoMarkCleared(i + 1)
				return 1
			endif
			let i += 1
		endwhile
	else
		" Add / subtract the pattern as an alternative to the mark represented
		" by the passed highlight group number.
		let existingPattern = s:pattern[l:groupNum - 1]
		if ! empty(existingPattern)
			" Split only on \|, but not on \\|.
			let alternatives = split(existingPattern, '\%(\%(^\|[^\\]\)\%(\\\\\)*\\\)\@<!\\|')
			if index(alternatives, regexp) == -1
				let regexp = existingPattern . '\|' . regexp
			else
				let regexp = join(filter(alternatives, 'v:val !=# regexp'), '\|')
				if empty(regexp)
					call s:ClearMark(l:groupNum - 1)
					call s:EchoMarkCleared(l:groupNum)
					return 1
				endif
			endif
		endif
	endif

	" add to history
	if stridx(g:mwHistAdd, '/') >= 0
		call histadd('/', regexp)
	endif
	if stridx(g:mwHistAdd, '@') >= 0
		call histadd('@', regexp)
	endif

	if l:groupNum == 0
		let i = s:FreeGroupIndex()
		if i != -1
			" Choose an unused highlight group. The last search is kept untouched.
			call s:Cycle(i)
			call s:SetMark(i, regexp)
		else
			" Choose a highlight group by cycle. A last search there is reset.
			let i = s:Cycle()
			call s:SetMark(i, regexp, -1)
		endif
	else
		let i = l:groupNum - 1
		" Use and extend the passed highlight group. A last search is updated
		" and thereby kept active.
		call s:SetMark(i, regexp, i)
	endif

	call s:EchoMark(i + 1, regexp)
	return 1
endfunction

" Return [mark text, mark start position, mark index] of the mark under the
" cursor (or ['', [], -1] if there is no mark).
" The mark can include the trailing newline character that concludes the line,
" but marks that span multiple lines are not supported.
function! mark#CurrentMark()
	let line = getline('.') . "\n"

	" Highlighting groups with higher numbers take precedence over lower numbers,
	" and therefore its marks appear "above" other marks. To retrieve the visible
	" mark in case of overlapping marks, we need to check from highest to lowest
	" highlight group.
	let i = s:markNum - 1
	while i >= 0
		if ! empty(s:pattern[i])
			let matchPattern = (s:IsIgnoreCase(s:pattern[i]) ? '\c' : '\C') . s:pattern[i]
			" Note: col() is 1-based, all other indexes zero-based!
			let start = 0
			while start >= 0 && start < strlen(line) && start < col('.')
				let b = match(line, matchPattern, start)
				let e = matchend(line, matchPattern, start)
				if b < col('.') && col('.') <= e
					return [s:pattern[i], [line('.'), (b + 1)], i]
				endif
				if b == e
					break
				endif
				let start = e
			endwhile
		endif
		let i -= 1
	endwhile
	return ['', [], -1]
endfunction

" Search current mark.
function! mark#SearchCurrentMark( isBackward )
	let [l:markText, l:markPosition, l:markIndex] = mark#CurrentMark()
	if empty(l:markText)
		if s:lastSearch == -1
			call mark#SearchAnyMark(a:isBackward)
			let s:lastSearch = mark#CurrentMark()[2]
		else
			call s:Search(s:pattern[s:lastSearch], a:isBackward, [], 'mark-' . (s:lastSearch + 1))
		endif
	else
		call s:Search(l:markText, a:isBackward, l:markPosition, 'mark-' . (l:markIndex + 1) . (l:markIndex ==# s:lastSearch ? '' : '!'))
		let s:lastSearch = l:markIndex
	endif
endfunction

function! s:ErrorMessage( searchType, searchPattern, isBackward )
	if &wrapscan
		let v:errmsg = a:searchType . ' not found: ' . a:searchPattern
	else
		let v:errmsg = printf('%s search hit %s without match for: %s', a:searchType, (a:isBackward ? 'TOP' : 'BOTTOM'), a:searchPattern)
	endif
	echohl ErrorMsg
	echomsg v:errmsg
	echohl None
endfunction

" Wrapper around search() with additonal search and error messages and "wrapscan" warning.
function! s:Search( pattern, isBackward, currentMarkPosition, searchType )
	let l:save_view = winsaveview()

	" searchpos() obeys the 'smartcase' setting; however, this setting doesn't
	" make sense for the mark search, because all patterns for the marks are
	" concatenated as branches in one large regexp, and because patterns that
	" result from the *-command-alike mappings should not obey 'smartcase' (like
	" the * command itself), anyway. If the :Mark command wants to support
	" 'smartcase', it'd have to emulate that into the regular expression.
	" Instead of temporarily unsetting 'smartcase', we force the correct
	" case-matching behavior through \c / \C.
	let l:searchPattern = (s:IsIgnoreCase(a:pattern) ? '\c' : '\C') . a:pattern

	let l:count = v:count1
	let l:isWrapped = 0
	let l:isMatch = 0
	let l:line = 0
	while l:count > 0
		let [l:prevLine, l:prevCol] = [line('.'), col('.')]

		" Search for next match, 'wrapscan' applies.
		let [l:line, l:col] = searchpos( l:searchPattern, (a:isBackward ? 'b' : '') )

"****D echomsg '****' a:isBackward string([l:line, l:col]) string(a:currentMarkPosition) l:count
		if a:isBackward && l:line > 0 && [l:line, l:col] == a:currentMarkPosition && l:count == v:count1
			" On a search in backward direction, the first match is the start of the
			" current mark (if the cursor was positioned on the current mark text, and
			" not at the start of the mark text).
			" In contrast to the normal search, this is not considered the first
			" match. The mark text is one entity; if the cursor is positioned anywhere
			" inside the mark text, the mark text is considered the current mark. The
			" built-in '*' and '#' commands behave in the same way; the entire <cword>
			" text is considered the current match, and jumps move outside that text.
			" In normal search, the cursor can be positioned anywhere (via offsets)
			" around the search, and only that single cursor position is considered
			" the current match.
			" Thus, the search is retried without a decrease of l:count, but only if
			" this was the first match; repeat visits during wrapping around count as
			" a regular match. The search also must not be retried when this is the
			" first match, but we've been here before (i.e. l:isMatch is set): This
			" means that there is only the current mark in the buffer, and we must
			" break out of the loop and indicate that search wrapped around and no
			" other mark was found.
			if l:isMatch
				let l:isWrapped = 1
				break
			endif

			" The l:isMatch flag is set so if the final mark cannot be reached, the
			" original cursor position is restored. This flag also allows us to detect
			" whether we've been here before, which is checked above.
			let l:isMatch = 1
		elseif l:line > 0
			let l:isMatch = 1
			let l:count -= 1

			" Note: No need to check 'wrapscan'; the wrapping can only occur if
			" 'wrapscan' is actually on.
			if ! a:isBackward && (l:prevLine > l:line || l:prevLine == l:line && l:prevCol >= l:col)
				let l:isWrapped = 1
			elseif a:isBackward && (l:prevLine < l:line || l:prevLine == l:line && l:prevCol <= l:col)
				let l:isWrapped = 1
			endif
		else
			break
		endif
	endwhile

	" We're not stuck when the search wrapped around and landed on the current
	" mark; that's why we exclude a possible wrap-around via v:count1 == 1.
	let l:isStuckAtCurrentMark = ([l:line, l:col] == a:currentMarkPosition && v:count1 == 1)
"****D echomsg '****' l:line l:isStuckAtCurrentMark l:isWrapped l:isMatch string([l:line, l:col]) string(a:currentMarkPosition)
	if l:line > 0 && ! l:isStuckAtCurrentMark
		let l:matchPosition = getpos('.')

		" Open fold at the search result, like the built-in commands.
		normal! zv

		" Add the original cursor position to the jump list, like the
		" [/?*#nN] commands.
		" Implementation: Memorize the match position, restore the view to the state
		" before the search, then jump straight back to the match position. This
		" also allows us to set a jump only if a match was found. (:call
		" setpos("''", ...) doesn't work in Vim 7.2)
		call winrestview(l:save_view)
		normal! m'
		call setpos('.', l:matchPosition)

		" Enable marks (in case they were disabled) after arriving at the mark (to
		" avoid unnecessary screen updates) but before the error message (to avoid
		" it getting lost due to the screen updates).
		call s:MarkEnable(1)

		if l:isWrapped
			call s:WrapMessage(a:searchType, a:pattern, a:isBackward)
		else
			call s:EchoSearchPattern(a:searchType, a:pattern, a:isBackward)
		endif
		return 1
	else
		if l:isMatch
			" The view has been changed by moving through matches until the end /
			" start of file, when 'nowrapscan' forced a stop of searching before the
			" l:count'th match was found.
			" Restore the view to the state before the search.
			call winrestview(l:save_view)
		endif

		" Enable marks (in case they were disabled) after arriving at the mark (to
		" avoid unnecessary screen updates) but before the error message (to avoid
		" it getting lost due to the screen updates).
		call s:MarkEnable(1)

		if l:line > 0 && l:isStuckAtCurrentMark && l:isWrapped
			call s:WrapMessage(a:searchType, a:pattern, a:isBackward)
			return 1
		else
			call s:ErrorMessage(a:searchType, a:pattern, a:isBackward)
			return 0
		endif
	endif
endfunction

" Combine all marks into one regexp.
function! s:AnyMark()
	return join(filter(copy(s:pattern), '! empty(v:val)'), '\|')
endfunction

" Search any mark.
function! mark#SearchAnyMark( isBackward )
	let l:markPosition = mark#CurrentMark()[1]
	let l:markText = s:AnyMark()
	call s:Search(l:markText, a:isBackward, l:markPosition, 'mark-*')
	let s:lastSearch = -1
endfunction

" Search last searched mark.
function! mark#SearchNext( isBackward )
	let l:markText = mark#CurrentMark()[0]
	if empty(l:markText)
		return 0
	else
		if s:lastSearch == -1
			call mark#SearchAnyMark(a:isBackward)
		else
			call mark#SearchCurrentMark(a:isBackward)
		endif
		return 1
	endif
endfunction

" Load mark patterns from list.
function! mark#Load( pattern, enabled )
	if s:markNum > 0 && len(a:pattern) > 0
		" Initialize mark patterns with the passed list. Ensure that, regardless of
		" the list length, s:pattern contains exactly s:markNum elements.
		let s:pattern = a:pattern[0:(s:markNum - 1)]
		let s:pattern += repeat([''], (s:markNum - len(s:pattern)))

		let s:enabled = a:enabled

		call mark#UpdateScope()

		" The list of patterns may be sparse, return only the actual patterns.
		return len(filter(copy(a:pattern), '! empty(v:val)'))
	endif
	return 0
endfunction

" Access the list of mark patterns.
function! mark#ToPatternList()
	" Trim unused patterns from the end of the list, the amount of available marks
	" may differ on the next invocation (e.g. due to a different number of
	" highlight groups in Vim and GVIM). We want to keep empty patterns in the
	" front and middle to maintain the mapping to highlight groups, though.
	let l:highestNonEmptyIndex = s:markNum -1
	while l:highestNonEmptyIndex >= 0 && empty(s:pattern[l:highestNonEmptyIndex])
		let l:highestNonEmptyIndex -= 1
	endwhile

	return (l:highestNonEmptyIndex < 0 ? [] : s:pattern[0:l:highestNonEmptyIndex])
endfunction

" :MarkLoad command.
function! mark#LoadCommand( isShowMessages )
	if exists('g:MARK_MARKS')
		try
			" Persistent global variables cannot be of type List, so we actually store
			" the string representation, and eval() it back to a List.
			execute 'let l:loadedMarkNum = mark#Load(' . g:MARK_MARKS . ', ' . (exists('g:MARK_ENABLED') ? g:MARK_ENABLED : 1) . ')'
			if a:isShowMessages
				if l:loadedMarkNum == 0
					echomsg 'No persistent marks defined'
				else
					echomsg printf('Loaded %d mark%s', l:loadedMarkNum, (l:loadedMarkNum == 1 ? '' : 's')) . (s:enabled ? '' : '; marks currently disabled')
				endif
			endif
		catch /^Vim\%((\a\+)\)\=:E/
			let v:errmsg = 'Corrupted persistent mark info in g:MARK_MARKS and g:MARK_ENABLED'
			echohl ErrorMsg
			echomsg v:errmsg
			echohl None

			unlet! g:MARK_MARKS
			unlet! g:MARK_ENABLED
		endtry
	elseif a:isShowMessages
		let v:errmsg = 'No persistent marks found'
		echohl ErrorMsg
		echomsg v:errmsg
		echohl None
	endif
endfunction

" :MarkSave command.
function! s:SavePattern()
	let l:savedMarks = mark#ToPatternList()
	let g:MARK_MARKS = string(l:savedMarks)
	let g:MARK_ENABLED = s:enabled
	return ! empty(l:savedMarks)
endfunction
function! mark#SaveCommand()
	if index(split(&viminfo, ','), '!') == -1
		let v:errmsg = "Cannot persist marks, need ! flag in 'viminfo': :set viminfo+=!"
		echohl ErrorMsg
		echomsg v:errmsg
		echohl None
		return
	endif

	if ! s:SavePattern()
		let v:warningmsg = 'No marks defined'
		echohl WarningMsg
		echomsg v:warningmsg
		echohl None
	endif
endfunction


" Query mark group number.
function! s:GetNextGroupIndex()
	let l:nextGroupIndex = s:FreeGroupIndex()
	if l:nextGroupIndex == -1
		let l:nextGroupIndex = s:cycle
	endif
	return l:nextGroupIndex
endfunction
function! s:GetMarker( index, nextGroupIndex )
	let l:marker = ''
	if s:lastSearch == a:index
		let l:marker .= '/'
	endif
	if a:index == a:nextGroupIndex
		let l:marker .= '>'
	endif
	return l:marker
endfunction
function! s:GetAlternativeCount( pattern )
	return len(split(a:pattern, '\%(\%(^\|[^\\]\)\%(\\\\\)*\\\)\@<!\\|'))
endfunction
function! s:PrintMarkGroup( nextGroupIndex )
	for i in range(s:markNum)
		echon ' '
		execute 'echohl MarkWord' . (i + 1)
		let c = s:GetAlternativeCount(s:pattern[i])
		echon printf('%1s%s%2d ', s:GetMarker(i, a:nextGroupIndex), (c ? (c > 1 ? c : '') . '*' : ''), (i + 1))
		echohl None
	endfor
endfunction
function! mark#QueryMarkGroupNum()
	echohl Question
	echo 'Mark?'
	echohl None
	let l:nextGroupIndex = s:GetNextGroupIndex()
	call s:PrintMarkGroup(l:nextGroupIndex)

	let l:nr = 0
	while 1
		let l:char = nr2char(getchar())

		if l:char ==# "\<CR>"
			return (l:nr == 0 ? l:nextGroupIndex + 1 : l:nr)
		elseif l:char !~# '\d'
			return -1
		endif
		echon l:char

		let l:nr = 10 * l:nr + l:char
		if s:markNum < 10 * l:nr
			return l:nr
		endif
	endwhile
endfunction

" :Marks command.
function! mark#List()
	echohl Title
	echo 'mark  cnt  Pattern'
	echohl None
	echon '  (> next mark group   / current search mark)'
	let l:nextGroupIndex = s:GetNextGroupIndex()
	for i in range(s:markNum)
		execute 'echohl MarkWord' . (i + 1)
		let c = s:GetAlternativeCount(s:pattern[i])
		echo printf('%1s%3d%4s %s', s:GetMarker(i, l:nextGroupIndex), (i + 1), (c > 1 ? '('.c.')' : ''), s:pattern[i])
		echohl None
	endfor

	if ! s:enabled
		echo 'Marks are currently disabled.'
	endif
endfunction

function! mark#GetGroupNum()
	return s:markNum
endfunction


"- initializations ------------------------------------------------------------
augroup Mark
	autocmd!
	autocmd WinEnter * if ! exists('w:mwMatch') | call mark#UpdateMark() | endif
	autocmd TabEnter * call mark#UpdateScope()
augroup END

" Define global variables and initialize current scope.
function! mark#Init()
	let s:markNum = 0
	while hlexists('MarkWord' . (s:markNum + 1))
		let s:markNum += 1
	endwhile
	let s:pattern = repeat([''], s:markNum)
	let s:cycle = 0
	let s:lastSearch = -1
	let s:enabled = 1
endfunction
function! mark#ReInit( newMarkNum )
	if a:newMarkNum < s:markNum " There are less marks than before.
		" Clear the additional highlight groups.
		for i in range(a:newMarkNum + 1, s:markNum)
			execute 'highlight clear MarkWord' . (i + 1)
		endfor

		" Truncate the mark patterns.
		let s:pattern = s:pattern[0 : (a:newMarkNum - 1)]

		" Correct any indices.
		let s:cycle = min([s:cycle, (a:newMarkNum - 1)])
		let s:lastSearch = (s:lastSearch < a:newMarkNum ? s:lastSearch : -1)
	elseif a:newMarkNum > s:markNum " There are more marks than before.
		" Expand the mark patterns.
		let s:pattern += repeat([''], (a:newMarkNum - s:markNum))
	endif

	let s:markNum = a:newMarkNum
endfunction

call mark#Init()
if exists('g:mwDoDeferredLoad') && g:mwDoDeferredLoad
	unlet g:mwDoDeferredLoad
	call mark#LoadCommand(0)
else
	call mark#UpdateScope()
endif

" vim: ts=4 sts=0 sw=4 noet
