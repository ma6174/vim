" Author: Gergely Kontra <kgergely@mcl.hu>
"   You may direct issues regarding version 0.4+ to
"   Eric Van Dewoestine (ervandew@yahoo.com).
" Version: 0.41
" Description:
"   Use your tab key to do all your completion in insert mode!
"   The script remembers the last completion type, and applies that.
"   Eg.: You want to enter /usr/local/lib/povray3/
"   You type (in insert mode):
"   /u<C-x><C-f>/l<Tab><Tab><Tab>/p<Tab>/i<Tab>
"   You can also manipulate the completion type used by changing g:complType
"   variable.
"   You can cycle forward and backward with the <Tab> and <S-Tab> keys
"   (<S-Tab> will not work in the console version)
"   Note: you must press <Tab> once to be able to cycle back
" History:
"   0.41 Fixed couple bugs introduced in last version (Eric Van Dewoestine).
"   0.4  Added the following functionality (Eric Van Dewoestine)
"        - support for vim 7 omni, user, and spelling completion modes
"          (should be backwards compatible with vim 6.x).
"        - command :SuperTabHelp which opens a window with available
"          completion types that the user can choose from.
"        - variable g:SuperTabRetainCompletionType setting for determining if
"          and for how long to retain completion type.
"   0.32 Corrected tab-insertion/completing decidion (thx to: Lorenz Wegener)
"   0.31 Added <S-Tab> for backward cycling. (req by: Peter Chun)
"   0.3  Back to the roots. Autocompletion is another story...
"        Now the prompt appears, when showmode is on

