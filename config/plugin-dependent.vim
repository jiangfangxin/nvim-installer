" ---------- plugin-dependent.vim ----------
" 设置Vim插件安装位置
let g:jiang_plugin_dir = '~/.local/share/nvim/plugged'

" 获得系统类别
function Jiang_GetSystemType()
    let uname = system('uname -a')
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

        " 添加默认设置
        let lines = []
        call add(lines, "export FZF_DEFAULT_OPTS=\"--height 40% \\")
        call add(lines, "                         --layout=reverse \\")
        call add(lines, "                         --preview 'if [ -f {} ]; then \\")
        call add(lines, "                                        bat -nr 1:1000 --color=always {}; \\")
        call add(lines, "                                    elif [ -d {} ]; then \\")
        call add(lines, "                                        file {}; \\")
        call add(lines, "                                    else \\")
        call add(lines, "                                        echo {}; \\")
        call add(lines, "                                    fi'\"")

        let os = Jiang_GetSystemType()
        if os == 'macOS'
            " 安装bat命令行工具
            !brew install bat
            " Mac中Bash的配置存储在~/.bash_profile中，而fzf的install脚本把配置写入了~/.bashrc中，因此我们要把内容移过来
            echom system('grep fzf ~/.bash_profile')
            if v:shell_error != 0
                !echo "\# 设置fzf命令行模糊搜索工具" >> ~/.bash_profile
                !cat ~/.bashrc >> ~/.bash_profile
                call writefile(lines, expand('~/.bash_profile'), 'a')
            endif
            !rm ~/.bashrc
        elseif os == 'Ubuntu'
            " 安装bat命令行工具
            let dir = trim(system('mktemp -d nvim_bat.XXXXXX'))
            execute "!curl https://github.com/sharkdp/bat/releases/download/v0.11.0/bat-musl_0.11.0_amd64.deb -o " . dir . "/bat-musl_0.11.0_amd64.deb"
            execute "!sudo dpkg -i " . dir . "/bat-musl_0.11.0_amd64.deb"
            " 将默认设置写入~/.bashrc中
            echom system('grep FZF_DEFAULT_OPTS ~/.bashrc')
            if v:shell_error != 0
                !echo "\# 设置fzf命令行模糊搜索工具" >> ~/.bashrc
                call writefile(lines, expand('~/.bashrc'), 'a')
            endif
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
        execute "!sed -i '' -e 's/alt-a/å/g' " . g:jiang_plugin_dir . "/fzf.vim/autoload/fzf/vim.vim"
        execute "!sed -i '' -e 's/alt-d/∂/g' " . g:jiang_plugin_dir . "/fzf.vim/autoload/fzf/vim.vim"
    elseif (os == 'Ubuntu')
        execute "!sed -i -e 's/alt-a/å/g' " . g:jiang_plugin_dir . "/fzf.vim/autoload/fzf/vim.vim"
        execute "!sed -i -e 's/alt-d/∂/g' " . g:jiang_plugin_dir . "/fzf.vim/autoload/fzf/vim.vim"
    endif
    " :Lines，:BLines，:BCommits 等命令的的layout应该是和:Files等保持一直
    if (os == 'macOS')
        execute "!sed -i '' -e 's/--layout=reverse-list/--layout=reverse/g' " . g:jiang_plugin_dir . "/fzf.vim/autoload/fzf/vim.vim"
    elseif (os == 'Ubuntu')
        execute "!sed -i -e 's/--layout=reverse-list/--layout=reverse/g' " . g:jiang_plugin_dir . "/fzf.vim/autoload/fzf/vim.vim"
    endif
    " :Ag、:Tags、:BTags、:BLines、:Buffers 命令不用显示preview-window
    if (os == 'macOS')
        execute "!sed -i '' -E 's/BLines> .,/& \"--preview-window=hidden\",/g' " . g:jiang_plugin_dir . "/fzf.vim/autoload/fzf/vim.vim"
        execute "!sed -i '' -E 's/capname\\..> .,/& \"--preview-window=hidden\",/g' " . g:jiang_plugin_dir . "/fzf.vim/autoload/fzf/vim.vim"
        execute "!sed -i '' -E 's/Tags> .,/& \"--preview-window=hidden\",/g' " . g:jiang_plugin_dir . "/fzf.vim/autoload/fzf/vim.vim"
        execute "!sed -i '' -E 's/Buf> .,/& \"--preview-window=hidden\",/g' " . g:jiang_plugin_dir . "/fzf.vim/autoload/fzf/vim.vim"
        execute "!sed -i '' -E 's/Hist[:\\/]> ./& --preview-window=hidden/g' " . g:jiang_plugin_dir . "/fzf.vim/autoload/fzf/vim.vim"
        execute "!sed -i '' -E 's/File types> ./& --preview-window=hidden/g' " . g:jiang_plugin_dir . "/fzf.vim/autoload/fzf/vim.vim"
        execute "!sed -i '' -E 's/Maps \\(.\\.a:mode\\..\\)> ./& --preview-window=hidden/g' " . g:jiang_plugin_dir . "/fzf.vim/autoload/fzf/vim.vim"
    elseif (os == 'Ubuntu')
        execute "!sed -i -E 's/BLines> .,/& \"--preview-window=hidden\",/g' " . g:jiang_plugin_dir . "/fzf.vim/autoload/fzf/vim.vim"
        execute "!sed -i -E 's/capname\\..> .,/& \"--preview-window=hidden\",/g' " . g:jiang_plugin_dir . "/fzf.vim/autoload/fzf/vim.vim"
        execute "!sed -i -E 's/Tags> .,/& \"--preview-window=hidden\",/g' " . g:jiang_plugin_dir . "/fzf.vim/autoload/fzf/vim.vim"
        execute "!sed -i -E 's/Buf> .,/& \"--preview-window=hidden\",/g' " . g:jiang_plugin_dir . "/fzf.vim/autoload/fzf/vim.vim"
        execute "!sed -i -E 's/Hist[:\\/]> ./& --preview-window=hidden/g' " . g:jiang_plugin_dir . "/fzf.vim/autoload/fzf/vim.vim"
        execute "!sed -i -E 's/File types> ./& --preview-window=hidden/g' " . g:jiang_plugin_dir . "/fzf.vim/autoload/fzf/vim.vim"
        execute "!sed -i -E 's/Maps \\(.\\.a:mode\\..\\)> ./& --preview-window=hidden/g' " . g:jiang_plugin_dir . "/fzf.vim/autoload/fzf/vim.vim"
    endif
