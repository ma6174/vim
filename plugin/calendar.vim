"=============================================================================
" What Is This: Calendar
" File: calendar.vim
" Author: Yasuhiro Matsumoto <mattn.jp@gmail.com>
" Last Change: 27-Jan-2011.
" Version: 2.5
" Thanks:
"     SethMilliken                  : gave a hint for 2.4
"     bw1                           : bug fix
"     Ingo Karkat                   : bug fix
"     Thinca                        : bug report, bug fix
"     Yu Pei                        : bug report
"     Per Winkvist                  : bug fix
"     Serge (gentoosiast) Koksharov : bug fix
"     Vitor Antunes                 : bug fix
"     Olivier Mengue                : bug fix
"     Noel Henson                   : today action
"     Per Winkvist                  : bug report
"     Peter Findeisen               : bug fix
"     Chip Campbell                 : gave a hint for 1.3z
"     PAN Shizhu                    : gave a hint for 1.3y
"     Eric Wald                     : bug fix
"     Sascha Wuestemann             : advise
"     Linas Vasiliauskas            : bug report
"     Per Winkvist                  : bug report
"     Ronald Hoelwarth              : gave a hint for 1.3s
"     Vikas Agnihotri               : bug report
"     Steve Hall                    : gave a hint for 1.3q
"     James Devenish                : bug fix
"     Carl Mueller                  : gave a hint for 1.3o
"     Klaus Fabritius               : bug fix
"     Stucki                        : gave a hint for 1.3m
"     Rosta                         : bug report
"     Richard Bair                  : bug report
"     Yin Hao Liew                  : bug report
"     Bill McCarthy                 : bug fix and gave a hint
"     Srinath Avadhanula            : bug fix
"     Ronald Hoellwarth             : few advices
"     Juan Orlandini                : added higlighting of days with data
"     Ray                           : bug fix
"     Ralf.Schandl                  : gave a hint for 1.3
"     Bhaskar Karambelkar           : bug fix
"     Suresh Govindachar            : gave a hint for 1.2, bug fix
"     Michael Geddes                : bug fix
"     Leif Wickland                 : bug fix
" Usage:
"     :Calendar
"       show calendar at this year and this month
"     :Calendar 8
"       show calendar at this year and given month
"     :Calendar 2001 8
"       show calendar at given year and given month
"     :CalendarH ...
"       show horizontal calendar ...
"
"     <Leader>cal
"       show calendar in normal mode
"     <Leader>caL
"       show horizontal calendar ...
" ChangeLog:
"     2.5  : bug fix, 7.2 don't have relativenumber.
"     2.4  : added g:calendar_options.
"     2.3  : week number like ISO8601 
"            g:calendar_monday and g:calendar_weeknm work together
"     2.2  : http://gist.github.com/355513#file_customizable_keymap.diff
"            http://gist.github.com/355513#file_winfixwidth.diff
"     2.1  : bug fix, set filetype 'calendar'.
"     2.0  : bug fix, many bug fix and enhancements.
"     1.9  : bug fix, use nnoremap.
"     1.8  : bug fix, E382 when close diary.
"     1.7  : bug fix, week number was broken on 2008.
"     1.6  : added calendar_begin action.
"            added calendar_end action.
"     1.5  : bug fix, fixed ruler formating with strpart.
"            bug fix, using winfixheight.
"     1.4a : bug fix, week number was broken on 2005.
"            added calendar_today action.
"            bug fix, about wrapscan.
"            bug fix, about today mark.
"            bug fix, about today navigation.
"     1.4  : bug fix, and one improvement.
"            bug 1:
"              when marking the current date, there is not distinguished e.g. between
"              20041103 and 20040113, both dates are marked as today
"            bug 2:
"              the navigation mark "today" doesn't work
"            improvement:
"              the mapping t worked only when today was displayed, now it works always
"              and redisplays the cuurent month and today
"     1.3z : few changes
"            asign <Left>, <Right> for navigation.
"            set ws for search navigation.
"            add tag for GetLatestVimScripts(AutoInstall)
"     1.3y : bug fix, few changes
"            changed color syntax name. (ex. CalNavi, see bottom of this)
"            changed a map CalendarV for <Leader>cal
"            changed a map CalendarH for <Leader>caL
"            (competitive map for cvscommand.vim)
"            the date on the right-hand side didn't work correctoly.
"            make a map to rebuild Calendar window(r).
"     1.3x : bug fix
"            viweek can't refer when not set calendar_weeknm.
"     1.3w : bug fix
"            on leap year, week number decreases.
"     1.3v : bug fix
"            add nowrapscan 
"            use s:bufautocommandsset for making title
"            don't focus to navi when doubleclick bottom next>.
"     1.3u : bug fix
"             when enter diary first time,
"              it don't warn that you don't have diary directory.
"     1.3t : bug fix
"             make sure the variables for help
"     1.3s : bug fix
"             make a map CalendarV for <Leader>ca
"            add option calendar_navi_label
"             see Additional:
"            add option calendar_focus_today
"             see Additional:
"            add map ? for help
"     1.3r : bug fix
"             if clicked navigator, cursor go to strange position.
"     1.3q : bug fix
"             coundn't set calendar_navi
"              in its horizontal direction
"     1.3p : bug fix
"             coundn't edit diary when the calendar is
"              in its horizontal direction
"     1.3o : add option calendar_mark, and delete calendar_rmark
"             see Additional:
"            add option calendar_navi
"             see Additional:
"     1.3n : bug fix
"             s:CalendarSign() should use filereadable(expand(sfile)).
"     1.3m : tuning
"             using topleft or botright for opening Calendar.
"            use filereadable for s:CalendarSign().
"     1.3l : bug fix
"             if set calendar_monday, it can see that Sep 1st is Sat
"               as well as Aug 31st.
"     1.3k : bug fix
"             it didn't escape the file name on calendar.
"     1.3j : support for fixed Gregorian
"             added the part of Sep 1752.
"     1.3i : bug fix
"             Calculation mistake for week number.
"     1.3h : add option for position of displaying '*' or '+'.
"             see Additional:
"     1.3g : centering header
"            add option for show name of era.
"             see Additional:
"            bug fix
"             <Leader>ca didn't show current month.
"     1.3f : bug fix
"            there was yet another bug of today's sign.
"     1.3e : added usage for <Leader>
"            support handler for sign.
"            see Additional:
"     1.3d : added higlighting of days that have calendar data associated
"             with it.
"            bug fix for calculates date.
"     1.3c : bug fix for MakeDir()
"            if CalendarMakeDir(sfile) != 0
"               v 
"            if s:CalendarMakeDir(sfile) != 0
"     1.3b : bug fix for calendar_monday.
"            it didn't work g:calendar_monday correctly.
"            add g:calendar_version.
"            add argument on action handler.
"            see Additional:
"     1.3a : bug fix for MakeDir().
"            it was not able to make directory.
"     1.3  : support handler for action.
"            see Additional:
"     1.2g : bug fix for today's sign.
"            it could not display today's sign correctly.
"     1.2f : bug fix for current Date.
"            vtoday variable calculates date as 'YYYYMMDD'
"            while the loop calculates date as 'YYYYMMD' i.e just 1 digit
"            for date if < 10 so if current date is < 10 , the if condiction
"            to check for current date fails and current date is not
"            highlighted.
"            simple solution changed vtoday calculation line divide the
"            current-date by 1 so as to get 1 digit date.
"     1.2e : change the way for setting title.
"            auto configuration for g:calendar_wruler with g:calendar_monday
"     1.2d : add option for show week number.
"              let g:calendar_weeknm = 1
"            add separator if horizontal.
"            change all option's name
"              g:calendar_mnth -> g:calendar_mruler
"              g:calendar_week -> g:calendar_wruler
"              g:calendar_smnd -> g:calendar_monday
"     1.2c : add option for that the week starts with monday.
"              let g:calendar_smnd = 1
"     1.2b : bug fix for modifiable.
"            setlocal nomodifiable (was set)
"     1.2a : add default options.
"            nonumber,foldcolumn=0,nowrap... as making gap
"     1.2  : support wide display.
"            add a command CalendarH
"            add map <s-left> <s-right>
"     1.1c : extra.
"            add a titlestring for today.
"     1.1b : bug fix by Michael Geddes.
"            it happend when do ':Calender' twice
"     1.1a : fix misspell.
"            Calender -> Calendar
"     1.1  : bug fix.
"            it"s about strftime("%m")
"     1.0a : bug fix by Leif Wickland.
"            it"s about strftime("%w")
"     1.0  : first release.
" TODO:
"     add the option for diary which is separate or single file.
" Additional:
"     *if you want to keep focus when goto next or prev calendar,
"       add the following to your .vimrc:
"
"       let g:calendar_focus_today = 1
"
"     *if you want to place the mark('*' or '+') after the day,
"       add the following to your .vimrc:
"
"       let g:calendar_mark = 'right'
"
"       NOTE:you can set 'left', 'left-fit', 'right' for this option.
"
"     *if you want to use navigator,
"       add the following to your .vimrc:
"
"       let g:calendar_navi = ''
"
"       NOTE:you can set 'top', 'bottom', 'both' for this option.
"
"     *if you want to replace navigator in your language,
"       add the following to your .vimrc:
"
"       let g:calendar_navi_label = 'Prev,Today,Next'
"
"       NOTE:it must be separated with ','.
"
"     *if you want to replace calendar header,
"       add the following in your favorite language to your .vimrc:
"
"       let g:calendar_erafmt = 'Heisei,-1988'   " for Japanese
"       (name of era and diff with A.D.)
"
"     *if you want to replace calendar ruler,
"       add the following in your favorite language to your .vimrc:
"
"       let g:calendar_mruler = 'Jan,Feb,Mar,Apr,May,Jun,Jul,Aug,Sep,Oct,Nov,Dec'
"       let g:calendar_wruler = 'Su Mo Tu We Th Fr Sa'
"
"     *if you want the week to start with monday, add below to your .vimrc:
"
"       let g:calendar_monday = 1
"       (You don't have to to change g:calendar_wruler!)
"
"     *if you want to show week number, add this to your .vimrc:
"
"       set g:calendar_weeknm as below
"
"       let g:calendar_weeknm = 1 " WK01
"       let g:calendar_weeknm = 2 " WK 1
"       let g:calendar_weeknm = 3 " KW01
"       let g:calendar_weeknm = 4 " KW 1
"
"     *if you want to show the current date and time, add below to your .vimrc:
"
"       let g:calendar_datetime = 'title'
"
"       NOTE:you can set 'title', 'statusline', '' for this option.
"
"     *if you want to hook calender when pressing enter,
"       add this to your .vimrc:
"
"       function MyCalAction(day,month,year,week,dir)
"         " day   : day you actioned
"         " month : month you actioned
"         " year  : year you actioned
"         " week  : day of week (Mo=1 ... Su=7)
"         " dir   : direction of calendar
"       endfunction
"       let calendar_action = 'MyCalAction'
"
"       also, Calendar call following actions when begin or end of display.
"       them actions are called at one each time when it show 3 months display.
"
"       function MyCalActionBegin()
"       endfunction
"       let calendar_begin = 'MyCalActionBegin'
"
"       function MyCalActionEnd()
"       endfunction
"       let calendar_end = 'MyCalActionEnd'
"
"     *if you want to show sign in calender,
"       add this to your .vimrc:
"
"       function MyCalSign(day,month,year)
"         " day   : day you actioned
"         " month : month you actioned
"         " year  : year you actioned
"         if a:day == 1 && a:month == 1
"           return 1 " happy new year
"         else
"           return 0 " or not
"         endif
"       endfunction
"       let calendar_sign = 'MyCalSign'
"
"     *if you want to hook calender when pressing 'today',
"       add this to your .vimrc:
"
"       function MyCalToday()
"       endfunction
"       let calendar_today = 'MyCalToday'
"
"     *if you want to get the version of this.
"       type below.
"
"       :echo calendar_version
" GetLatestVimScripts: 52 1 :AutoInstall: calendar.vim

