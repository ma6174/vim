if has('ruby')
  if !exists('g:HAMMER_SILENCE_WARNINGS')
    let g:HAMMER_SILENCE_WARNINGS = 0
  endif 

  if !exists('g:HAMMER_DIRECTORY')
    if has('win32') || has('win64')
      let g:HAMMER_DIRECTORY = $TEMP
    else
      let g:HAMMER_DIRECTORY = '/tmp'
    end
  endif

  if !exists('g:HAMMER_BROWSER')
    if has('mac')
      let g:HAMMER_BROWSER = 'open'
    elseif has('win32') || has('win64')
      ruby require 'hammer/vim-windows/rubygems'
      let g:HAMMER_BROWSER = 'start'
    elseif has('unix') && executable('xdg-open')
      let g:HAMMER_BROWSER = 'xdg-open'
    else
      let g:HAMMER_BROWSER = ''
    end
  endif

  if !exists('g:HAMMER_BROWSER_ARGS')
    let g:HAMMER_BROWSER_ARGS = ''
  endif

  if !exists('g:HAMMER_TEMPLATE')
    let g:HAMMER_TEMPLATE = 'default'
  endif

  ruby $: << File.join(Vim.evaluate('g:HAMMER_INSTALL_PATH'), 'lib') 
  ruby require 'hammer'
  ruby Hammer.load_dependencies! 
  ruby Hammer.load_renderers!

  function! hammer#Hammer()
    ruby <<RENDER!
      buffer = Vim::Buffer.current.extend Vim::ImprovedBuffer
      Hammer.render!(buffer)
RENDER!
  endfunction
else
  function! hammer#Hammer()
    echo "Sorry, hammer.vim requires vim to be built with Ruby support."
  endfunction
end
