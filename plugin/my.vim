function! Reddit()
python << EOF
import vim
for i in dir(vim):
    vim.current.buffer.append(i)
for i in dir(vim.current.buffer):
    vim.current.buffer.append(i)
EOF
endfunction
