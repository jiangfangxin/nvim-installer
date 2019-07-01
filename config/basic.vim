" ---------- basic.vim ----------
" 行号设置 
" 参考：[Vim’s absolute, relative and hybrid line numbers](https://jeffkreeftmeijer.com/vim-number/)
set number relativenumber   " 显示行号，相对光标的行号

" 聚焦的窗口显示相对行号，非聚焦的窗口显示绝对行号
" normal模式显示相对行号，insert模式显示绝对行号
augroup numbertoggle
  autocmd!
  autocmd BufEnter,FocusGained,InsertLeave * set number | set relativenumber
  autocmd BufLeave,FocusLost,InsertEnter   * set number | set norelativenumber
augroup END

" 缩进设置
set expandtab       " 用space来替换tab
set tabstop=4       " tab显示为4格的宽度
set shiftwidth=4    " 缩进宽度设置为4个space

" 支持鼠标，a：表示所有模式，i：insert模式，v：visual模式
set mouse=a

" 在insert模式下按jf可以立即回到normal模式
" `^：回到上一次insert的位置
inoremap jf <ESC>`^