endf

" 修改Far.vim源代码使其搜索目录可以根据vim的pwd变化
" 由于sed给文件添加行的时候需要换行符，vim不支持换行的command，故先把command写入临时文件再执行。
function Jiang_ChangeFar(info)
    let os = Jiang_GetSystemType()
    let file = trim(system('mktemp -t nvim_sed.XXXXXX'))
    let lines = []
    
    " 添加一行let g:far#cwd = getcwd()让Far搜索当前所在目录
    if (os == 'macOS')
        call add(lines, "sed -i '' -e '/function.*s:create_far_params() abort/a\\")
    elseif (os == 'Ubuntu')
        call add(lines, "sed -i -e '/function.*s:create_far_params() abort/a\\")
    endif
    call add(lines, "\\    let g:far#cwd = getcwd()' " . g:jiang_plugin_dir . "/far.vim/autoload/far.vim")
    
    " 把--smart-case移动到--ignore-case之后，避开ag命令行的bug
    if (os =='macOS')
        call add(lines, "sed -i '' -E '/if &smartcase/,/endif/d' " . g:jiang_plugin_dir . "/far.vim/autoload/far.vim")
        call add(lines, "sed -i '' -E '/far#tools#setdefault\\(.g:far#sources\\.(ag|ack|rg).,/i\\")
    elseif (os == 'Ubuntu')
        call add(lines, "sed -i -E '/if &smartcase/,/endif/d' " . g:jiang_plugin_dir . "/far.vim/autoload/far.vim")
        call add(lines, "sed -i -E '/far#tools#setdefault\\(.g:far#sources\\.(ag|ack|rg).,/i\\")
    endif
    call add(lines, "\\    if &smartcase\\")
    call add(lines, "\\        call add\\(cmd, \"--smart-case\"\\)\\")
    call add(lines, "\\    endif\\")
    call add(lines, "' " . g:jiang_plugin_dir . "/far.vim/autoload/far.vim")
    call writefile(lines, file)

    " 修复Python的re.compile()的导致的不支持\c和\C的bug
    if (os =='macOS')
        call add(lines, "sed -i '' -E 's/cpat = re\\.compile\\(pattern\\)/ls = re.findall(\"\\\\\\\\\\\\+(?=[cC]$)\", pattern)\\")
    elseif (os == 'Ubuntu')
        call add(lines, "sed -i -E 's/cpat = re\\.compile\\(pattern\\)/ls = re.findall(\"\\\\\\\\\\\\+(?=[cC]$)\", pattern)\\")
    endif
    call add(lines, "            if len(ls) > 0 and len(ls[0]) % 2 != 0:\\")
    call add(lines, "                cpat = re.compile(pattern[:-2])\\")
    call add(lines, "            else:\\")
    call add(lines, "                cpat = re.compile(pattern)/' " . g:jiang_plugin_dir . "/far.vim/rplugin/python3/far/sources/shell.py")
    call writefile(lines, file)
    
    " 执行所有命令
    execute "!bash " . file
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