if !exists('complType') "Integration with other completion functions...

  " This variable determines if, and for how long, the current completion type
  " is retained.  The possible values include:
  " 0 - The current completion type is only retained for the current completion.
  "     Once you have chosen a completion result or exited the completion
  "     mode, the default completion type is restored.
  " 1 - The current completion type is saved for the duration of your vim
  "     session or until you enter a different completion mode.
  "     (SuperTab default).
  " 2 - The current completion type is saved until you exit insert mode (via
  "     ESC).  Once you exit insert mode the default completion type is
  "     restored.
  if !exists("g:SuperTabRetainCompletionType")
    let g:SuperTabRetainCompletionType = 1
  endif

  " This variable is used to set the default completion type.
  " There is no need to escape this value as that will be done for you when
  " the type is set.
  " Ex.  let g:SuperTabDefaultCompletionType = "<C-X><C-U>"
  if !exists("g:SuperTabDefaultCompletionType")
    let g:SuperTabDefaultCompletionType = "<C-P>"
  endif

  " construct the help text.
  let s:tabHelp =
    \ "Hit <CR> or CTRL-] on the completion type you wish to swith to.\n" .
    \ "Use :help ins-completion for more information.\n" .
    \ "\n" .
    \ "|<C-N>|      - Keywords in 'complete' searching down.\n" .
    \ "|<C-P>|      - Keywords in 'complete' searching up (SuperTab default).\n" .
    \ "|<C-X><C-L>| - Whole lines.\n" .
    \ "|<C-X><C-N>| - Keywords in current file.\n" .
    \ "|<C-X><C-K>| - Keywords in 'dictionary'.\n" .
    \ "|<C-X><C-T>| - Keywords in 'thesaurus', thesaurus-style.\n" .
    \ "|<C-X><C-I>| - Keywords in the current and included files.\n" .
    \ "|<C-X><C-]>| - Tags.\n" .
    \ "|<C-X><C-F>| - File names.\n" .
    \ "|<C-X><C-D>| - Definitions or macros.\n" .
    \ "|<C-X><C-V>| - Vim command-line."
  if v:version >= 700
    let s:tabHelp = s:tabHelp . "\n" .
      \ "|<C-X><C-U>| - User defined completion.\n" .
      \ "|<C-X><C-O>| - Occult completion.\n" .
      \ "|<C-X>s|     - Spelling suggestions."
  endif

  " set the available completion types and modes.
  let s:types =
    \ "\<C-E>\<C-Y>\<C-L>\<C-N>\<C-K>\<C-T>\<C-I>\<C-]>\<C-F>\<C-D>\<C-V>\<C-N>\<C-P>"
  let s:modes = '/^E/^Y/^L/^N/^K/^T/^I/^]/^F/^D/^V/^P'
  if v:version >= 700
    let s:types = s:types . "\<C-U>\<C-O>\<C-N>\<C-P>s"
    let s:modes = s:modes . '/^U/^O/s'
  endif
  let s:types = s:types . "np"
  let s:modes = s:modes . '/n/p'

  " Globally available function that user's can use to create mappings to
  " quickly switch completion modes.  Useful when a user wants to restore the
  " default or switch to another mode without having to kick off a completion
  " of that type or use SuperTabHelp.
  " Example mapping to restore SuperTab default:
  "   nmap <F6> :call SetSuperTabCompletionType("<C-P>")<cr>
  fu! SuperTabSetCompletionType (type)
    exec "let g:complType = \"" . escape(a:type, '<') . "\""
  endf

  call SuperTabSetCompletionType(g:SuperTabDefaultCompletionType)

  im <C-X> <C-r>=CtrlXPP()<CR>

  " Setup mechanism to restore orignial completion type upon leaving insert
  " mode if g:SuperTabDefaultCompletionType == 2
  if g:SuperTabRetainCompletionType == 2
    " pre vim 7, must map <esc>
    if v:version < 700
      im <silent> <ESC>
        \ <ESC>:call SuperTabSetCompletionType(g:SuperTabDefaultCompletionType)<cr>

    " since vim 7, we can use InsertLeave autocmd.
    else
      augroup supertab
        autocmd InsertLeave *
          \ call SuperTabSetCompletionType(g:SuperTabDefaultCompletionType)
      augroup END
    endif
  endif

  fu! CtrlXPP()
    if &smd
      echo '' | echo '-- ^X++ mode (' . s:modes . ')'
    endif
    let complType=nr2char(getchar())
    if stridx(s:types, complType) != -1
      if stridx("\<C-E>\<C-Y>",complType)!=-1 " no memory, just scroll...
        return "\<C-x>".complType
      elseif stridx('np',complType)!=-1
        let complType=nr2char(char2nr(complType)-96)  " char2nr('n')-char2nr("\<C-n")
      else
        let complType="\<C-x>".complType
      endif

      if g:SuperTabRetainCompletionType
        let g:complType = complType
      endif

      return complType
    else
      echohl "Unknown mode"
      return complType
    endif
  endf

  " From the doc |insert.txt| improved
  im <Tab> <C-n>
  inore <S-Tab> <C-p>

  " This way after hitting <Tab>, hitting it once more will go to next match
  " (because in XIM mode <C-n> and <C-p> mappings are ignored)
  " and wont start a brand new completion
  " The side effect, that in the beginning of line <C-n> and <C-p> inserts a
  " <Tab>, but I hope it may not be a problem...
  ino <C-n> <C-R>=<SID>SuperTab('n')<CR>
  ino <C-p> <C-R>=<SID>SuperTab('p')<CR>

  fu! <SID>SuperTab(command)
    if (strpart(getline('.'),col('.')-2,1)=~'^\s\?$')
      return "\<Tab>"
    else
      " exception: if in <c-p> mode, then <c-n> should move up the list, and
      " <c-p> down the list.
      if a:command == 'p' && g:complType == "\<C-P>"
        return "\<C-N>"
      endif
      return g:complType
    endif
  endf

  fu! <SID>SuperTabHelp()
    if bufwinnr("SuperTabHelp") == -1
      botright split SuperTabHelp

      setlocal noswapfile
      setlocal buftype=nowrite
      setlocal bufhidden=delete

      let saved = @"
      let @" = s:tabHelp
      silent put
      call cursor(1,1)
      silent 1,delete
      call cursor(4,1)
      let @" = saved
      exec "resize " . line('$')

      syntax match Special "|.\{-}|"

      setlocal readonly
      setlocal nomodifiable

      nmap <silent> <buffer> <cr> :call <SID>SetCompletionType()<cr>
      nmap <silent> <buffer> <c-]> :call <SID>SetCompletionType()<cr>
    else
      exec bufwinnr("SuperTabHelp") . "winc w"
    endif
  endf

  fu! s:SetCompletionType ()
    let chosen = substitute(getline('.'), '.*|\(.*\)|.*', '\1', '')
    if chosen != getline('.')
      call SuperTabSetCompletionType(chosen)
      close
      winc p
    endif
  endf

  if !exists(":SuperTabHelp")
    command SuperTabHelp :call <SID>SuperTabHelp()
  endif
en
