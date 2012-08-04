if version < 600
 syntax clear
elseif exists("b:current_syntax")
 finish
endif
sy match  blogeditorEntry       "^ *[0-9]*\t.*$"
sy match  blogeditorComment     '^".*$'
sy match  blogeditorIdent       '^"[^:]*:'
hi link blogeditorComment     Comment
hi link blogeditorEntry       Directory
hi link blogeditorIdent       Function
let b:current_syntax = "blogsyntax"