let g:calendar_version = "2.5"
if &compatible
  finish
endif

if !exists("g:calendar_action")
  let g:calendar_action = "<SID>CalendarDiary"
endif
if !exists("g:calendar_sign")
  let g:calendar_sign = "<SID>CalendarSign"
endif
if !exists("g:calendar_mark")
 \|| (g:calendar_mark != 'left'
 \&& g:calendar_mark != 'left-fit'
 \&& g:calendar_mark != 'right')
  let g:calendar_mark = 'left'
endif
if !exists("g:calendar_navi")
 \|| (g:calendar_navi != 'top'
 \&& g:calendar_navi != 'bottom'
 \&& g:calendar_navi != 'both'
 \&& g:calendar_navi != '')
  let g:calendar_navi = 'top'
endif
if !exists("g:calendar_navi_label")
  let g:calendar_navi_label = "Prev,Today,Next"
endif
if !exists("g:calendar_diary")
  let g:calendar_diary = "~/diary"
endif
if !exists("g:calendar_focus_today")
  let g:calendar_focus_today = 0
endif
if !exists("g:calendar_datetime")
 \|| (g:calendar_datetime != ''
 \&& g:calendar_datetime != 'title'
 \&& g:calendar_datetime != 'statusline')
  let g:calendar_datetime = 'title'
