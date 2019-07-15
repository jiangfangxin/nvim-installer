" ---------- file.vim ----------
set splitright      " 纵向打开文件显示在右侧
set splitbelow      " 横向打开文件显示在下侧

" 在新页面打开光标所在路径的文件，gf默认情况下在本页面打开需要跳转的文件，我们让它在新页面打开
nnoremap gf :vertical wincmd f<CR>

" nvim自带的文件模糊搜索方式
" 例如输入:tabe **/*file<Tab>   弹出选项有：config/plugin.vim  init.vim  install.sh  pluginManager/
" 打开文件
nnoremap <Leader>e :e **/*
" 在纵向窗口打开文件
nnoremap <Leader>v :vs **/*
" 在横向窗口打开文件
nnoremap <Leader>s :sp **/*
" 在新标签页打开文件
nnoremap <Leader>t :tabe **/*

" 在新tab页打开当前文件：Ctrl + w T
" 新建空白的标签页
nnoremap T :tabe<CR>

" %：指代当前buffer，#：指代前一个buffer
" 打开前一个buffer
nnoremap <Leader>b :b #<CR>

