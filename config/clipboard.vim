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

" 选择给定行数，因为默认的V选择有问题。
" 前面的j是为了抵消掉用户按下的数字，然后再用k回到原处，需要比较是否走到文件末尾，如果是就差值返回。
nnoremap <expr> V 'j'. (v:count < line('$')-line('.') ? v:count : line('$')-line('.')) .'kV'. (v:count-1) .'j'

