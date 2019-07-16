" ---------- plugin.vim ----------
" Vim-plug：[junegunn/vim-plug](https://github.com/junegunn/vim-plug)
" 默认放置到~/.local/share/nvim/site/autoload/plug.vim
" Vim-plug安装的插件会放到~/.local/share/nvim/plugged/下
" 插件状态:PlugStatus           安装插件:PlugInstall
" 更新插件:PlugUpdate {name}    删除插件:PlugClean
" Vim-plug窗口快捷键
" S：显示所有插件的状态     R：重试安装或更新失败的任务
" U：更新选中的插件         L：加载插件
" q：关闭插件窗口
call plug#begin('~/.local/share/nvim/plugged')
Plug 'tpope/vim-fugitive'                                                                     " 支持在nvim中使用Git
Plug 'airblade/vim-gitgutter', { 'on': 'GitGutterAll' }                                       " 显示Git文件的变化
Plug 'vim-airline/vim-airline'                                                                " 展示更多信息的导航条
Plug 'terryma/vim-multiple-cursors'                                                           " 像Sublime那样的多光标插件
Plug 'kien/ctrlp.vim'                                                                         " 模糊搜索文件名来打开文件
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

" 插件tpope/vim-fugitive自定义设置
" :G  / :Git   [command]    即：:!git [command]             在vim中调用bash命令git
" :G! / :Git!  [command]    即：:!git [command]             在vim中调用bash命令git，输出结果到一个临时文件中
" :G  / :Git / :Gstatus     即：git status                  显示所有文件状态
" :Glog [ file ]            即：git log [ file ]            显示提交记录
" :Gcommit -m 'msg'         即：git commit -m 'msg'         提交修改
" :Gfetch                   即：git fetch                   获取远端的更新
" :Gpush origin {branch}    即：git push origin {branch}    推送分支到远端
" :Gdiffsplit               即：git diff %                  对比当前文件和HEAD的差异
" :Gblame                   即：git blame %                 blame当前文件
" :Gwrite                   即：git add %                   添加当前文件到stage
" :Gread                    即：git checkout %              检出当前文件到HEAD版本
" :Grebase {branch}         即：git rebase {branch}         基于分支做rebase
" :Gremove                  即：git rm --cached %           从版本管理中移除当前文件
" 通用快捷键
" <CR>：直接打开文件
" o    ：在横向窗口中打开文件   gO   ：在纵向窗口中打开文件
" O    ：在新标签页中打开文件   p    ：在预览窗口中打开文件
" <C-N>：跳转到下一个修改块     <C-P>：跳转到上一个修改块
" COMMAND命令栏快捷键
" Ctr + r Ctr + g：填入当前文件的文件路径
" Status窗口中的快捷键
" s ：git add       Stage文件或块修改           u ：git reset           Unstage文件或块修改
" - ：git add       Toggle stage文件或块修改    X ：git checkout        忽略块修改
" = ：git diff      展开文件修改                dd：git diff            显示文件修改前后对比
" cc：git commit    创建一个commit              ca：git commit --amend  创建一个commit来覆盖上一次提交
" Log窗口中的快捷键
" ri：git rebase -i HEAD~{commit}   从当前commit进入交互式的rebase
" rr：git rebase --continue         继续当前的rebase                rs；git rebase --skip   跳过当前的commit然后继续rebase
" re：git rebase --edit             编辑当前的rebase                ra：git rebase --abort  终止当前的rebase
" Blame窗口的快捷键
" -：进入光标所在的commit然后再blame    q：退出

" 插件airblade/vim-gitgutter自定义设置
set updatetime=1000 " 设置gutter更新时间为1秒，默认是4秒
" 更新所有可视窗口的gutter
nnoremap <Leader>hh :GitGutterAll<CR>
" 折叠当前文件中所有未修改的代码
nnoremap <Leader>hz :GitGutterFold<CR>
" ]c        ：跳转到下一个修改      [c        ：跳转到上一个修改
" <Leader>hs：暂存光标所在的hunk    <Leader>hu：撤销光标所在的hunk 
" <Leader>hp：预览光标所在的hunk

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
" Ctrl + y：在工作目录创建文件      Ctrl + z：标记/取消标记文件
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

" 插件junegunn/vim-easy-align自定义设置
" 在完成motion之后进入交互的align命令模式，例如：gaip
nmap ga <Plug>(EasyAlign)
" 进入交互的align命令模式，例如：vipga
vmap ga <Plug>(EasyAlign)
" COMMAND命令
" :'<,'>EasyAlign {content} 例如：EasyAlign *= 也可以使用正则：EasyAlign */[+-]*=/ 其中输入ea<Tab>即可弹出EasyAlign
" :'<,'>LiveEasyAlign       进入实时预览的align命令模式
" align命令模式输入项
" 输入项最后以分隔符结束，默认的分隔符有：<Space> <Bar> : . , & # " =（包含：= == != += &&= 等）
" {delimiter}   ：对每行的第一个分隔符进行对齐
" 2{delimiter}  ：对每行的第二个分隔符进行对齐
" n{delimiter}  ：对每行的第n个分隔符进行对齐
" -{delimiter}  ：对每行的倒数第一个分隔符进行对齐
" -2{delimiter} ：对每行的倒数第二个分隔符进行对齐
" -n{delimiter} ：对每行的倒数第n个分隔符进行对齐
" *{delimiter}  ：对每行的所有分隔符进行对齐
" **{delimiter} ：对每行的所有分隔符进行对齐，分隔的内容成对的左右对齐，例如：name = Tom    =    age = 25
" align命令模式快捷键
" <Enter> ：切换分隔内容的对齐方式，L R C
" <Right> ：分隔符右对齐
" <Left>  ：分隔符左侧紧贴着分隔内容
" <Down>  ：分隔符右对齐，分隔符右侧紧贴着分隔内容
" Ctrl + p：切换EasyAlign的命令模式和LiveEasyAlign的命令模式
" Ctrl + x：输入自定义正则分隔符
" Ctrl + i：切换第一个分隔内容的缩进方式，keep，deep，shallow，none
" Ctrl + l：输入分隔符左侧的空格数
" Ctrl + r：输入分隔符右侧的空格数
" Ctrl + d：切换分隔符的对齐方式，L R C
" Ctrl + g：切换需要忽略的分隔符组，[]，['String']，['Comment']，['String', 'Comment']
" 高级应用
" Ctrl + v：当要对某一小块代码对齐而不是整行的时候可以块选择再ga对齐
" 使用参考：[vim-easy-align](https://github.com/junegunn/vim-easy-align)

" 插件mattn/emmet-vim自定义设置
" 只在html和css文件中启用Emmet
let g:user_emmet_install_global = 0
autocmd FileType html,css EmmetInstall
" 只在insert和visual模式下启用Emmet
let g:user_emmet_mode = 'iv'
" Ctrl + y + , ：触发Emmet自动生成代码
" Emmet语法参考：[Emmet Tutorial](https://raw.githubusercontent.com/mattn/emmet-vim/master/TUTORIAL)

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