endif
if !exists("g:calendar_options")
  let g:calendar_options="fdc=0 nonu"
  if has("+relativenumber")
    let g:calendar_options .= " nornu"
  endif
endif

"*****************************************************************
"* Calendar commands
"*****************************************************************
command! -nargs=* Calendar  call Calendar(0,<f-args>)
command! -nargs=* CalendarH call Calendar(1,<f-args>)

if !hasmapto("<Plug>CalendarV")
  nmap <unique> <Leader>cal <Plug>CalendarV
endif
if !hasmapto("<Plug>CalendarH")
  nmap <unique> <Leader>caL <Plug>CalendarH
endif
nnoremap <silent> <Plug>CalendarV :cal Calendar(0)<CR>
nnoremap <silent> <Plug>CalendarH :cal Calendar(1)<CR>

"*****************************************************************
"* GetToken : get token from source with count
"*----------------------------------------------------------------
"*   src : source
"*   dlm : delimiter
"*   cnt : skip count
"*****************************************************************
function! s:GetToken(src,dlm,cnt)
  let tokn_hit=0     " flag of found
  let tokn_fnd=''    " found path
  let tokn_spl=''    " token
  let tokn_all=a:src " all source

  " safe for end
  let tokn_all = tokn_all.a:dlm
  while 1
    let tokn_spl = strpart(tokn_all,0,match(tokn_all,a:dlm))
    let tokn_hit = tokn_hit + 1
    if tokn_hit == a:cnt
      return tokn_spl
    endif
    let tokn_all = strpart(tokn_all,strlen(tokn_spl.a:dlm))
    if tokn_all == ''
      break
    endif
  endwhile
  return ''
endfunction

"*****************************************************************
"* CalendarDoAction : call the action handler function
"*----------------------------------------------------------------
"*****************************************************************
function! s:CalendarDoAction(...)
  " for navi
  if exists('g:calendar_navi')
    let navi = (a:0 > 0)? a:1 : expand("<cWORD>")
    let curl = line(".")
    if navi == '<' . s:GetToken(g:calendar_navi_label, ',', 1)
      if b:CalendarMonth > 1
        call Calendar(b:CalendarDir, b:CalendarYear, b:CalendarMonth-1)
      else
        call Calendar(b:CalendarDir, b:CalendarYear-1, 12)
      endif
    elseif navi == s:GetToken(g:calendar_navi_label, ',', 3) . '>'
      if b:CalendarMonth < 12
        call Calendar(b:CalendarDir, b:CalendarYear, b:CalendarMonth+1)
      else
        call Calendar(b:CalendarDir, b:CalendarYear+1, 1)
      endif
    elseif navi == s:GetToken(g:calendar_navi_label, ',', 2)
      call Calendar(b:CalendarDir)
      if exists('g:calendar_today')
        exe "call " . g:calendar_today . "()"
      endif
    else
      let navi = ''
    endif
    if navi != ''
      if g:calendar_focus_today == 1 && search("\*","w") > 0
        silent execute "normal! gg/\*\<cr>"
        return
      else
        if curl < line('$')/2
          silent execute "normal! gg0/".navi."\<cr>"
        else
          silent execute "normal! G$?".navi."\<cr>"
        endif
        return
      endif
    endif
  endif

  " if no action defined return
  if !exists("g:calendar_action") || g:calendar_action == ""
    return
  endif

  if b:CalendarDir
    let dir = 'H'
    if exists('g:calendar_weeknm')
      let cnr = col('.') - (col('.')%(24+5)) + 1
    else
      let cnr = col('.') - (col('.')%(24)) + 1
    endif
    let week = ((col(".") - cnr - 1 + cnr/49) / 3)
  else
    let dir = 'V'
    let cnr = 1
    let week = ((col(".")+1) / 3) - 1
  endif
  let lnr = 1
  let hdr = 1
  while 1
    if lnr > line('.')
      break
    endif
    let sline = getline(lnr)
    if sline =~ '^\s*$'
      let hdr = lnr + 1
    endif
    let lnr = lnr + 1
  endwhile
  let lnr = line('.')
  if(exists('g:calendar_monday'))
      let week = week + 1
  elseif(week == 0)
      let week = 7
  endif
  if lnr-hdr < 2
    return
  endif
  let sline = substitute(strpart(getline(hdr),cnr,21),'\s*\(.*\)\s*','\1','')
  if (col(".")-cnr) > 21
    return
  endif

  " extract day
  if g:calendar_mark == 'right' && col('.') > 1
    normal! h
    let day = matchstr(expand("<cword>"), '[^0].*')
    normal! l
  else
    let day = matchstr(expand("<cword>"), '[^0].*')
  endif
  if day == 0
    return
  endif
  " extract year and month
  if exists('g:calendar_erafmt') && g:calendar_erafmt !~ "^\s*$"
    let year = matchstr(substitute(sline, '/.*', '', ''), '\d\+')
    let month = matchstr(substitute(sline, '.*/\(\d\d\=\).*', '\1', ""), '[^0].*')
    if g:calendar_erafmt =~ '.*,[+-]*\d\+'
      let veranum=substitute(g:calendar_erafmt,'.*,\([+-]*\d\+\)','\1','')
      if year-veranum > 0
        let year=year-veranum
      endif
    endif
  else
    let year  = matchstr(substitute(sline, '/.*', '', ''), '[^0].*')
    let month = matchstr(substitute(sline, '\d*/\(\d\d\=\).*', '\1', ""), '[^0].*')
  endif
  " call the action function
  exe "call " . g:calendar_action . "(day, month, year, week, dir)"
