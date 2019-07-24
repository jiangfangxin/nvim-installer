" ---------- plugin-dependent.vim ----------
" 设置Vim插件安装位置
let g:jiang_plugin_dir = '~/.local/share/nvim/plugged'

" 获得系统类别
function Jiang_GetSystemType()
    let uname = system('uname')
    if uname =~ 'Darwin'
        return 'macOS'
    elseif uname =~ 'Ubuntu'
        return 'Ubuntu'
    else
        throw 'ERROR: This init.vim config need your system is macOS or Ubuntu.'
    endif
endf

" 安装fzf的函数
function Jiang_InstallFzf(info)
    " info是vim-plug传来的字典变量，有以下三个参数
    " - name  ：插件的名字
    " - status：插件的状态，'installed'，'updated'，'unchanged'
    " - force ：强制安装或更新，PlugInstall! 或 PlugUpdate!
    if a:info.status == 'installed' || a:info.force
        !./install --all
        let os = Jiang_GetSystemType()
        if os == 'macOS'
            " Mac中Bash的配置存储在~/.bash_profile中，而fzf的install脚本把配置写入了~/.bashrc中，因此我们要把内容移过来
            echom system('grep fzf ~/.bash_profile')
            if v:shell_error != 0
                !echo "\# 设置fzf命令行模糊搜索工具" >> ~/.bash_profile
                !cat ~/.bashrc >> ~/.bash_profile
                !echo "export FZF_DEFAULT_OPTS=\"--height 40\%
                                               \ --layout=reverse
                                               \ --preview '[ -f {} ] && head -n 20 {} || [ -d {} ] && file {} || echo {}'\""
                                               \ >> ~/.bash_profile
            endif
            !rm ~/.bashrc
        endif
    endif
endf

" 安装fzf.vim所需的依赖
function Jiang_InstallFzfVim(info)
    let os = Jiang_GetSystemType()
    " 安装Ag搜索依赖sliver_searcher
    if (os == 'macOS')
        !brew install the_silver_searcher
    elseif (os == 'Ubuntu')
        !sudo apt install silversearcher-ag
    endif
    " 修改Ag中全选按钮为mac-keyboard 上的alt + a（å）, 取消全选的按钮为Ctrl + d（∂）
    if (os == 'macOS')
        execute "!sed -i '' 's/alt-a/å/g' " . g:jiang_plugin_dir . "/fzf.vim/autoload/fzf/vim.vim"
        execute "!sed -i '' 's/alt-d/∂/g' " . g:jiang_plugin_dir . "/fzf.vim/autoload/fzf/vim.vim"
    elseif (os == 'Ubuntu')
        execute "!sed -i 's/alt-a/å/g' " . g:jiang_plugin_dir . "/fzf.vim/autoload/fzf/vim.vim"
        execute "!sed -i 's/alt-d/∂/g' " . g:jiang_plugin_dir . "/fzf.vim/autoload/fzf/vim.vim"
    endif
    " :Lines，:BLines，:BCommits 等命令的的layout应该是和:Files等保持一直
    if (os == 'macOS')
        execute "!sed -i '' 's/--layout=reverse-list/--layout=reverse/g' " . g:jiang_plugin_dir . "/fzf.vim/autoload/fzf/vim.vim"
    elseif (os == 'Ubuntu')
        execute "!sed -i 's/--layout=reverse-list/--layout=reverse/g' " . g:jiang_plugin_dir . "/fzf.vim/autoload/fzf/vim.vim"
    endif
endf

" 安装ctags这个工具
function Jiang_InstallCtags(info)
    let os = Jiang_GetSystemType()
    if (os == 'macOS')
        !brew tap universal-ctags/universal-ctags
        !brew install --HEAD universal-ctags
    elseif (os == 'Ubuntu')
        let path = getcwd()
        !cd /tmp
        !git clone https://github.com/universal-ctags/ctags
        !cd ctags
        !./autogen.sh
        !./configure " 默认是安装到/usr/local
        !make
        !make install " 安装的时候可能还需要其他权限，未测试
        execute '!cd ' . path
    endif
endf

" 安装deoplete的依赖
function Jiang_InstallDeoplete(info)
    let os = Jiang_GetSystemType()
    if (os == 'macOS')
        !brew install python3
    elseif (os == 'Ubuntu')
        !sudo apt install python3
    endif
    !pip3 install pynvim
    execute 'UpdateRemotePlugins'
endf

" 安装phpactor的依赖
function Jiang_InstallPhpactor(info)
    let os = Jiang_GetSystemType()
    if (os == 'macOS')
        !brew install composer
    elseif (os == 'Ubuntu')
        !sudo apt install composer
    endif
    !composer install
endf

