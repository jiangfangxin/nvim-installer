" ---------- file.vim ----------
set splitright      " 纵向打开文件显示在右侧
set splitbelow      " 横向打开文件显示在下侧

" 在输入状态下，使用Ctrl + r组合其他键可以完成自动输入
" Ctrl + r + %          ：输出当前文件完整路径
" Ctrl + r + =          ：输出表达式计算后的结果或者函数调用的结果
" Ctrl + r + "/0~9/+/*等：输出指定寄存器中的内容

" 复制当前文件的相对路径
nnoremap <leader>yf :let @*='<C-r>%'<CR>
" 复制当前文件的绝对路径
nnoremap <leader>yy :let @*='<C-r>=expand("%:p")<CR>'<CR>

" 在新页面打开光标所在路径的文件，gf默认情况下在本页面打开需要跳转的文件，我们让它在新页面打开
nnoremap gf :vertical wincmd f<CR>
" gx：用系统软件打开光标所在路径的文件

" 在纵向窗口中打开tag跳转
nnoremap <C-\> :vs<CR><C-]>

" nvim自带的文件模糊搜索方式
" 例如输入:tabe **/*file<Tab>   弹出选项有：config/plugin.vim  init.vim  install.sh  pluginManager/
" 如果要打开所有匹配的文件可以输入:tabe config/*，然后在COMMAND栏Ctrl + a会自动补上所有匹配的文件打开文件

" 在新tab页打开当前文件：Ctrl + w T
" 新建空白的标签页
nnoremap <leader>t :tabe<CR>

" 回到上一个buffer
nnoremap <silent> <leader>bp :e #<CR>

" 对比两个文件的差异，在当前文件的COMMAND栏输入要diff的文件
" :diffsplit {file-path}
" internal,filler是默认项，我主要添加了vertical让默认的diff为纵向
set diffopt=internal,filler,vertical

