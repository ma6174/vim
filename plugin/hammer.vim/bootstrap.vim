if !exists('g:HAMMER_INSTALL_PATH') 
  let g:HAMMER_INSTALL_PATH = fnamemodify(expand("<sfile>"), ":p:h")
end

:command! Hammer :call hammer#Hammer()