endfunc

"*****************************************************************
"* Calendar : build calendar
"*----------------------------------------------------------------
"*   a1 : direction
"*   a2 : month(if given a3, it's year)
"*   a3 : if given, it's month
"*****************************************************************
function! Calendar(...)

  "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  "+++ ready for build
  "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  " remember today
  " divide strftime('%d') by 1 so as to get "1,2,3 .. 9" instead of "01, 02, 03 .. 09"
  let vtoday = strftime('%Y').strftime('%m').strftime('%d')

  " get arguments
  if a:0 == 0
    let dir = 0
    let vyear = strftime('%Y')
    let vmnth = matchstr(strftime('%m'), '[^0].*')
  elseif a:0 == 1
    let dir = a:1
    let vyear = strftime('%Y')
    let vmnth = matchstr(strftime('%m'), '[^0].*')
  elseif a:0 == 2
    let dir = a:1
    let vyear = strftime('%Y')
    let vmnth = matchstr(a:2, '^[^0].*')
  else
    let dir = a:1
    let vyear = a:2
    let vmnth = matchstr(a:3, '^[^0].*')
  endif

  " remember constant
  let vmnth_org = vmnth
  let vyear_org = vyear

  " start with last month
  let vmnth = vmnth - 1
  if vmnth < 1
    let vmnth = 12
    let vyear = vyear - 1
  endif

  " reset display variables
  let vdisplay1 = ''
  let vheight = 1
  let vmcnt = 0

  "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  "+++ build display
  "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  if exists("g:calendar_begin")
    exe "call " . g:calendar_begin . "()"
  endif
  while vmcnt < 3
    let vcolumn = 22
    let vnweek = -1
    "--------------------------------------------------------------
    "--- calculating
    "--------------------------------------------------------------
    " set boundary of the month
    if vmnth == 1
      let vmdays = 31
      let vparam = 1
      let vsmnth = 'Jan'
    elseif vmnth == 2
      let vmdays = 28
      let vparam = 32
      let vsmnth = 'Feb'
    elseif vmnth == 3
      let vmdays = 31
      let vparam = 60
      let vsmnth = 'Mar'
    elseif vmnth == 4
      let vmdays = 30
      let vparam = 91
      let vsmnth = 'Apr'
    elseif vmnth == 5
      let vmdays = 31
      let vparam = 121
      let vsmnth = 'May'
    elseif vmnth == 6
      let vmdays = 30
      let vparam = 152
      let vsmnth = 'Jun'
    elseif vmnth == 7
      let vmdays = 31
      let vparam = 182
      let vsmnth = 'Jul'
    elseif vmnth == 8
      let vmdays = 31
      let vparam = 213
      let vsmnth = 'Aug'
    elseif vmnth == 9
      let vmdays = 30
      let vparam = 244
      let vsmnth = 'Sep'
    elseif vmnth == 10
      let vmdays = 31
      let vparam = 274
      let vsmnth = 'Oct'
    elseif vmnth == 11
      let vmdays = 30
      let vparam = 305
      let vsmnth = 'Nov'
    elseif vmnth == 12
      let vmdays = 31
      let vparam = 335
      let vsmnth = 'Dec'
    else
      echo 'Invalid Year or Month'
      return
    endif
    if vyear % 400 == 0
      if vmnth == 2
        let vmdays = 29
      elseif vmnth >= 3
        let vparam = vparam + 1
      endif
    elseif vyear % 100 == 0
      if vmnth == 2
        let vmdays = 28
      endif
    elseif vyear % 4 == 0
      if vmnth == 2
        let vmdays = 29
      elseif vmnth >= 3
        let vparam = vparam + 1
      endif
    endif

    " calc vnweek of the day
    if vnweek == -1
      let vnweek = ( vyear * 365 ) + vparam
      let vnweek = vnweek + ( vyear/4 ) - ( vyear/100 ) + ( vyear/400 )
      if vyear % 4 == 0
        if vyear % 100 != 0 || vyear % 400 == 0
          let vnweek = vnweek - 1
        endif
      endif
      let vnweek = vnweek - 1
    endif

    " fix Gregorian
    if vyear <= 1752
      let vnweek = vnweek - 3
    endif

    let vnweek = vnweek % 7

    if exists('g:calendar_monday')
      " if given g:calendar_monday, the week start with monday
      if vnweek == 0
        let vnweek = 7
      endif
      let vnweek = vnweek - 1
    endif

    if exists('g:calendar_weeknm')
      " if given g:calendar_weeknm, show week number(ref:ISO8601)

      "vparam <= 1. day of month
      "vnweek <= 1. weekday of month (0-6)
      "viweek <= number of week
      "vfweek <= 1. day of year

      " mo di mi do fr sa so
      " 6  5  4  3  2  1  0  vfweek
      " 0  1  2  3  4  5  6  vnweek

      let vfweek =((vparam % 7)  -vnweek+ 14-2) % 7
      let viweek = (vparam - vfweek-2+7 ) / 7 +1 

      if vfweek < 3
         let viweek = viweek - 1
      endif

      "vfweekl  <=year length
      let vfweekl = 52
      if (vfweek == 3)  
        let vfweekl = 53
      endif

      if viweek == 0
        let viweek = 52
        if ((vfweek == 2) && (((vyear-1) % 4) !=0)) 
              \ || ((vfweek == 1) && (((vyear-1) % 4) ==0))
          let viweek = 53
        endif
      endif

      let vcolumn = vcolumn + 5
    endif

    "--------------------------------------------------------------
    "--- displaying
    "--------------------------------------------------------------
    " build header
    if exists('g:calendar_erafmt') && g:calendar_erafmt !~ "^\s*$"
      if g:calendar_erafmt =~ '.*,[+-]*\d\+'
        let veranum=substitute(g:calendar_erafmt,'.*,\([+-]*\d\+\)','\1','')
        if vyear+veranum > 0
          let vdisplay2=substitute(g:calendar_erafmt,'\(.*\),.*','\1','') 
          let vdisplay2=vdisplay2.(vyear+veranum).'/'.vmnth.'('
        else
          let vdisplay2=vyear.'/'.vmnth.'('
        endif
      else
        let vdisplay2=vyear.'/'.vmnth.'('
      endif
      let vdisplay2=strpart("                           ",
        \ 1,(vcolumn-strlen(vdisplay2))/2-2).vdisplay2
    else
      let vdisplay2=vyear.'/'.vmnth.'('
      let vdisplay2=strpart("                           ",
        \ 1,(vcolumn-strlen(vdisplay2))/2-2).vdisplay2
    endif
    if exists('g:calendar_mruler') && g:calendar_mruler !~ "^\s*$"
      let vdisplay2=vdisplay2.s:GetToken(g:calendar_mruler,',',vmnth).')'."\n"
    else
      let vdisplay2=vdisplay2.vsmnth.')'."\n"
    endif
    let vwruler = "Su Mo Tu We Th Fr Sa"
    if exists('g:calendar_wruler') && g:calendar_wruler !~ "^\s*$"
      let vwruler = g:calendar_wruler
    endif
    if exists('g:calendar_monday')
      let vwruler = strpart(vwruler,stridx(vwruler, ' ') + 1).' '.strpart(vwruler,0,stridx(vwruler, ' '))
    endif
    let vdisplay2 = vdisplay2.' '.vwruler."\n"
    if g:calendar_mark == 'right'
      let vdisplay2 = vdisplay2.' '
    endif

    " build calendar
    let vinpcur = 0
    while (vinpcur < vnweek)
      let vdisplay2=vdisplay2.'   '
      let vinpcur = vinpcur + 1
    endwhile
    let vdaycur = 1
    while (vdaycur <= vmdays)
      if vmnth < 10
         let vtarget =vyear."0".vmnth
      else
         let vtarget =vyear.vmnth
      endif
      if vdaycur < 10
         let vtarget = vtarget."0".vdaycur
      else
         let vtarget = vtarget.vdaycur
      endif
      if exists("g:calendar_sign") && g:calendar_sign != ""
        exe "let vsign = " . g:calendar_sign . "(vdaycur, vmnth, vyear)"
        if vsign != ""
          let vsign = vsign[0]
          if vsign !~ "[+!#$%&@?]"
            let vsign = "+"
          endif
        endif
      else
        let vsign = ''
      endif

      " show mark
      if g:calendar_mark == 'right'
        if vdaycur < 10
          let vdisplay2=vdisplay2.' '
        endif
        let vdisplay2=vdisplay2.vdaycur
      elseif g:calendar_mark == 'left-fit'
        if vdaycur < 10
          let vdisplay2=vdisplay2.' '
        endif
      endif
      if vtarget == vtoday
        let vdisplay2=vdisplay2.'*'
      elseif vsign != ''
        let vdisplay2=vdisplay2.vsign
      else
        let vdisplay2=vdisplay2.' '
      endif
      if g:calendar_mark == 'left'
        if vdaycur < 10
          let vdisplay2=vdisplay2.' '
        endif
        let vdisplay2=vdisplay2.vdaycur
      endif
      if g:calendar_mark == 'left-fit'
        let vdisplay2=vdisplay2.vdaycur
      endif
      let vdaycur = vdaycur + 1

      " fix Gregorian
      if vyear == 1752 && vmnth == 9 && vdaycur == 3
        let vdaycur = 14
      endif

      let vinpcur = vinpcur + 1
      if vinpcur % 7 == 0
        if exists('g:calendar_weeknm')
          if g:calendar_mark != 'right'
            let vdisplay2=vdisplay2.' '
          endif
          " if given g:calendar_weeknm, show week number
          if viweek < 10
            if g:calendar_weeknm == 1
              let vdisplay2=vdisplay2.'WK0'.viweek
            elseif g:calendar_weeknm == 2
              let vdisplay2=vdisplay2.'WK '.viweek
            elseif g:calendar_weeknm == 3
              let vdisplay2=vdisplay2.'KW0'.viweek
            elseif g:calendar_weeknm == 4
              let vdisplay2=vdisplay2.'KW '.viweek
            endif
          else
            if g:calendar_weeknm <= 2
              let vdisplay2=vdisplay2.'WK'.viweek
            else
              let vdisplay2=vdisplay2.'KW'.viweek
            endif
          endif
          let viweek = viweek + 1

          if viweek > vfweekl
            let viweek = 1
          endif

        endif
        let vdisplay2=vdisplay2."\n"
        if g:calendar_mark == 'right'
          let vdisplay2 = vdisplay2.' '
        endif
      endif
    endwhile

    " if it is needed, fill with space
    if vinpcur % 7 
      while (vinpcur % 7 != 0)
        let vdisplay2=vdisplay2.'   '
        let vinpcur = vinpcur + 1
      endwhile
      if exists('g:calendar_weeknm')
        if g:calendar_mark != 'right'
          let vdisplay2=vdisplay2.' '
        endif
        if viweek < 10
          if g:calendar_weeknm == 1
            let vdisplay2=vdisplay2.'WK0'.viweek
          elseif g:calendar_weeknm == 2
            let vdisplay2=vdisplay2.'WK '.viweek
          elseif g:calendar_weeknm == 3
            let vdisplay2=vdisplay2.'KW0'.viweek
          elseif g:calendar_weeknm == 4
            let vdisplay2=vdisplay2.'KW '.viweek
          endif
        else
          if g:calendar_weeknm <= 2
            let vdisplay2=vdisplay2.'WK'.viweek
          else
            let vdisplay2=vdisplay2.'KW'.viweek
          endif
        endif
      endif
    endif

    " build display
    let vstrline = ''
    if dir
      " for horizontal
      "--------------------------------------------------------------
      " +---+   +---+   +------+
      " |   |   |   |   |      |
      " | 1 | + | 2 | = |  1'  |
      " |   |   |   |   |      |
      " +---+   +---+   +------+
      "--------------------------------------------------------------
      let vtokline = 1
      while 1
        let vtoken1 = s:GetToken(vdisplay1,"\n",vtokline)
        let vtoken2 = s:GetToken(vdisplay2,"\n",vtokline)
        if vtoken1 == '' && vtoken2 == ''
          break
        endif
        while strlen(vtoken1) < (vcolumn+1)*vmcnt
          if strlen(vtoken1) % (vcolumn+1) == 0
            let vtoken1 = vtoken1.'|'
          else
            let vtoken1 = vtoken1.' '
          endif
        endwhile
        let vstrline = vstrline.vtoken1.'|'.vtoken2.' '."\n"
        let vtokline = vtokline + 1
      endwhile
      let vdisplay1 = vstrline
      let vheight = vtokline-1
    else
      " for virtical
      "--------------------------------------------------------------
      " +---+   +---+   +---+
      " | 1 | + | 2 | = |   |
      " +---+   +---+   | 1'|
      "                 |   |
      "                 +---+
      "--------------------------------------------------------------
      let vtokline = 1
      while 1
        let vtoken1 = s:GetToken(vdisplay1,"\n",vtokline)
        if vtoken1 == ''
          break
        endif
        let vstrline = vstrline.vtoken1."\n"
        let vtokline = vtokline + 1
        let vheight = vheight + 1
      endwhile
      if vstrline != ''
        let vstrline = vstrline.' '."\n"
        let vheight = vheight + 1
      endif
      let vtokline = 1
      while 1
        let vtoken2 = s:GetToken(vdisplay2,"\n",vtokline)
        if vtoken2 == ''
          break
        endif
        while strlen(vtoken2) < vcolumn
          let vtoken2 = vtoken2.' '
        endwhile
        let vstrline = vstrline.vtoken2."\n"
        let vtokline = vtokline + 1
        let vheight = vtokline + 1
      endwhile
      let vdisplay1 = vstrline
    endif
    let vmnth = vmnth + 1
    let vmcnt = vmcnt + 1
    if vmnth > 12
      let vmnth = 1
      let vyear = vyear + 1
    endif
  endwhile
  if exists("g:calendar_end")
    exe "call " . g:calendar_end . "()"
  endif
  if a:0 == 0
    return vdisplay1
  endif

  "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  "+++ build window
  "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  " make window
  let vwinnum=bufnr('__Calendar')
  if getbufvar(vwinnum, 'Calendar')=='Calendar'
    let vwinnum=bufwinnr(vwinnum)
  else
    let vwinnum=-1
  endif

  if vwinnum >= 0
    " if already exist
    if vwinnum != bufwinnr('%')
      exe vwinnum . 'wincmd w'
    endif
    setlocal modifiable
    silent %d _
  else
    " make title
    if g:calendar_datetime == "title" && (!exists('s:bufautocommandsset'))
      auto BufEnter *Calendar let b:sav_titlestring = &titlestring | let &titlestring = '%{strftime("%c")}'
      auto BufLeave *Calendar let &titlestring = b:sav_titlestring
      let s:bufautocommandsset=1
    endif

    if exists('g:calendar_navi') && dir
      if g:calendar_navi == 'both'
        let vheight = vheight + 4
      else
        let vheight = vheight + 2
      endif
    endif

    " or not
    if dir
      silent execute 'bo '.vheight.'split __Calendar'
      setlocal winfixheight
    else
      silent execute 'to '.vcolumn.'vsplit __Calendar'
      setlocal winfixwidth
    endif
    call s:CalendarBuildKeymap(dir, vyear, vmnth)
    setlocal noswapfile
    setlocal buftype=nofile
    setlocal bufhidden=delete
    silent! exe "setlocal " . g:calendar_options
    let nontext_columns = &foldcolumn + &nu * &numberwidth
    if has("+relativenumber")
      let nontext_columns += &rnu * &numberwidth
    endif
    " Without this, the 'sidescrolloff' setting may cause the left side of the
    " calendar to disappear if the last inserted element is near the right
    " window border.
    setlocal nowrap
    setlocal norightleft
    setlocal modifiable
    setlocal nolist
    let b:Calendar='Calendar'
    setlocal filetype=calendar
    " is this a vertical (0) or a horizontal (1) split?
    exe vcolumn + nontext_columns . "wincmd |"
  endif
  if g:calendar_datetime == "statusline"
    setlocal statusline=%{strftime('%c')}
  endif
  let b:CalendarDir=dir
  let b:CalendarYear = vyear_org
  let b:CalendarMonth = vmnth_org

  " navi
  if exists('g:calendar_navi')
    let navi_label = '<'
        \.s:GetToken(g:calendar_navi_label, ',', 1).' '
        \.s:GetToken(g:calendar_navi_label, ',', 2).' '
        \.s:GetToken(g:calendar_navi_label, ',', 3).'>'
    if dir
      let navcol = vcolumn + (vcolumn-strlen(navi_label)+2)/2
    else
      let navcol = (vcolumn-strlen(navi_label)+2)/2
    endif
    if navcol < 3
      let navcol = 3
    endif

    if g:calendar_navi == 'top'
      execute "normal gg".navcol."i "
      silent exec "normal! a".navi_label."\<cr>\<cr>"
      silent put! =vdisplay1
    endif
    if g:calendar_navi == 'bottom'
      silent put! =vdisplay1
      silent exec "normal! Gi\<cr>"
      execute "normal ".navcol."i "
      silent exec "normal! a".navi_label
    endif
    if g:calendar_navi == 'both'
      execute "normal gg".navcol."i "
      silent exec "normal! a".navi_label."\<cr>\<cr>"
      silent put! =vdisplay1
      silent exec "normal! Gi\<cr>"
      execute "normal ".navcol."i "
      silent exec "normal! a".navi_label
    endif
  else
    silent put! =vdisplay1
  endif

  setlocal nomodifiable
  " In case we've gotten here from insert mode (via <C-O>:Calendar<CR>)...
  stopinsert

  let vyear = vyear_org
  let vmnth = vmnth_org

  "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  "+++ build highlight
  "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  " today
  syn clear
  if g:calendar_mark =~ 'left-fit'
    syn match CalToday display "\s*\*\d*"
    syn match CalMemo display "\s*[+!#$%&@?]\d*"
  elseif g:calendar_mark =~ 'right'
    syn match CalToday display "\d*\*\s*"
    syn match CalMemo display "\d*[+!#$%&@?]\s*"
  else
    syn match CalToday display "\*\s*\d*"
    syn match CalMemo display "[+!#$%&@?]\s*\d*"
  endif
  " header
  syn match CalHeader display "[^ ]*\d\+\/\d\+([^)]*)"

  " navi
  if exists('g:calendar_navi')
    exec "silent! syn match CalNavi display \"\\(<"
        \.s:GetToken(g:calendar_navi_label, ',', 1)."\\|"
        \.s:GetToken(g:calendar_navi_label, ',', 3).">\\)\""
    exec "silent! syn match CalNavi display \"\\s"
        \.s:GetToken(g:calendar_navi_label, ',', 2)."\\s\"hs=s+1,he=e-1"
  endif

  " saturday, sunday
  let dayorspace = '\(\*\|\s\)\(\s\|\d\)\(\s\|\d\)'
  if !exists('g:calendar_weeknm') || g:calendar_weeknm <= 2
    let wknmstring = '\(\sWK[0-9\ ]\d\)*'
  else
    let wknmstring = '\(\sKW[0-9\ ]\d\)*'
  endif
  let eolnstring = '\s\(|\|$\)'
  if exists('g:calendar_monday')
    execute "syn match CalSaturday display \'"
      \.dayorspace.dayorspace.wknmstring.eolnstring."\'ms=s+1,me=s+3"
    execute "syn match CalSunday display \'"
      \.dayorspace.wknmstring.eolnstring."\'ms=s+1,me=s+3"
  else
    if dir
      execute "syn match CalSaturday display \'"
        \.dayorspace.wknmstring.eolnstring."\'ms=s+1,me=s+3"
      execute "syn match CalSunday display \'\|"
        \.dayorspace."\'ms=s+2,me=s+4"
    else
      execute "syn match CalSaturday display \'"
        \.dayorspace.wknmstring.eolnstring."\'ms=s+1,me=s+3"
      execute "syn match CalSunday display \'^"
        \.dayorspace."\'ms=s+1,me=s+3"
    endif
  endif

  " week number
  if !exists('g:calendar_weeknm') || g:calendar_weeknm <= 2
    syn match CalWeeknm display "WK[0-9\ ]\d"
  else
    syn match CalWeeknm display "KW[0-9\ ]\d"
  endif

  " ruler
  execute 'syn match CalRuler "'.vwruler.'"'

  if search("\*","w") > 0
    silent execute "normal! gg/\*\<cr>"
  endif

  return ''
