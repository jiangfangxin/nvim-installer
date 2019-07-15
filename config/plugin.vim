" ---------- plugin.vim ----------
" Vim-plug：[junegunn/vim-plug](https://github.com/junegunn/vim-plug)
" 默认放置到~/.local/share/nvim/site/autoload/plug.vim
" Vim-plug安装的插件会放到~/.local/share/nvim/plugged/下
" 插件状态:PlugStatus
" 安装插件:PlugInstall
" 删除插件:PlugClean
call plug#begin('~/.local/share/nvim/plugged')
Plug 'terryma/vim-multiple-cursors'                                 " 像Sublime那样的多光标插件
Plug 'kien/ctrlp.vim'                                               " 模糊搜索文件名来打开文件
Plug 'brooth/far.vim'                                               " 多文件搜索和替换工具
Plug 'majutsushi/tagbar'                                            " 显示对象和函数大纲
Plug 'scrooloose/nerdcommenter'                                     " 快速注释代码
Plug 'tpope/vim-surround'                                           " 成对修改''()[]{}<>等字符
Plug 'easymotion/vim-easymotion'                                    " 文档内精确快速移动光标
Plug 'StanAngeloff/php.vim', {'for': 'php'}                         " PHP语法支持插件
Plug 'pangloss/vim-javascript'                                      " Javascript语法支持插件
Plug 'Shougo/deoplete.nvim', {'do':':UpdateRemotePlugins'}          " 代码自动补全框架
Plug 'phpactor/phpactor', {'for': 'php', 'do': 'composer install'}  " PHP代码补全
Plug 'kristijanhusak/deoplete-phpactor', {'for': 'php'}             " 连接代码补全框架和PHP库
call plug#end()

" 插件terryma/vim-multiple-cursors自定义设置
" Ctrl + n：选择下一个      Ctrl + p：回到上一个选择
" Ctrl + x：跳过这个选择    Ctrl + k：选择全部匹配
" :MultipleCursorsFind [your-search-string][\c|\C]  选择命令
let g:multi_cursor_select_all_word_key = '<C-k>'
" 退出visual模式时不退出多光标模式
let g:multi_cursor_exit_from_visual_mode = 0
" 退出insert模式时不退出多光标模式
let g:multi_cursor_exit_from_insert_mode = 0
" 在使用多光标模式的时候自动禁用我的Jiang_系列映射以及一些有冲突插件
function! Multiple_cursors_before()
    iunmap (
    iunmap [
    iunmap {
    iunmap )
    iunmap ]
    iunmap }
    iunmap <CR>
    call deoplete#custom#buffer_option('auto_complete', v:false)
endfunction
function! Multiple_cursors_after()
    inoremap ( ()<ESC>i
    inoremap [ []<ESC>i
    inoremap { {}<ESC>i
    inoremap ) <C-r>=Jiang_ClosePair(')')<CR>
    inoremap ] <C-r>=Jiang_ClosePair(']')<CR>
    inoremap } <C-r>=Jiang_ClosePair('}')<CR>
    inoremap <CR> <C-r>=Jiang_SmartEnter()<CR>
    call deoplete#custom#buffer_option('auto_complete', v:true)
endfunction

" 插件kien/ctrlp.vim自定义设置
" Ctrl + p：打开文件摸索搜索        <F5>    ：清除文件缓存更新索引        
" Ctrl + d：切换文件名或路径搜索    Ctrl + r：开启或关闭正则搜索
" Ctrl + j：下一个                  Ctrl + k：下一个
" <Enter> ：在本窗口中打开文件      Ctrl + t：在新标签页中打开
" Ctrl + v：在纵向窗口中打开        Ctrl + s：在水平窗口中打开
" Ctrl + n：下一条搜索              Ctrl + p：上一条搜索
" Ctrl + z：标记/取消标记文件
let g:ctrlp_working_path_mode = ''  " 空字符串表示在nvim的工作目录里搜索

" 插件brooth/far.vim自定义设置
" :F     {pattern} {file-mask} {params}                 多文件搜索
" :Far   {pattern} {replace-with} {file-mask} {params}  预览多文件替换
" :Fardo {params}                                       执行替换
" :Refar {params}                                       刷新一下替换预览
" 下面两个快捷键可以在搜索结果窗口滚动预览窗口而无需移动光标
" Ctrl + j：向下滚动预览窗口    Ctrl + k：向上滚动预览窗口
" I ：包含所有替换              X ：排除所有替换
" t ：包含/排除光标所在行的替换 p ：打开预览窗口
" zo：展开文件搜索条目          zc：折叠文件搜索条目    za：展开/折叠文件搜索条目
" zr：展开所有搜索条目          zm：折叠所有文件搜索条目
 
" 插件majutsushi/tagbar自定义设置
" 需要安装：brew/apt install universal ctags
" <F8>：打开/关闭结构树
" <CR>：跳转到定义的地方            p ：预览定义的地方
" v   ：隐藏非public的变量和方法    s ：排序结构树
" zo  ：展开目录树                  zc：折叠目录树      za：展开/折叠目录树
" zr  ：展开所有目录树              zm：折叠所有目录树
" Ctrl + n：跳转到上一个节点        Ctrl + p：跳转到下一个节点

" 插件crooloose/nerdcommenter自定义设置
let g:NERDSpaceDelims = 1       " 注释后添加空格
let g:NERDDefaultAlign = 'left' " 所有注释左对齐
let g:NERDCommentEmptyLines = 1 " 空白行也添加注释
" [count]<leader>cc         ：comment-comment 添加行注释
" [count]<leader>cu         ：comment-undo    取消行注释
" [count]<leader>c<Space>   ：comment-toggle  切换行注释
" <leader>cA                ：comment-add     在行尾添加注释

" 插件tpope/vim-surround自定义设置
" cs'[          ：将   'Hello world!'     变为： [ Hello world! ]
" cs']          ：将   'Hello world!'     变为：  [Hello world!]
" cst'          ：将 <p>Hello world!</p>  变为：  'Hello world!'
" ds'           ：将   'Hello world!'     变为：   Hello world!
" ysiw{         ：将    Hello world!      变为： { Hello } world!
" yss{          ：将    Hello world!      变为： { Hello world! }
" visual模式S<p>：将    Hello world!      变为：<p>Hello world!</p>

" 插件easymotion/vim-easymotion自定义设置
let g:EasyMotion_do_mapping = 0 " 禁用默认的快捷键
let g:EasyMotion_smartcase = 1  " 忽略大小写
" 通过s键来启动快速跳转，按下s之后通过一个字符来定位想要跳转的位置
nmap s <Plug>(easymotion-overwin-f)

" 插件StanAngeloff/php.vim自定义设置
" 修复类和方法在molokai主题上的显色错误
hi link phpRegion Function
" 修复注释中phpDocTag的颜色错误
hi link phpDocTags Tag

" 插件Shougo/deoplete.nvim自定义设置
" 启动neovim的时候就启动补全插件
let g:deoplete#enable_at_startup = 1
" 延迟200毫秒弹出补全菜单，开启智能大小写
call deoplete#custom#option({
            \ 'auto_complete_delay': 200,
            \ 'smart_case': v:true
            \})
" Omni提示会阻塞deoplete，所以慎用！
" PHP的Omni提示例子，[Vim正则表达式参考](http://vimregex.com/)
" call deoplete#custom#option('omni_patterns', {'php': '\w\+'})
" 修复Omni删除最后一个字母时还显示提示的Bug
" inoremap <expr> <BS> deoplete#smart_close_popup()."\<BS>"
" inoremap <expr> <C-h> deoplete#smart_close_popup()."\<BS>"

