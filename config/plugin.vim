" ---------- plugin.vim ----------
" Vim-plug：[junegunn/vim-plug](https://github.com/junegunn/vim-plug)
" 默认放置到~/.local/share/nvim/site/autoload/plug.vim
" 插件状态:PlugStatus           安装插件:PlugInstall
" 更新插件:PlugUpdate {name}    删除插件:PlugClean
" Vim-plug窗口快捷键
" S：显示所有插件的状态     R：重试安装或更新失败的任务
" U：更新选中的插件         L：加载插件
" q：关闭插件窗口

call plug#begin(g:jiang_plugin_dir)
Plug 'tpope/vim-fugitive'                                                                     " 支持在nvim中使用Git
Plug 'airblade/vim-gitgutter', { 'on': 'GitGutterAll' }                                       " 显示Git文件的变化
Plug 'vim-airline/vim-airline'                                                                " 展示更多信息的导航条
Plug 'terryma/vim-multiple-cursors'                                                           " 像Sublime那样的多光标插件
Plug 'junegunn/fzf', { 'on': ['Files', 'Buffers', 'Ag', 'BLines', 'Tags', 'BTags', 'History',
                         \ 'Commits', 'BCommits', 'Commands', 'Maps', 'Helptags', 'Filetypes'],
                         \ 'do': function('Jiang_InstallFzf') }                               " Fzf模糊搜索
Plug 'junegunn/fzf.vim', { 'on': ['Files', 'Buffers', 'Ag', 'BLines', 'Tags', 'BTags', 'History',
                         \ 'Commits', 'BCommits', 'Commands', 'Maps', 'Helptags', 'Filetypes'],
                         \ 'do': function('Jiang_InstallFzfVim') }                            " Fzf功能扩展
Plug 'brooth/far.vim', { 'on': ['F', 'Far', 'Fardo'] }                                        " 多文件搜索和替换工具
Plug 'majutsushi/tagbar', { 'on': 'TagbarToggle' }                                            " 显示对象和函数大纲
Plug 'scrooloose/nerdcommenter'                                                               " 快速注释代码
Plug 'tpope/vim-surround'                                                                     " 成对修改''()[]{}<>等字符
Plug 'easymotion/vim-easymotion', { 'on': '<Plug>(easymotion-overwin-f)' }                    " 文档内精确快速移动光标
Plug 'junegunn/vim-easy-align', { 'on': ['EasyAlign', 'LiveEasyAlign', '<Plug>(EasyAlign)'] } " 片段代码对齐工具
Plug 'mattn/emmet-vim', { 'on': 'EmmetInstall' }                                              " 快速编写HTML和CSS的插件
Plug 'StanAngeloff/php.vim', { 'for': 'php' }                                                 " PHP语法支持插件
Plug 'pangloss/vim-javascript'                                                                " Javascript语法支持插件
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }                                 " 代码自动补全框架
Plug 'phpactor/phpactor', { 'for': 'php', 'do': 'composer install' }                          " PHP代码补全
Plug 'kristijanhusak/deoplete-phpactor', { 'for': 'php' }                                     " 连接代码补全框架和PHP库
call plug#end()