endfunction

"*****************************************************************
"* CalendarMakeDir : make directory
"*----------------------------------------------------------------
"*   dir : directory
"*****************************************************************
function! s:CalendarMakeDir(dir)
  if(has("unix"))
    call system("mkdir " . a:dir)
    let rc = v:shell_error
  elseif(has("win16") || has("win32") || has("win95") ||
              \has("dos16") || has("dos32") || has("os2"))
    call system("mkdir \"" . a:dir . "\"")
    let rc = v:shell_error
  else
    let rc = 1
  endif
  if rc != 0
    call confirm("can't create directory : " . a:dir, "&OK")
  endif
  return rc
endfunc

"*****************************************************************
"* CalendarDiary : calendar hook function
"*----------------------------------------------------------------
"*   day   : day you actioned
"*   month : month you actioned
"*   year  : year you actioned
"*****************************************************************
function! s:CalendarDiary(day, month, year, week, dir)
  " build the file name and create directories as needed
  if !isdirectory(expand(g:calendar_diary))
    call confirm("please create diary directory : ".g:calendar_diary, 'OK')
    return
  endif
  let sfile = expand(g:calendar_diary) . "/" . a:year
  if isdirectory(sfile) == 0
    if s:CalendarMakeDir(sfile) != 0
      return
    endif
  endif
  let sfile = sfile . "/" . a:month
  if isdirectory(sfile) == 0
    if s:CalendarMakeDir(sfile) != 0
      return
    endif
  endif
  let sfile = expand(sfile) . "/" . a:day . ".cal"
  let sfile = substitute(sfile, ' ', '\\ ', 'g')
  let vbufnr = bufnr('__Calendar')

  " load the file
  exe "sp " . sfile
  setlocal ft=calendar
  let dir = getbufvar(vbufnr, "CalendarDir")
  let vyear = getbufvar(vbufnr, "CalendarYear")
  let vmnth = getbufvar(vbufnr, "CalendarMonth")
  exe "auto BufDelete ".escape(sfile, ' \\')." call Calendar(" . dir . "," . vyear . "," . vmnth . ")"
