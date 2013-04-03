if exists("loaded_test")
finish
endif
let loaded_test = 1


function Test()
let len = strlen(getline("."))
return len
endfunction

function Py(w)
let word = a:w
python << EOF
import vim
def printword(w):
    print w
    printword(vim.eval("word"))
EOF
endfunction

function Getword()
let w = expand("<cword>")
call Py(w)
endfunction

function Echo(w)
echo a:w
endfunction

function Translate()
    let word = expand("<cword>")
python << EOF
import os
def Trans(word):
    print word
    cmd = "python2.7 ~/Youdao.py %s" % word
    os.system(cmd)
#    youdao(word)
Trans(vim.eval("word"))
EOF
endfunction
