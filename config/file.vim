" ---------- file.vim ----------
set splitright      " 纵向打开文件显示在右侧
set splitbelow      " 横向打开文件显示在下侧

" 在新页面打开光标所在路径的文件，gf默认情况下在本页面打开需要跳转的文件，我们让它在新页面打开
nnoremap gf :vertical wincmd f<CR>

" nvim自带的文件模糊搜索方式
" 例如输入:tabe **/*file<Tab>   弹出选项有：config/plugin.vim  init.vim  install.sh  pluginManager/
" 如果要打开所有匹配的文件可以输入:tabe config/*，然后在COMMAND栏Ctrl + a会自动补上所有匹配的文件打开文件
nnoremap <leader>fe :e **/*
" 在纵向窗口打开文件
nnoremap <leader>fv :vs **/*
" 在横向窗口打开文件
nnoremap <leader>fs :sp **/*
" 在新标签页打开文件
nnoremap <leader>ft :tabe **/*

" 在新tab页打开当前文件：Ctrl + w T
" 新建空白的标签页
nnoremap T :tabe<CR>

" %：指代当前buffer，#：指代切换的前一个buffer
" 打开下一个buffer
nnoremap <leader>B :bnext<CR>
" 打开上一个buffer
nnoremap <leader>b :bprevious<CR>