endfunc

"*****************************************************************
"* CalendarSign : calendar sign function
"*----------------------------------------------------------------
"*   day   : day of sign
"*   month : month of sign
"*   year  : year of sign
"*****************************************************************
function! s:CalendarSign(day, month, year)
  let sfile = g:calendar_diary."/".a:year."/".a:month."/".a:day.".cal"
  return filereadable(expand(sfile))
endfunction

"*****************************************************************
"* CalendarVar : get variable
"*----------------------------------------------------------------
"*****************************************************************
function! s:CalendarVar(var)
  if !exists(a:var)
    return ''
  endif
  exec 'return ' . a:var
endfunction

"*****************************************************************
"* CalendarBuildKeymap : build keymap
"*----------------------------------------------------------------
"*****************************************************************
function! s:CalendarBuildKeymap(dir, vyear, vmnth)
  " make keymap
  execute 'nnoremap <silent> <buffer> q :close<bar>wincmd p<cr>'

  execute 'nnoremap <silent> <buffer> <Plug>CalendarDoAction  :call <SID>CalendarDoAction()<cr>'
  execute 'nnoremap <silent> <buffer> <Plug>CalendarDoAction  :call <SID>CalendarDoAction()<cr>'
  execute 'nnoremap <silent> <buffer> <Plug>CalendarGotoToday :call Calendar(b:CalendarDir)<cr>'
  execute 'nnoremap <silent> <buffer> <Plug>CalendarShowHelp  :call <SID>CalendarHelp()<cr>'
  execute 'nnoremap <silent> <buffer> <Plug>CalendarReDisplay :call Calendar(' . a:dir . ',' . a:vyear . ',' . a:vmnth . ')<cr>'
  let pnav = s:GetToken(g:calendar_navi_label, ',', 1)
  let nnav = s:GetToken(g:calendar_navi_label, ',', 3)
  execute 'nnoremap <silent> <buffer> <Plug>CalendarGotoPrevMonth :call <SID>CalendarDoAction("<' . pnav . '")<cr>'
  execute 'nnoremap <silent> <buffer> <Plug>CalendarGotoNextMonth :call <SID>CalendarDoAction("' . nnav . '>")<cr>'
  execute 'nnoremap <silent> <buffer> <Plug>CalendarGotoPrevYear  :call Calendar('.a:dir.','.(a:vyear-1).','.a:vmnth.')<cr>'
  execute 'nnoremap <silent> <buffer> <Plug>CalendarGotoNextYear  :call Calendar('.a:dir.','.(a:vyear+1).','.a:vmnth.')<cr>'

  nmap <buffer> <CR>          <Plug>CalendarDoAction
  nmap <buffer> <2-LeftMouse> <Plug>CalendarDoAction
  nmap <buffer> t             <Plug>CalendarGotoToday
  nmap <buffer> ?             <Plug>CalendarShowHelp
  nmap <buffer> r             <Plug>CalendarReDisplay

  nmap <buffer> <Left>  <Plug>CalendarGotoPrevMonth
  nmap <buffer> <Right> <Plug>CalendarGotoNextMonth
  nmap <buffer> <Up>    <Plug>CalendarGotoPrevYear
  nmap <buffer> <Down>  <Plug>CalendarGotoNextYear
