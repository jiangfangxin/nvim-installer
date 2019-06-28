" ---------- plugin.vim ----------
" Vim-plug：[junegunn/vim-plug](https://github.com/junegunn/vim-plug)
" 默认放置到~/.local/share/nvim/site/autoload/plug.vim
" Vim-plug安装的插件会放到~/.local/share/nvim/plugged/下
" 插件状态:PlugStatus
" 安装插件:PlugInstall
" 删除插件:PlugClean
call plug#begin('~/.local/share/nvim/plugged')
Plug 'terryma/vim-multiple-cursors'                                 " 像Sublime那样的多光标插件
Plug 'rking/ag.vim'                                                 " 文件夹内快速搜索字符，需要系统安装命令行brew/apt install the_silver_searcher
Plug 'StanAngeloff/php.vim', {'for': 'php'}                         " PHP语法支持插件
Plug 'pangloss/vim-javascript'                                      " Javascript语法支持插件
Plug 'Shougo/deoplete.nvim', {'do':':UpdateRemotePlugins'}          " 代码自动补全框架
Plug 'phpactor/phpactor', {'for': 'php', 'do': 'composer install'}  " PHP代码补全
Plug 'kristijanhusak/deoplete-phpactor', {'for': 'php'}             " 连接代码补全框架和PHP库
call plug#end()

" 插件terryma/vim-multiple-cursors自定义设置
" 设置Ctrl + k用于全选匹配
let g:multi_cursor_select_all_word_key = '<C-k>'
" 退出visual模式时不退出多光标模式
let g:multi_cursor_exit_from_visual_mode = 0
" 退出insert模式时不退出多光标模式
let g:multi_cursor_exit_from_insert_mode = 0
" 在使用多光标模式的时候自动禁用我的Jiang_SmartEnter映射，有冲突
function! Multiple_cursors_before()
    iunmap ( | )
    iunmap [ | ]
    iunmap { | }
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

