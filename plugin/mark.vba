" Vimball Archiver by Charles E. Campbell, Jr., Ph.D.
UseVimball
finish
autoload/mark.vim	[[[1
1002
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
autoload/mark/palettes.vim	[[[1
136
" mark/palettes.vim: Additional palettes for mark highlighting.
"
" DEPENDENCIES:
"
" Copyright: (C) 2012 Ingo Karkat
"   The VIM LICENSE applies to this script; see ':help copyright'.
"
" Maintainer:	Ingo Karkat <ingo@karkat.de>
" Contributors: rockybalboa4
"
" Version:     2.7.0
" Changes:
" 04-Jul-2012, Ingo Karkat
" - Add "maximum" palette contributed by rockybalboa4 and move it and the
"   "extended" palette to a separate mark/palettes.vim autoload script.

function! mark#palettes#Extended()
	return [
		\   { 'ctermbg':'Blue',       'ctermfg':'Black', 'guibg':'#A1B7FF', 'guifg':'#001E80' },
		\   { 'ctermbg':'Magenta',    'ctermfg':'Black', 'guibg':'#FFA1C6', 'guifg':'#80005D' },
		\   { 'ctermbg':'Green',      'ctermfg':'Black', 'guibg':'#ACFFA1', 'guifg':'#0F8000' },
		\   { 'ctermbg':'Yellow',     'ctermfg':'Black', 'guibg':'#FFE8A1', 'guifg':'#806000' },
		\   { 'ctermbg':'DarkCyan',   'ctermfg':'Black', 'guibg':'#D2A1FF', 'guifg':'#420080' },
		\   { 'ctermbg':'Cyan',       'ctermfg':'Black', 'guibg':'#A1FEFF', 'guifg':'#007F80' },
		\   { 'ctermbg':'DarkBlue',   'ctermfg':'Black', 'guibg':'#A1DBFF', 'guifg':'#004E80' },
		\   { 'ctermbg':'DarkMagenta','ctermfg':'Black', 'guibg':'#A29CCF', 'guifg':'#120080' },
		\   { 'ctermbg':'DarkRed',    'ctermfg':'Black', 'guibg':'#F5A1FF', 'guifg':'#720080' },
		\   { 'ctermbg':'Brown',      'ctermfg':'Black', 'guibg':'#FFC4A1', 'guifg':'#803000' },
		\   { 'ctermbg':'DarkGreen',  'ctermfg':'Black', 'guibg':'#D0FFA1', 'guifg':'#3F8000' },
		\   { 'ctermbg':'Red',        'ctermfg':'Black', 'guibg':'#F3FFA1', 'guifg':'#6F8000' },
		\   { 'ctermbg':'White',      'ctermfg':'Gray',  'guibg':'#E3E3D2', 'guifg':'#999999' },
		\   { 'ctermbg':'LightGray',  'ctermfg':'White', 'guibg':'#D3D3C3', 'guifg':'#666666' },
		\   { 'ctermbg':'Gray',       'ctermfg':'Black', 'guibg':'#A3A396', 'guifg':'#222222' },
		\   { 'ctermbg':'Black',      'ctermfg':'White', 'guibg':'#53534C', 'guifg':'#DDDDDD' },
		\   { 'ctermbg':'Black',      'ctermfg':'Gray',  'guibg':'#131311', 'guifg':'#AAAAAA' },
		\   { 'ctermbg':'Blue',       'ctermfg':'White', 'guibg':'#0000FF', 'guifg':'#F0F0FF' },
		\   { 'ctermbg':'DarkRed',    'ctermfg':'White', 'guibg':'#FF0000', 'guifg':'#FFFFFF' },
		\]
endfunction

function! mark#palettes#Maximum()
		let l:palette = [
		\   { 'ctermbg':'Cyan',       'ctermfg':'Black', 'guibg':'#8CCBEA', 'guifg':'Black' },
		\   { 'ctermbg':'Green',      'ctermfg':'Black', 'guibg':'#A4E57E', 'guifg':'Black' },
		\   { 'ctermbg':'Yellow',     'ctermfg':'Black', 'guibg':'#FFDB72', 'guifg':'Black' },
		\   { 'ctermbg':'Red',        'ctermfg':'Black', 'guibg':'#FF7272', 'guifg':'Black' },
		\   { 'ctermbg':'Magenta',    'ctermfg':'Black', 'guibg':'#FFB3FF', 'guifg':'Black' },
		\   { 'ctermbg':'Blue',       'ctermfg':'Black', 'guibg':'#9999FF', 'guifg':'Black' },
		\]
		if has('gui_running') || &t_Co >= 88
		let l:palette += [
		\   { 'ctermfg':'White',      'ctermbg':'17',    'guifg':'White',   'guibg':'#00005f' },
		\   { 'ctermfg':'White',      'ctermbg':'22',    'guifg':'White',   'guibg':'#005f00' },
		\   { 'ctermfg':'White',      'ctermbg':'23',    'guifg':'White',   'guibg':'#005f5f' },
		\   { 'ctermfg':'White',      'ctermbg':'27',    'guifg':'White',   'guibg':'#005fff' },
		\   { 'ctermfg':'White',      'ctermbg':'29',    'guifg':'White',   'guibg':'#00875f' },
		\   { 'ctermfg':'White',      'ctermbg':'34',    'guifg':'White',   'guibg':'#00af00' },
		\   { 'ctermfg':'Black',      'ctermbg':'37',    'guifg':'Black',   'guibg':'#00afaf' },
		\   { 'ctermfg':'Black',      'ctermbg':'43',    'guifg':'Black',   'guibg':'#00d7af' },
		\   { 'ctermfg':'Black',      'ctermbg':'47',    'guifg':'Black',   'guibg':'#00ff5f' },
		\   { 'ctermfg':'White',      'ctermbg':'52',    'guifg':'White',   'guibg':'#5f0000' },
		\   { 'ctermfg':'White',      'ctermbg':'53',    'guifg':'White',   'guibg':'#5f005f' },
		\   { 'ctermfg':'White',      'ctermbg':'58',    'guifg':'White',   'guibg':'#5f5f00' },
		\   { 'ctermfg':'White',      'ctermbg':'60',    'guifg':'White',   'guibg':'#5f5f87' },
		\   { 'ctermfg':'White',      'ctermbg':'64',    'guifg':'White',   'guibg':'#5f8700' },
		\   { 'ctermfg':'White',      'ctermbg':'65',    'guifg':'White',   'guibg':'#5f875f' },
		\   { 'ctermfg':'Black',      'ctermbg':'66',    'guifg':'Black',   'guibg':'#5f8787' },
		\   { 'ctermfg':'Black',      'ctermbg':'72',    'guifg':'Black',   'guibg':'#5faf87' },
		\   { 'ctermfg':'Black',      'ctermbg':'74',    'guifg':'Black',   'guibg':'#5fafd7' },
		\   { 'ctermfg':'Black',      'ctermbg':'78',    'guifg':'Black',   'guibg':'#5fd787' },
		\   { 'ctermfg':'Black',      'ctermbg':'79',    'guifg':'Black',   'guibg':'#5fd7af' },
		\   { 'ctermfg':'Black',      'ctermbg':'85',    'guifg':'Black',   'guibg':'#5fffaf' },
		\]
		endif
		if has('gui_running') || &t_Co >= 256
		let l:palette += [
		\   { 'ctermfg':'White',      'ctermbg':'90',    'guifg':'White',   'guibg':'#870087' },
		\   { 'ctermfg':'White',      'ctermbg':'95',    'guifg':'White',   'guibg':'#875f5f' },
		\   { 'ctermfg':'White',      'ctermbg':'96',    'guifg':'White',   'guibg':'#875f87' },
		\   { 'ctermfg':'Black',      'ctermbg':'101',   'guifg':'Black',   'guibg':'#87875f' },
		\   { 'ctermfg':'Black',      'ctermbg':'107',   'guifg':'Black',   'guibg':'#87af5f' },
		\   { 'ctermfg':'Black',      'ctermbg':'114',   'guifg':'Black',   'guibg':'#87d787' },
		\   { 'ctermfg':'Black',      'ctermbg':'117',   'guifg':'Black',   'guibg':'#87d7ff' },
		\   { 'ctermfg':'Black',      'ctermbg':'118',   'guifg':'Black',   'guibg':'#87ff00' },
		\   { 'ctermfg':'Black',      'ctermbg':'122',   'guifg':'Black',   'guibg':'#87ffd7' },
		\   { 'ctermfg':'White',      'ctermbg':'130',   'guifg':'White',   'guibg':'#af5f00' },
		\   { 'ctermfg':'White',      'ctermbg':'131',   'guifg':'White',   'guibg':'#af5f5f' },
		\   { 'ctermfg':'Black',      'ctermbg':'133',   'guifg':'Black',   'guibg':'#af5faf' },
		\   { 'ctermfg':'Black',      'ctermbg':'138',   'guifg':'Black',   'guibg':'#af8787' },
		\   { 'ctermfg':'Black',      'ctermbg':'142',   'guifg':'Black',   'guibg':'#afaf00' },
		\   { 'ctermfg':'Black',      'ctermbg':'152',   'guifg':'Black',   'guibg':'#afd7d7' },
		\   { 'ctermfg':'White',      'ctermbg':'160',   'guifg':'White',   'guibg':'#d70000' },
		\   { 'ctermfg':'Black',      'ctermbg':'166',   'guifg':'Black',   'guibg':'#d75f00' },
		\   { 'ctermfg':'Black',      'ctermbg':'169',   'guifg':'Black',   'guibg':'#d75faf' },
		\   { 'ctermfg':'Black',      'ctermbg':'174',   'guifg':'Black',   'guibg':'#d78787' },
		\   { 'ctermfg':'Black',      'ctermbg':'175',   'guifg':'Black',   'guibg':'#d787af' },
		\   { 'ctermfg':'Black',      'ctermbg':'186',   'guifg':'Black',   'guibg':'#d7d787' },
		\   { 'ctermfg':'Black',      'ctermbg':'190',   'guifg':'Black',   'guibg':'#d7ff00' },
		\   { 'ctermfg':'White',      'ctermbg':'198',   'guifg':'White',   'guibg':'#ff0087' },
		\   { 'ctermfg':'Black',      'ctermbg':'202',   'guifg':'Black',   'guibg':'#ff5f00' },
		\   { 'ctermfg':'Black',      'ctermbg':'204',   'guifg':'Black',   'guibg':'#ff5f87' },
		\   { 'ctermfg':'Black',      'ctermbg':'209',   'guifg':'Black',   'guibg':'#ff875f' },
		\   { 'ctermfg':'Black',      'ctermbg':'212',   'guifg':'Black',   'guibg':'#ff87d7' },
		\   { 'ctermfg':'Black',      'ctermbg':'215',   'guifg':'Black',   'guibg':'#ffaf5f' },
		\   { 'ctermfg':'Black',      'ctermbg':'220',   'guifg':'Black',   'guibg':'#ffd700' },
		\   { 'ctermfg':'Black',      'ctermbg':'224',   'guifg':'Black',   'guibg':'#ffd7d7' },
		\   { 'ctermfg':'Black',      'ctermbg':'228',   'guifg':'Black',   'guibg':'#ffff87' },
		\]
		endif
		if has('gui_running')
		let l:palette += [
		\   {                                            'guifg':'Black',   'guibg':'#b3dcff' },
		\   {                                            'guifg':'Black',   'guibg':'#99cbd6' },
		\   {                                            'guifg':'Black',   'guibg':'#7afff0' },
		\   {                                            'guifg':'Black',   'guibg':'#a6ffd2' },
		\   {                                            'guifg':'Black',   'guibg':'#a2de9e' },
		\   {                                            'guifg':'Black',   'guibg':'#bcff80' },
		\   {                                            'guifg':'Black',   'guibg':'#e7ff8c' },
		\   {                                            'guifg':'Black',   'guibg':'#f2e19d' },
		\   {                                            'guifg':'Black',   'guibg':'#ffcc73' },
		\   {                                            'guifg':'Black',   'guibg':'#f7af83' },
		\   {                                            'guifg':'Black',   'guibg':'#fcb9b1' },
		\   {                                            'guifg':'Black',   'guibg':'#ff8092' },
		\   {                                            'guifg':'Black',   'guibg':'#ff73bb' },
		\   {                                            'guifg':'Black',   'guibg':'#fc97ef' },
		\   {                                            'guifg':'Black',   'guibg':'#c8a3d9' },
		\   {                                            'guifg':'Black',   'guibg':'#ac98eb' },
		\   {                                            'guifg':'Black',   'guibg':'#6a6feb' },
		\   {                                            'guifg':'Black',   'guibg':'#8caeff' },
		\   {                                            'guifg':'Black',   'guibg':'#70b9fa' },
		\]
		endif
	return l:palette
endfunction

" vim: ts=4 sts=0 sw=4 noet
plugin/mark.vim	[[[1
411
" Script Name: mark.vim
" Description: Highlight several words in different colors simultaneously.
"
" Copyright:   (C) 2005-2008 Yuheng Xie
"              (C) 2008-2012 Ingo Karkat
"   The VIM LICENSE applies to this script; see ':help copyright'.
"
" Maintainer:  Ingo Karkat <ingo@karkat.de>
" Orig Author: Yuheng Xie <elephant@linux.net.cn>
" Contributors:Luc Hermitte, Ingo Karkat
"
" Dependencies:
"  - Requires Vim 7.1 with "matchadd()", or Vim 7.2 or higher.
"  - mark.vim autoload script
"  - mark/palettes.vim autoload script for additional palettes
"
" Version:     2.7.0
" Changes:
" 04-Jul-2012, Ingo Karkat
" - Introduce g:mwPalettes instead of hard-coding them in
"   s:DefaultHighlightings(), which got s:DefineHighlightings() extracted and
"   the rest renamed to s:GetPalette().
" - Allow overriding of existing mark highlighting via a:isOverride argument to
"   s:DefineHighlightings().
" - Add "maximum" palette contributed by rockybalboa4 and move it and the
"   "extended" palette to a separate mark/palettes.vim autoload script.
" - ENH: Implement :MarkPalette command to switch mark highlighting on-the-fly
"   during runtime.
"
" 24-Jun-2012, Ingo Karkat
" - Don't define the default <Leader>m and <Leader>r mappings in select mode,
"   just visual mode. Thanks to rockybalboa4 for pointing this out.
"
" 27-Mar-2012, Ingo Karkat
" - ENH: Allow choosing of palette and limiting of default mark highlight groups
"   via g:mwDefaultHighlightingPalette and g:mwDefaultHighlightingNum.
" - ENH: Offer an extended color palette in addition to the original 6-color one.
"
" 23-Mar-2012, Ingo Karkat
" - ENH: Add :Marks command that prints all mark highlight groups and their
"   search patterns, plus information about the current search mark, next mark
"   group, and whether marks are disabled.
" - FIX: When the cursor is positioned on the current mark, [N]<Leader>n /
"   <Plug>MarkClear with [N] appended the pattern for the current mark (again
"   and again) instead of clearing it. Must not pass current mark pattern when
"   [N] is given.
"
" 22-Mar-2012, Ingo Karkat
" - ENH: Allow [count] for <Leader>m and :Mark to add / subtract match to / from
"   highlight group [count], and use [count]<Leader>n to clear only highlight
"   group [count]. This was also requested by Philipp Marek.
"
" 02-Mar-2012, Philipp Marek
" - BUG: Version check mistakenly excluded Vim 7.1 versions that do have the
"   matchadd() function.
"
" 06-May-2011, Ingo Karkat
" - By default, enable g:mwAutoSaveMarks, so that marks are always persisted,
"   but disable g:mwAutoLoadMarks, so that persisted marks have to be explicitly
"   loaded, if that is desired. I often wondered why I got unexpected mark
"   highlightings in a new Vim session until I realized that I had used marks in
"   a previous session and forgot to clear them.
"
" 21-Apr-2011, Ingo Karkat
" - Expose toggling of mark display (keeping the mark patterns) via new
"   <Plug>MarkToggle mapping. Offer :MarkClear command as a replacement for the
"   old argumentless :Mark command, which now just disables, but not clears all
"   marks.
" - Implement lazy-loading of disabled persistent marks via g:mwDoDeferredLoad
"   flag passing to autoload/mark.vim.
"
" 19-Apr-2011, Ingo Karkat
" - ENH: Add explicit mark persistence via :MarkLoad and :MarkSave commands and
"   automatic persistence via the g:mwAutoLoadMarks and g:mwAutoSaveMarks
"   configuration flags.
"
" 15-Apr-2011, Ingo Karkat
" - Avoid losing the mark highlightings on :syn on or :colorscheme commands.
"   Thanks to Zhou YiChao for alerting me to this issue and suggesting a fix.
"
" 17-Nov-2009, Ingo Karkat
" - Replaced the (overly) generic mark#GetVisualSelectionEscaped() with
"   mark#GetVisualSelectionAsRegexp() and
"   mark#GetVisualSelectionAsLiteralPattern().
"
" 04-Jul-2009, Ingo Karkat
" - A [count] before any mapping either caused "No range allowed" error or just
"   repeated the :call [count] times, resulting in the current search pattern
"   echoed [count] times and a hit-enter prompt. Now suppressing [count] via
"   <C-u> and handling it inside the implementation.
" - Now passing isBackward (0/1) instead of optional 'b' flag into functions.
"   Also passing empty regexp to mark#MarkRegex() to avoid any optional
"   arguments.
"
" 02-Jul-2009, Ingo Karkat
" - Split off functions into autoload script.
" - Removed g:force_reload_mark.
" - Initialization of global variables and autocommands is now done lazily on
"   the first use, not during loading of the plugin. This reduces Vim startup
"   time and footprint as long as the functionality isn't yet used.
"
" 6-Jun-2009, Ingo Karkat
"  1. Somehow s:WrapMessage() needs a redraw before the :echo to avoid that a
"     later Vim redraw clears the wrap message. This happened when there's no
"     statusline and thus :echo'ing into the ruler.
"  2. Removed line-continuations and ':set cpo=...'. Upper-cased <SID> and <CR>.
"  3. Added default highlighting for the special search type.
"
" 2-Jun-2009, Ingo Karkat
"  1. Replaced highlighting via :syntax with matchadd() / matchdelete(). This
"     requires Vim 7.2 / 7.1 with patches. This method is faster, there are no
"     more clashes with syntax highlighting (:match always has preference), and
"     the background highlighting does not disappear under 'cursorline'.
"  2. Factored :windo application out into s:MarkScope().
"  3. Using winrestcmd() to fix effects of :windo: By entering a window, its
"     height is potentially increased from 0 to 1.
"  4. Handling multiple tabs by calling s:UpdateScope() on the TabEnter event.
"
" 1-Jun-2009, Ingo Karkat
"  1. Now using Vim List for g:mwWord and thus requiring Vim 7. g:mwCycle is now
"     zero-based, but the syntax groups "MarkWordx" are still one-based.
"  2. Added missing setter for re-inclusion guard.
"  3. Factored :syntax operations out of s:DoMark() and s:UpdateMark() so that
"     they can all be done in a single :windo.
"  4. Normal mode <Plug>MarkSet now has the same semantics as its visual mode
"     cousin: If the cursor is on an existing mark, the mark is removed.
"     Beforehand, one could only remove a visually selected mark via again
"     selecting it. Now, one simply can invoke the mapping when on such a mark.
"  5. Highlighting can now actually be overridden in the vimrc (anywhere
"     _before_ sourcing this script) by using ':hi def'.
"
" 31-May-2009, Ingo Karkat
"  1. Refactored s:Search() to optionally take advantage of SearchSpecial.vim
"     autoload functionality for echoing of search pattern, wrap and error
"     messages.
"  2. Now prepending search type ("any-mark", "same-mark", "new-mark") for
"     better identification.
"  3. Retired the algorithm in s:PrevWord in favor of simply using <cword>,
"     which makes mark.vim work like the * command. At the end of a line,
"     non-keyword characters may now be marked; the previous algorithm prefered
"     any preceding word.
"  4. BF: If 'iskeyword' contains characters that have a special meaning in a
"     regex (e.g. [.*]), these are now escaped properly.
"
" 01-Sep-2008, Ingo Karkat: bugfixes and enhancements
"  1. Added <Plug>MarkAllClear (without a default mapping), which clears all
"     marks, even when the cursor is on a mark.
"  2. Added <Plug>... mappings for hard-coded \*, \#, \/, \?, * and #, to allow
"     re-mapping and disabling. Beforehand, there were some <Plug>... mappings
"     and hard-coded ones; now, everything can be customized.
"  3. Bugfix: Using :autocmd without <bang> to avoid removing _all_ autocmds for
"     the BufWinEnter event. (Using a custom :augroup would be even better.)
"  4. Bugfix: Explicitly defining s:current_mark_position; some execution paths
"     left it undefined, causing errors.
"  5. Refactoring: Instead of calling s:InitMarkVariables() at the beginning of
"     several functions, just calling it once when sourcing the script.
"  6. Refactoring: Moved multiple 'let lastwinnr = winnr()' to a single one at the
"     top of DoMark().
"  7. ENH: Make the match according to the 'ignorecase' setting, like the star
"     command.
"  8. The jumps to the next/prev occurrence now print 'search hit BOTTOM,
"     continuing at TOP" and "Pattern not found:..." messages, like the * and
"     n/N Vim search commands.
"  9. Jumps now open folds if the occurrence is inside a closed fold, just like n/N
"     do.
"
" 10th Mar 2006, Yuheng Xie: jump to ANY mark
" (*) added \* \# \/ \? for the ability of jumping to ANY mark, even when the
"     cursor is not currently over any mark
"
" 20th Sep 2005, Yuheng Xie: minor modifications
" (*) merged MarkRegexVisual into MarkRegex
" (*) added GetVisualSelectionEscaped for multi-lines visual selection and
"     visual selection contains ^, $, etc.
" (*) changed the name ThisMark to CurrentMark
" (*) added SearchCurrentMark and re-used raw map (instead of Vim function) to
"     implement * and #
"
" 14th Sep 2005, Luc Hermitte: modifications done on v1.1.4
" (*) anti-reinclusion guards. They do not guard colors definitions in case
"     this script must be reloaded after .gvimrc
" (*) Protection against disabled |line-continuation|s.
" (*) Script-local functions
" (*) Default keybindings
" (*) \r for visual mode
" (*) uses <Leader> instead of "\"
" (*) do not mess with global variable g:w
" (*) regex simplified -> double quotes changed into simple quotes.
" (*) strpart(str, idx, 1) -> str[idx]
" (*) command :Mark
"     -> e.g. :Mark Mark.\{-}\ze(

" Avoid installing twice or when in unsupported Vim version.
if exists('g:loaded_mark') || (v:version == 701 && ! exists('*matchadd')) || (v:version < 701)
	finish
endif
let g:loaded_mark = 1
let s:save_cpo = &cpo
set cpo&vim

"- configuration --------------------------------------------------------------

if ! exists('g:mwHistAdd')
	let g:mwHistAdd = '/@'
endif

if ! exists('g:mwAutoLoadMarks')
	let g:mwAutoLoadMarks = 0
endif

if ! exists('g:mwAutoSaveMarks')
	let g:mwAutoSaveMarks = 1
endif

if ! exists('g:mwDefaultHighlightingNum')
	let g:mwDefaultHighlightingNum = -1
endif
if ! exists('g:mwDefaultHighlightingPalette')
	let g:mwDefaultHighlightingPalette = 'original'
endif
if ! exists('g:mwPalettes')
	let g:mwPalettes = {
	\	'original': [
		\   { 'ctermbg':'Cyan',       'ctermfg':'Black', 'guibg':'#8CCBEA', 'guifg':'Black' },
		\   { 'ctermbg':'Green',      'ctermfg':'Black', 'guibg':'#A4E57E', 'guifg':'Black' },
		\   { 'ctermbg':'Yellow',     'ctermfg':'Black', 'guibg':'#FFDB72', 'guifg':'Black' },
		\   { 'ctermbg':'Red',        'ctermfg':'Black', 'guibg':'#FF7272', 'guifg':'Black' },
		\   { 'ctermbg':'Magenta',    'ctermfg':'Black', 'guibg':'#FFB3FF', 'guifg':'Black' },
		\   { 'ctermbg':'Blue',       'ctermfg':'Black', 'guibg':'#9999FF', 'guifg':'Black' },
		\],
	\	'extended': function('mark#palettes#Extended'),
	\	'maximum': function('mark#palettes#Maximum')
	\}
endif



"- default highlightings ------------------------------------------------------

function! s:GetPalette()
	let l:palette = []
	if type(g:mwDefaultHighlightingPalette) == type([])
		" There are custom color definitions, not a named built-in palette.
		return g:mwDefaultHighlightingPalette
	endif
	if ! has_key(g:mwPalettes, g:mwDefaultHighlightingPalette)
		if ! empty(g:mwDefaultHighlightingPalette)
			let v:warningmsg = 'Mark: Unknown value for g:mwDefaultHighlightingPalette: ' . g:mwDefaultHighlightingPalette
			echohl WarningMsg
			echomsg v:warningmsg
			echohl None
		endif

		return []
	endif

	if type(g:mwPalettes[g:mwDefaultHighlightingPalette]) == type([])
		return g:mwPalettes[g:mwDefaultHighlightingPalette]
	elseif type(g:mwPalettes[g:mwDefaultHighlightingPalette]) == type(function('tr'))
		return call(g:mwPalettes[g:mwDefaultHighlightingPalette], [])
	else
		let v:errmsg = printf('Mark: Invalid value type for g:mwPalettes[%s]', g:mwDefaultHighlightingPalette)
		echohl ErrorMsg
		echomsg v:errmsg
		echohl None
		return []
	endif
endfunction
function! s:DefineHighlightings( palette, isOverride )
	let l:command = (a:isOverride ? 'highlight' : 'highlight def')
	let l:highlightingNum = (g:mwDefaultHighlightingNum == -1 ? len(a:palette) : g:mwDefaultHighlightingNum)
	for i in range(1, l:highlightingNum)
		execute l:command 'MarkWord' . i join(map(items(a:palette[i - 1]), 'join(v:val, "=")'))
	endfor
	return l:highlightingNum
endfunction
call s:DefineHighlightings(s:GetPalette(), 0)
autocmd ColorScheme * call <SID>DefineHighlightings(<SID>GetPalette(), 0)

" Default highlighting for the special search type.
" You can override this by defining / linking the 'SearchSpecialSearchType'
" highlight group before this script is sourced.
highlight def link SearchSpecialSearchType MoreMsg



"- mappings -------------------------------------------------------------------

nnoremap <silent> <Plug>MarkSet      :<C-u>if !mark#MarkCurrentWord(v:count)<Bar>execute "normal! \<lt>C-\>\<lt>C-n>\<lt>Esc>"<Bar>endif<CR>
vnoremap <silent> <Plug>MarkSet      :<C-u>if !mark#DoMark(v:count, mark#GetVisualSelectionAsLiteralPattern())<Bar>execute "normal! \<lt>C-\>\<lt>C-n>\<lt>Esc>"<Bar>endif<CR>
nnoremap <silent> <Plug>MarkRegex    :<C-u>call mark#MarkRegex('')<CR>
vnoremap <silent> <Plug>MarkRegex    :<C-u>call mark#MarkRegex(mark#GetVisualSelectionAsRegexp())<CR>
nnoremap <silent> <Plug>MarkClear    :<C-u>if !mark#DoMark(v:count, (v:count ? '' : mark#CurrentMark()[0]))<Bar>execute "normal! \<lt>C-\>\<lt>C-n>\<lt>Esc>"<Bar>endif<CR>
nnoremap <silent> <Plug>MarkAllClear :<C-u>call mark#ClearAll()<CR>
nnoremap <silent> <Plug>MarkToggle   :<C-u>call mark#Toggle()<CR>

nnoremap <silent> <Plug>MarkSearchCurrentNext :<C-u>call mark#SearchCurrentMark(0)<CR>
nnoremap <silent> <Plug>MarkSearchCurrentPrev :<C-u>call mark#SearchCurrentMark(1)<CR>
nnoremap <silent> <Plug>MarkSearchAnyNext     :<C-u>call mark#SearchAnyMark(0)<CR>
nnoremap <silent> <Plug>MarkSearchAnyPrev     :<C-u>call mark#SearchAnyMark(1)<CR>
nnoremap <silent> <Plug>MarkSearchNext        :<C-u>if !mark#SearchNext(0)<Bar>execute 'normal! *zv'<Bar>endif<CR>
nnoremap <silent> <Plug>MarkSearchPrev        :<C-u>if !mark#SearchNext(1)<Bar>execute 'normal! #zv'<Bar>endif<CR>
" When typed, [*#nN] open the fold at the search result, but inside a mapping or
" :normal this must be done explicitly via 'zv'.


if !hasmapto('<Plug>MarkSet', 'n')
	nmap <unique> <silent> <Leader>m <Plug>MarkSet
endif
if !hasmapto('<Plug>MarkSet', 'v')
	xmap <unique> <silent> <Leader>m <Plug>MarkSet
endif
if !hasmapto('<Plug>MarkRegex', 'n')
	nmap <unique> <silent> <Leader>r <Plug>MarkRegex
endif
if !hasmapto('<Plug>MarkRegex', 'v')
	xmap <unique> <silent> <Leader>r <Plug>MarkRegex
endif
if !hasmapto('<Plug>MarkClear', 'n')
	nmap <unique> <silent> <Leader>n <Plug>MarkClear
endif
" No default mapping for <Plug>MarkAllClear.
" No default mapping for <Plug>MarkToggle.

if !hasmapto('<Plug>MarkSearchCurrentNext', 'n')
	nmap <unique> <silent> <Leader>* <Plug>MarkSearchCurrentNext
endif
if !hasmapto('<Plug>MarkSearchCurrentPrev', 'n')
	nmap <unique> <silent> <Leader># <Plug>MarkSearchCurrentPrev
endif
if !hasmapto('<Plug>MarkSearchAnyNext', 'n')
	nmap <unique> <silent> <Leader>/ <Plug>MarkSearchAnyNext
endif
if !hasmapto('<Plug>MarkSearchAnyPrev', 'n')
	nmap <unique> <silent> <Leader>? <Plug>MarkSearchAnyPrev
endif
if !hasmapto('<Plug>MarkSearchNext', 'n')
	nmap <unique> <silent> * <Plug>MarkSearchNext
endif
if !hasmapto('<Plug>MarkSearchPrev', 'n')
	nmap <unique> <silent> # <Plug>MarkSearchPrev
endif



"- commands -------------------------------------------------------------------

command! -count -nargs=? Mark if !mark#DoMark(<count>, <f-args>) | echoerr printf('Only %d mark highlight groups', mark#GetGroupNum()) | endif
command! -bar MarkClear call mark#ClearAll()
command! -bar Marks call mark#List()

command! -bar MarkLoad call mark#LoadCommand(1)
command! -bar MarkSave call mark#SaveCommand()
function! s:SetPalette( paletteName )
	if type(g:mwDefaultHighlightingPalette) == type([])
		" Convert the directly defined list to a palette named "default".
		let g:mwPalettes['default'] = g:mwDefaultHighlightingPalette
		unlet! g:mwDefaultHighlightingPalette   " Avoid E706.
	endif
	let g:mwDefaultHighlightingPalette = a:paletteName

	let l:palette = s:GetPalette()
	if empty(l:palette)
		return
	endif

	call mark#ReInit(s:DefineHighlightings(l:palette, 1))
	call mark#UpdateScope()
endfunction
function! s:MarkPaletteComplete( ArgLead, CmdLine, CursorPos )
	return sort(filter(keys(g:mwPalettes), 'v:val =~ ''\V\^'' . escape(a:ArgLead, "\\")'))
endfunction
command! -bar -nargs=1 -complete=customlist,<SID>MarkPaletteComplete MarkPalette call <SID>SetPalette(<q-args>)



"- marks persistence ----------------------------------------------------------

if g:mwAutoLoadMarks
	" As the viminfo is only processed after sourcing of the runtime files, the
	" persistent global variables are not yet available here. Defer this until Vim
	" startup has completed.
	function! s:AutoLoadMarks()
		if g:mwAutoLoadMarks && exists('g:MARK_MARKS') && g:MARK_MARKS !=# '[]'
			if ! exists('g:MARK_ENABLED') || g:MARK_ENABLED
				" There are persistent marks and they haven't been disabled; we need to
				" show them right now.
				call mark#LoadCommand(0)
			else
				" Though there are persistent marks, they have been disabled. We avoid
				" sourcing the autoload script and its invasive autocmds right now;
				" maybe the marks are never turned on. We just inform the autoload
				" script that it should do this once it is sourced on-demand by a
				" mark mapping or command.
				let g:mwDoDeferredLoad = 1
			endif
		endif
	endfunction

	augroup MarkInitialization
		autocmd!
		" Note: Avoid triggering the autoload unless there actually are persistent
		" marks. For that, we need to check that g:MARK_MARKS doesn't contain the
		" empty list representation, and also :execute the :call.
		autocmd VimEnter * call <SID>AutoLoadMarks()
	augroup END
endif

let &cpo = s:save_cpo
unlet s:save_cpo
" vim: ts=4 sts=0 sw=4 noet
doc/mark.txt	[[[1
565
*mark.txt*              Highlight several words in different colors simultaneously.

			    MARK    by Ingo Karkat
		       (original version by Yuheng Xie)
								    *mark.vim*
description			|mark-description|
usage				|mark-usage|
installation			|mark-installation|
configuration			|mark-configuration|
limitations			|mark-limitations|
known problems			|mark-known-problems|
todo				|mark-todo|
history				|mark-history|

==============================================================================
DESCRIPTION						    *mark-description*

This plugin adds mappings and a :Mark command to highlight several words in
different colors simultaneously, similar to the built-in 'hlsearch'
highlighting of search results and the * |star| command. For example, when you
are browsing a big program file, you could highlight multiple identifiers in
parallel. This will make it easier to trace the source code.

This is a continuation of vimscript #1238 by Yuheng Xie, who apparently
doesn't maintain his original version anymore and cannot be reached via the
email address in his profile. This plugin offers the following advantages over
the original:
- Much faster, all colored words can now be highlighted, no more clashes with
  syntax highlighting (due to use of matchadd()).
- Many bug fixes.
- Jumps behave like the built-in search, including wrap and error messages.
- Like the built-in commands, jumps take an optional [count] to quickly skip
  over some marks.
- Marks can be persisted, and patterns can be added / subtracted from
  mark highlight groups.

RELATED WORKS								     *

- MultipleSearch (vimscript #479) can highlight in a single window and in all
  buffers, but still relies on the :syntax highlighting method, which is
  slower and less reliable.
- http://vim.wikia.com/wiki/Highlight_multiple_words offers control over the
  color used by mapping the 1-9 keys on the numeric keypad, persistence, and
  highlights only a single window.
- highlight.vim (vimscript #1599) highlights lines or patterns of interest in
  different colors, using mappings that start with CTRL-H and work on cword.
- quickhl.vim (vimscript #3692) can also list the matches with colors and in
  addition offers on-the-fly highlighting of the current word (like many IDEs
  do).

==============================================================================
USAGE								  *mark-usage*

HIGHLIGHTING						   *mark-highlighting*
						     *<Leader>m* *v_<Leader>m*
<Leader>m		Mark the word under the cursor, similar to the |star|
			command. The next free highlight group is used.
			If already on a mark: Clear the mark, like
			|<Leader>n|.
{Visual}<Leader>m	Mark or unmark the visual selection.
[N]<Leader>m		With [N], mark the word under the cursor with the
			named highlight group [N]. When that group is not
			empty, the word is added as an alternative match, so
			you can highlight multiple words with the same color.
			When the word is already contained in the list of
			alternatives, it is removed.

			When [N] is greater than the number of defined mark
			groups, a summary of marks is printed. Active mark
			groups are prefixed with "*" (or "M*" when there are
			M pattern alternatives), the default next group with
			">", the last used search with "/" (like |:Marks|
			does). Input the mark group, accept the default with
			<CR>, or abort with <Esc> or any other key.
			This way, when unsure about which number represents
			which color, just use 99<Leader>n and pick the color
			interactively!

{Visual}[N]<Leader>m	Ditto, based on the visual selection.

						     *<Leader>r* *v_<Leader>r*
<Leader>r		Manually input a regular expression to mark.
{Visual}<Leader>r	Ditto, based on the visual selection.

			In accordance with the built-in |star| command,
			all these mappings use 'ignorecase', but not
			'smartcase'.
								   *<Leader>n*
<Leader>n		Clear the mark under the cursor.
			If not on a mark: Disable all marks, similar to
			|:nohlsearch|.
			Note: Marks that span multiple lines are not detected,
			so the use of <Leader>n on such a mark will
			unintentionally remove all marks! Use
			{Visual}<Leader>r or :Mark {pattern} to clear
			multi-line marks (or pass [N] if you happen to know
			the group number).
[N]<Leader>n		Clear the marks represented by highlight group [N].

								       *:Mark*
:[N]Mark		Clear the marks represented by highlight group [N].
:[N]Mark {pattern}	Mark or unmark {pattern}. Unless [N] is given, the
			next free highlight group is used.
			With [N], mark the word under the cursor with the
			named highlight group [N]. When that group is not
			empty, the word is added as an alternative match, so
			you can highlight multiple words with the same color.
			When the word is already contained in the list of
			alternatives, it is removed.
			For implementation reasons, {pattern} cannot use the
			'smartcase' setting, only 'ignorecase'.
:Mark			Disable all marks, similar to |:nohlsearch|. Marks
			will automatically re-enable when a mark is added or
			removed, or a search for marks is performed.
								  *:MarkClear*
:MarkClear		Clear all marks. In contrast to disabling marks, the
			actual mark information is cleared, the next mark will
			use the first highlight group. This cannot be undone.


SEARCHING						      *mark-searching*
			    *<Leader>star* *<Leader>#* *<Leader>/* *<Leader>?*
[count]*         [count]#
[count]<Leader>* [count]<Leader>#
[count]<Leader>/ [count]<Leader>?
			Use these six keys to jump to the [count]'th next /
			previous occurrence of a mark.
			You could also use Vim's / and ? to search, since the
			mark patterns are (optionally, see configuration)
			added to the search history, too.

            Cursor over mark                    Cursor not over mark
 ---------------------------------------------------------------------------
  <Leader>* Jump to the next occurrence of      Jump to the next occurrence of
            current mark, and remember it       "last mark".
            as "last mark".

  <Leader>/ Jump to the next occurrence of      Same as left.
            ANY mark.

   *        If <Leader>* is the most recently   Do Vim's original * command.
            used, do a <Leader>*; otherwise
            (<Leader>/ is the most recently
            used), do a <Leader>/.

			Note: When the cursor is on a mark, the backwards
			search does not jump to the beginning of the current
			mark (like the built-in search), but to the previous
			mark. The entire mark text is treated as one entity.

			You can use Vim's |jumplist| to go back to previous
			mark matches and the position before a mark search.

MARK PERSISTENCE					    *mark-persistence*

The marks can be kept and restored across Vim sessions, using the |viminfo|
file. For this to work, the "!" flag must be part of the 'viminfo' setting: >
    set viminfo+=!  " Save and restore global variables.
<								   *:MarkLoad*
:MarkLoad		Restore the marks from the previous Vim session. All
			current marks are discarded.
								   *:MarkSave*
:MarkSave		Save the currently defined marks (or clear the
			persisted marks if no marks are currently defined) for
			use in a future Vim session.

By default, automatic persistence is enabled (so you don't need to explicitly
|:MarkSave|), but you have to explicitly load the persisted marks in a new Vim
session via |:MarkLoad|, to avoid that you accidentally drag along outdated
highlightings from Vim session to session, and be surprised by the arbitrary
highlight groups and occasional appearance of forgotten marks. If you want
just that though and automatically restore any marks, set |g:mwAutoLoadMarks|.

You can also initialize some marks (even using particular highlight groups) to
static values, e.g. by including this in |vimrc|: >
    runtime plugin/mark.vim
    silent MarkClear
    5Mark foo
    6Mark bar
Or you can define custom commands that preset certain marks: >
    command -bar MyMarks silent MarkClear | execute '5Mark foo' | execute '6Mark bar'
Or a command that adds to the existing marks and then toggles them: >
    command -bar ToggleFooBarMarks execute 'Mark foo' | execute 'Mark bar'
<
MARK INFORMATION					    *mark-information*

Both |mark-highlighting| and |mark-searching| commands print information about
the mark and search pattern, e.g.
	mark-1/\<pattern\> ~
This is especially useful when you want to add or subtract patterns to a mark
highlight group via [N].

								      *:Marks*
:Marks			List all mark highlight groups and the search patterns
			defined for them.
			The group that will be used for the next |:Mark| or
			|<Leader>m| command (with [N]) is shown with a ">".
			The last mark used for a search (via |<Leader>*|) is
			shown with a "/".

MARK HIGHLIGHTING PALETTES					*mark-palette*

The plugin comes with three predefined palettes: original, extended, and
maximum. You can dynamically toggle between them, e.g. when you need more
marks or a different set of colors.
								*:MarkPalette*
:MarkPalette {palette}	Highlight existing and future marks with the colors
			defined in {palette}. If the new palette contains less
			mark groups than the current one, the additional marks
			are lost.
			You can use |:command-completion| for {palette}.

See |g:mwDefaultHighlightingPalette| for how to change the default palette,
and |mark-palette-define| for how to add your own custom palettes.

==============================================================================
INSTALLATION						   *mark-installation*

This script is packaged as a|vimball|. If you have the "gunzip" decompressor
in your PATH, simply edit the *.vba.gz package in Vim; otherwise, decompress
the archive first, e.g. using WinZip. Inside Vim, install by sourcing the
vimball or via the |:UseVimball| command. >
    vim mark.vba.gz
    :so %
To uninstall, use the |:RmVimball| command.

DEPENDENCIES						   *mark-dependencies*

- Requires Vim 7.1 with "matchadd()", or Vim 7.2 or higher.

==============================================================================
CONFIGURATION						  *mark-configuration*

For a permanent configuration, put the following commands into your |vimrc|.

					 *mark-colors* *mark-highlight-colors*
This plugin defines 6 mark groups:
    1: Cyan  2:Green  3:Yellow  4:Red  5:Magenta  6:Blue ~
Higher numbers always take precedence and are displayed above lower ones.

					      *g:mwDefaultHighlightingPalette*
Especially if you use GVIM, you can switch to a richer palette of up to 18
colors: >
    let g:mwDefaultHighlightingPalette = 'extended'
Or, if you have both good eyes and display, you can try a palette that defines
27, 58, or even 77 colors, depending on the number of available colors: >
    let g:mwDefaultHighlightingPalette = 'maximum'
<
If you like the additional colors, but don't need that many of them, restrict
their number via: >
	let g:mwDefaultHighlightingNum = 9
<
							*mark-colors-redefine*
If none of the default highlightings suits you, define your own colors in your
vimrc file (or anywhere before this plugin is sourced), in the following form
(where N = 1..): >
    highlight MarkWordN ctermbg=Cyan ctermfg=Black guibg=#8CCBEA guifg=Black
You can also use this form to redefine only some of the default highlightings.
If you want to avoid losing the highlightings on |:colorscheme| commands, you
need to re-apply your highlights on the |ColorScheme| event, similar to how
this plugin does. Or you define the palette not via :highlight commands, but
use the plugin's infrastructure: >
    let g:mwDefaultHighlightingPalette = [
    \	{ 'ctermbg':'Cyan', 'ctermfg':'Black', 'guibg':'#8CCBEA', 'guifg':'Black' },
    \	...
    \]
<							 *mark-palette-define*
If you want to switch multiple palettes during runtime, you need to define
them as proper palettes: >
    let g:mwPalettes['mypalette'] = [
    \	{ 'ctermbg':'Cyan', 'ctermfg':'Black', 'guibg':'#8CCBEA', 'guifg':'Black' },
    \	...
    \]
    let g:mwPalettes['other'] = [ ... ]
    let g:mwDefaultHighlightingPalette = 'mypalette'
To add your palette to the existing ones, do this after the default palette
has been defined, e.g. in .vim/after/plugin/mark.vim). Alternatively, you can
also completely redefine all available palettes in .vimrc.

The search type highlighting (in the search message) can be changed via: >
    highlight link SearchSpecialSearchType MoreMsg
<
								 *g:mwHistAdd*
By default, any marked words are also added to the search (/) and input (@)
history; if you don't want that, remove the corresponding symbols from: >
    let g:mwHistAdd = '/@'
<
							   *g:mwAutoLoadMarks*
To enable the automatic restore of marks from a previous Vim session: >
    let g:mwAutoLoadMarks = 1
<							   *g:mwAutoSaveMarks*
To turn off the automatic persistence of marks across Vim sessions: >
    let g:mwAutoSaveMarks = 0
You can still explicitly save marks via |:MarkSave|.

							      *g:mwIgnoreCase*
If you have set 'ignorecase', but want marks to be case-insensitive, you can
override the default behavior of using 'ignorecase' by setting: >
	let g:mwIgnoreCase = 0
<

							       *mark-mappings*
You can use different mappings by mapping to the <Plug>Mark... mappings (use
":map <Plug>Mark" to list them all) before this plugin is sourced.

There are no default mappings for toggling all marks and for the |:MarkClear|
command, but you can define some yourself: >
    nmap <Leader>M <Plug>MarkToggle
    nmap <Leader>N <Plug>MarkAllClear
<
To remove the default overriding of * and #, use: >
    nmap <Plug>IgnoreMarkSearchNext <Plug>MarkSearchNext
    nmap <Plug>IgnoreMarkSearchPrev <Plug>MarkSearchPrev
<
						 *mark-whitespace-indifferent*
Some people like to create a mark based on the visual selection, like
|v_<Leader>m|, but have whitespace in the selection match any whitespace when
searching (searching for "hello world" will also find "hello<Tab>world" as
well as "hello" at the end of a line, with "world" at the start of the next
line). The Vim Tips Wiki describes such a setup for the built-in search at
    http://vim.wikia.com/wiki/Search_for_visually_selected_text
You can achieve the same with the Mark plugin through the following scriptlet: >
    function! s:GetVisualSelectionAsLiteralWhitespaceIndifferentPattern()
    	return substitute(escape(mark#GetVisualSelection(), '\' . '^$.*[~'), '\_s\+', '\\_s\\+', 'g')
    endfunction
    vnoremap <silent> <Plug>MarkWhitespaceIndifferent :<C-u>if !mark#DoMark(v:count, <SID>GetVisualSelectionAsLiteralWhitespaceIndifferentPattern())<Bar>execute "normal! \<lt>C-\>\<lt>C-n>\<lt>Esc>"<Bar>endif<CR>
Using this, you can assign a new visual mode mapping <Leader>* >
    vmap <Leader>* <Plug>MarkWhitespaceIndifferent
or override the default |v_<Leader>m| mapping, in case you always want this
behavior: >
    vmap <Plug>IgnoreMarkSet <Plug>MarkSet
    vmap <Leader>m <Plug>MarkWhitespaceIndifferent
<
==============================================================================
LIMITATIONS						    *mark-limitations*

- If the 'ignorecase' setting is changed, there will be discrepancies between
  the highlighted marks and subsequent jumps to marks.
- If {pattern} in a :Mark command contains atoms that change the semantics of
  the entire (|/\c|, |/\C|) or following (|/\v|,|/\V|, |/\M|) regular
  expression, there may be discrepancies between the highlighted marks and
  subsequent jumps to marks.

KNOWN PROBLEMS						 *mark-known-problems*

TODO								   *mark-todo*

IDEAS								  *mark-ideas*

Taken from an alternative implementation at
http://vim.wikia.com/wiki/Highlight_multiple_words:
- Use keys 1-9 on the numeric keypad to toggle a highlight group number.

==============================================================================
HISTORY								*mark-history*

2.7.0	04-Jul-2012
- ENH: Implement :MarkPalette command to switch mark highlighting on-the-fly
  during runtime.
- Add "maximum" palette contributed by rockybalboa4.

2.6.5	24-Jun-2012
- Don't define the default <Leader>m and <Leader>r mappings in select mode,
  just visual mode. Thanks to rockybalboa4 for pointing this out.

2.6.4	23-Apr-2012
- Allow to override 'ignorecase' setting via g:mwIgnoreCase. Thanks to fanhe
  for the idea and sending a patch.

2.6.3	27-Mar-2012
- ENH: Allow choosing of palette and limiting of default mark highlight groups
  via g:mwDefaultHighlightingPalette and g:mwDefaultHighlightingNum.
- ENH: Offer an extended color palette in addition to the original 6-color one.
  Enable this via :let g:mwDefaultHighlightingPalette = "extended" in your
  vimrc.

2.6.2	26-Mar-2012
- ENH: When a [count] exceeding the number of available mark groups is given,
  a summary of marks is given and the user is asked to select a mark group.
  This allows to interactively choose a color via 99<Leader>m.
  If you use the |mark-whitespace-indifferent| mappings, *** PLEASE UPDATE THE
  vnoremap <Plug>MarkWhitespaceIndifferent DEFINITION ***
- ENH: Include count of alternative patterns in :Marks list.
- CHG: Use ">" for next mark and "/" for last search in :Marks.

2.6.1	23-Mar-2012
- ENH: Add :Marks command that prints all mark highlight groups and their
  search patterns, plus information about the current search mark, next mark
  group, and whether marks are disabled.
- ENH: Show which mark group a pattern was set / added / removed / cleared.
- FIX: When the cursor is positioned on the current mark, [N]<Leader>n /
  <Plug>MarkClear with [N] appended the pattern for the current mark (again
  and again) instead of clearing it. Must not pass current mark pattern when
  [N] is given.
- CHG: Show mark group number in same-mark search and rename search types from
  "any-mark", "same-mark", and "new-mark" to the shorter "mark-*", "mark-N",
  and "mark-N!", respectively.

2.6.0	22-Mar-2012
- ENH: Allow [count] for <Leader>m and :Mark to add / subtract match to / from
  highlight group [count], and use [count]<Leader>n to clear only highlight
  group [count]. This was also requested by Philipp Marek.
- FIX: :Mark and <Leader>n actually toggled marks back on when they were
  already off. Now, they stay off on multiple invocations. Use :call
  mark#Toggle() / <Plug>MarkToggle if you want toggling.

2.5.3	02-Mar-2012
- BUG: Version check mistakenly excluded Vim 7.1 versions that do have the
  matchadd() function. Thanks to Philipp Marek for sending a patch.

2.5.2	09-Nov-2011
Fixed various problems with wrap-around warnings:
- BUG: With a single match and 'wrapscan' set, a search error was issued.
- FIX: Backwards search with single match leads to wrong error message
  instead.
- FIX: Wrong logic for determining l:isWrapped lets wrap-around go undetected.

2.5.1	17-May-2011
- FIX: == comparison in s:DoMark() leads to wrong regexp (\A vs. \a) being
  cleared when 'ignorecase' is set. Use case-sensitive comparison ==# instead.
- Refine :MarkLoad messages
- Add whitespace-indifferent visual mark configuration example. Thanks to Greg
  Klein for the suggestion.

2.5.0	07-May-2011
- ENH: Add explicit mark persistence via :MarkLoad and :MarkSave commands and
  automatic persistence via the g:mwAutoLoadMarks and g:mwAutoSaveMarks
  configuration flags. (Request from Mun Johl, 16-Apr-2010)
- Expose toggling of mark display (keeping the mark patterns) via new
  <Plug>MarkToggle mapping. Offer :MarkClear command as a replacement for the
  old argumentless :Mark command, which now just disables, but not clears all
  marks.

2.4.4	18-Apr-2011
- BUG: Include trailing newline character in check for current mark, so that a
  mark that matches the entire line (e.g. created by V<Leader>m) can be
  cleared via <Leader>n. Thanks to ping for reporting this.
- FIX: On overlapping marks, mark#CurrentMark() returned the lowest, not the
  highest visible mark. So on overlapping marks, the one that was not visible
  at the cursor position was removed; very confusing! Use reverse iteration
  order.
- FIX: To avoid an arbitrary ordering of highlightings when the highlighting
  group names roll over, and to avoid order inconsistencies across different
  windows and tabs, we assign a different priority based on the highlighting
  group.

2.4.3	16-Apr-2011
- Avoid losing the mark highlightings on :syn on or :colorscheme commands.
  Thanks to Zhou YiChao for alerting me to this issue and suggesting a fix.
- Made the script more robust when somehow no highlightings have been defined
  or when the window-local reckoning of match IDs got lost. I had very
  occasionally encountered such script errors in the past.
- Made global housekeeping variables script-local, only g:mwHistAdd is used
  for configuration.

2.4.2	14-Jan-2011 (unreleased)
- FIX: Capturing the visual selection could still clobber the blockwise yank
  mode of the unnamed register.

2.4.1	13-Jan-2011
- FIX: Using a named register for capturing the visual selection on
  {Visual}<Leader>m and {Visual}<Leader>r clobbered the unnamed register. Now
  using the unnamed register.

2.4.0	13-Jul-2010
- ENH: The MarkSearch mappings (<Leader>[*#/?]) add the original cursor
  position to the jump list, like the built-in [/?*#nN] commands. This allows
  to use the regular jump commands for mark matches, like with regular search
  matches.

2.3.3	19-Feb-2010
- BUG: Clearing of an accidental zero-width match (e.g. via :Mark \zs) results
  in endless loop. Thanks to Andy Wokula for the patch.

2.3.2	17-Nov-2009
- BUG: Creation of literal pattern via '\V' in {Visual}<Leader>m mapping
  collided with individual escaping done in <Leader>m mapping so that an
  escaped '\*' would be interpreted as a multi item when both modes are used
  for marking. Thanks to Andy Wokula for the patch.

2.3.1	06-Jul-2009
- Now working correctly when 'smartcase' is set. All mappings and the :Mark
  command use 'ignorecase', but not 'smartcase'.

2.3.0	04-Jul-2009
- All jump commands now take an optional [count], so you can quickly skip over
  some marks, as with the built-in */# and n/N commands. For this, the entire
  core search algorithm has been rewritten. The script's logic has been
  simplified through the use of Vim 7 features like Lists.
- Now also printing a Vim-alike search error message when 'nowrapscan' is set.

2.2.0	02-Jul-2009
- Split off functions into autoload script.
- Initialization of global variables and autocommands is now done lazily on
  the first use, not during loading of the plugin. This reduces Vim startup
  time and footprint as long as the functionality isn't yet used.
- Split off documentation into separate help file. Now packaging as VimBall.


2.1.0	06-Jun-2009
- Replaced highlighting via :syntax with matchadd() / matchdelete(). This
  requires Vim 7.2 / 7.1 with patches. This method is faster, there are no
  more clashes with syntax highlighting (:match always has preference), and
  the background highlighting does not disappear under 'cursorline'.
- Using winrestcmd() to fix effects of :windo: By entering a window, its
  height is potentially increased from 0 to 1.
- Handling multiple tabs by calling s:UpdateScope() on the TabEnter event.

2.0.0	01-Jun-2009
- Now using Vim List for g:mwWord and thus requiring Vim 7. g:mwCycle is now
  zero-based, but the syntax groups "MarkWordx" are still one-based.
- Factored :syntax operations out of s:DoMark() and s:UpdateMark() so that
  they can all be done in a single :windo.
- Normal mode <Plug>MarkSet now has the same semantics as its visual mode
  cousin: If the cursor is on an existing mark, the mark is removed.
  Beforehand, one could only remove a visually selected mark via again
  selecting it. Now, one simply can invoke the mapping when on such a mark.

1.6.1	31-May-2009
Publication of improved version by Ingo Karkat.
- Now prepending search type ("any-mark", "same-mark", "new-mark") for better
  identification.
- Retired the algorithm in s:PrevWord in favor of simply using <cword>, which
  makes mark.vim work like the * command. At the end of a line, non-keyword
  characters may now be marked; the previous algorithm preferred any preceding
  word.
- BF: If 'iskeyword' contains characters that have a special meaning in a
  regexp (e.g. [.*]), these are now escaped properly.
- Highlighting can now actually be overridden in the vimrc (anywhere _before_
  sourcing this script) by using ':hi def'.
- Added missing setter for re-inclusion guard.

1.5.0	01-Sep-2008
Bug fixes and enhancements by Ingo Karkat.
- Added <Plug>MarkAllClear (without a default mapping), which clears all
  marks, even when the cursor is on a mark.
- Added <Plug>... mappings for hard-coded \*, \#, \/, \?, * and #, to allow
  re-mapping and disabling. Beforehand, there were some <Plug>... mappings
  and hard-coded ones; now, everything can be customized.
- BF: Using :autocmd without <bang> to avoid removing _all_ autocmds for the
  BufWinEnter event. (Using a custom :augroup would be even better.)
- BF: Explicitly defining s:current_mark_position; some execution paths left
  it undefined, causing errors.
- ENH: Make the match according to the 'ignorecase' setting, like the star
  command.
- ENH: The jumps to the next/prev occurrence now print 'search hit BOTTOM,
  continuing at TOP" and "Pattern not found:..." messages, like the * and n/N
  Vim search commands.
- ENH: Jumps now open folds if the occurrence is inside a closed fold, just
  like n/N do.

1.1.8-g	25-Apr-2008
Last version published by Yuheng Xie on vim.org.

1.1.2	22-Mar-2005
Initial version published by Yuheng Xie on vim.org.

==============================================================================
Copyright: (C) 2005-2008 Yuheng Xie
           (C) 2008-2012 Ingo Karkat
The VIM LICENSE applies to this script; see|copyright|.

Maintainer:	Ingo Karkat <ingo@karkat.de>
==============================================================================
 vim:tw=78:ts=8:ft=help:norl:
