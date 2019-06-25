" ---------- clipboard.vim ----------
" 按键映射：剪切复制粘贴都操作register *，register * 对应的是操作系统的剪贴板
nnoremap yy "*yy
vnoremap y "*y
nnoremap Y "*Y
nnoremap cc "*cc<ESC>
vnoremap c "*c<ESC>
nnoremap C "*C<ESC>
vnoremap C "*C<ESC>
nnoremap p "*p
vnoremap p "*p
nnoremap P "*P
vnoremap P "*P