endfunction

"*****************************************************************
"* CalendarHelp : show help for Calendar
"*----------------------------------------------------------------
"*****************************************************************
function! s:CalendarHelp()
  echohl None
  echo 'Calendar version ' . g:calendar_version
  echohl SpecialKey
  echo '<Left>    : goto prev month'
  echo '<Right>   : goto next month'
  echo '<Up>      : goto prev year'
  echo '<Down>    : goto next year'
  echo 't         : goto today'
  echo 'q         : close window'
  echo 'r         : re-display window'
  echo '?         : show this help'
  if g:calendar_action == "<SID>CalendarDiary"
    echo '<cr>      : show diary'
  endif
  echo ''
  echohl Question
  echo 'calendar_erafmt=' . s:CalendarVar('g:calendar_erafmt')
  echo 'calendar_mruler=' . s:CalendarVar('g:calendar_mruler')
  echo 'calendar_wruler=' . s:CalendarVar('g:calendar_wruler')
  echo 'calendar_weeknm=' . s:CalendarVar('g:calendar_weeknm')
  echo 'calendar_navi_label=' . s:CalendarVar('g:calendar_navi_label')
  echo 'calendar_diary=' . s:CalendarVar('g:calendar_diary')
  echo 'calendar_mark=' . s:CalendarVar('g:calendar_mark')
  echo 'calendar_navi=' . s:CalendarVar('g:calendar_navi')
  echohl MoreMsg
  echo "[Hit any key]"
  echohl None
  call getchar()
  redraw!
endfunction

hi def link CalNavi     Search
hi def link CalSaturday Statement
hi def link CalSunday   Type
hi def link CalRuler    StatusLine
hi def link CalWeeknm   Comment
hi def link CalToday    Directory
hi def link CalHeader   Special
hi def link CalMemo     Identifier
