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
    execute "!sed -i" . (os == 'macOS' ? " ''" : "") . " -e 's/alt-a/å/g' " . g:jiang_plugin_dir . "/fzf.vim/autoload/fzf/vim.vim"
    execute "!sed -i" . (os == 'macOS' ? " ''" : "") . " -e 's/alt-d/∂/g' " . g:jiang_plugin_dir . "/fzf.vim/autoload/fzf/vim.vim"
    " :Lines，:BLines，:BCommits 等命令的的layout应该是和:Files等保持一直
    execute "!sed -i" . (os == 'macOS' ? " ''" : "") . " -e 's/--layout=reverse-list/--layout=reverse/g' " . g:jiang_plugin_dir . "/fzf.vim/autoload/fzf/vim.vim"
    " :Ag、:Tags、:BTags、:BLines、:Buffers 命令不用显示preview-window
    execute "!sed -i" . (os == 'macOS' ? " ''" : "") . " -E 's/BLines> .,/& \"--preview-window=hidden\",/g' " . g:jiang_plugin_dir . "/fzf.vim/autoload/fzf/vim.vim"
    execute "!sed -i" . (os == 'macOS' ? " ''" : "") . " -E 's/capname\\..> .,/& \"--preview-window=hidden\",/g' " . g:jiang_plugin_dir . "/fzf.vim/autoload/fzf/vim.vim"
    execute "!sed -i" . (os == 'macOS' ? " ''" : "") . " -E 's/Tags> .,/& \"--preview-window=hidden\",/g' " . g:jiang_plugin_dir . "/fzf.vim/autoload/fzf/vim.vim"
    execute "!sed -i" . (os == 'macOS' ? " ''" : "") . " -E 's/Buf> .,/& \"--preview-window=hidden\",/g' " . g:jiang_plugin_dir . "/fzf.vim/autoload/fzf/vim.vim"
    execute "!sed -i" . (os == 'macOS' ? " ''" : "") . " -E 's/Hist[:\\/]> ./& --preview-window=hidden/g' " . g:jiang_plugin_dir . "/fzf.vim/autoload/fzf/vim.vim"
    execute "!sed -i" . (os == 'macOS' ? " ''" : "") . " -E 's/File types> ./& --preview-window=hidden/g' " . g:jiang_plugin_dir . "/fzf.vim/autoload/fzf/vim.vim"
    execute "!sed -i" . (os == 'macOS' ? " ''" : "") . " -E 's/Maps \\(.\\.a:mode\\..\\)> ./& --preview-window=hidden/g' " . g:jiang_plugin_dir . "/fzf.vim/autoload/fzf/vim.vim"
endf

" 修改Far.vim源代码使其搜索目录可以根据vim的pwd变化
" 由于sed给文件添加行的时候需要换行符，vim不支持换行的command，故先把command写入临时文件再执行。
function Jiang_ChangeFar(info)
    let os = Jiang_GetSystemType()
    let file = trim(system('mktemp -t nvim_sed.XXXXXX'))
    let lines = []
    
    " 添加一行let g:far#cwd = getcwd()让Far搜索当前所在目录
    call add(lines, "sed -i" . (os == 'macOS' ? " ''" : "") . " -e '/function.*s:create_far_params() abort/a\\")
    call add(lines, "\\    let g:far#cwd = getcwd()' " . g:jiang_plugin_dir . "/far.vim/autoload/far.vim")
    
    " 把--smart-case移动到--ignore-case之后，避开ag命令行的bug
    call add(lines, "sed -i" . (os == 'macOS' ? " ''" : "") . " -E '/if &smartcase/,/endif/d' " . g:jiang_plugin_dir . "/far.vim/autoload/far.vim")
    call add(lines, "sed -i" . (os == 'macOS' ? " ''" : "") . " -E '/far#tools#setdefault\\(.g:far#sources\\.(ag|ack|rg).,/i\\")
    call add(lines, "\\    if &smartcase\\")
    call add(lines, "\\        call add\\(cmd, \"--smart-case\"\\)\\")
    call add(lines, "\\    endif\\")
    call add(lines, "' " . g:jiang_plugin_dir . "/far.vim/autoload/far.vim")
    call writefile(lines, file)

    " 修复Python的re.compile()的导致的不支持\c和\C的bug
    call add(lines, "sed -i" . (os == 'macOS' ? " ''" : "") . " -E 's/cpat = re\\.compile\\(pattern\\)/ls = re.findall(\"\\\\\\\\\\\\+(?=[cC]$)\", pattern)\\")
    call add(lines, "            if len(ls) > 0 and len(ls[0]) % 2 != 0:\\")
    call add(lines, "                cpat = re.compile(pattern[:-2])\\")
    call add(lines, "            else:\\")
    call add(lines, "                cpat = re.compile(pattern)/' " . g:jiang_plugin_dir . "/far.vim/rplugin/python3/far/sources/shell.py")
    call writefile(lines, file)
    
    " 执行所有命令
    execute "!bash " . file
endf

" 自定义nrdtree快捷键
function Jiang_CustomNerdtree(info)
    let lines = []
    call add(lines, "call NERDTreeAddKeyMap({ 'key': '<CR>', 'callback': 'Jiang_NERDTreeOpenFile', 'quickhelpText': '查看目录或在当前窗口打开文件', 'scope': 'FileNode', 'override': 1 })")
    call add(lines, "call NERDTreeAddKeyMap({ 'key': 'o', 'callback': 'Jiang_NERDTreeOpenFile', 'quickhelpText': '查看目录或在当前窗口打开文件', 'scope': 'FileNode', 'override': 1 })")
    call add(lines, "call NERDTreeAddKeyMap({ 'key': 't', 'callback': 'Jiang_NERDTreeOpenInTab', 'quickhelpText': '在新标签页打开文件或目录', 'scope': 'Node', 'override': 1 })")
    call add(lines, "call NERDTreeAddKeyMap({ 'key': 'v', 'callback': 'Jiang_NERDTreeOpenInVSplit', 'quickhelpText': '在纵向窗口中打开文件或目录', 'scope': 'Node', 'override': 1 })")
    call add(lines, "call NERDTreeAddKeyMap({ 'key': 's', 'callback': 'Jiang_NERDTreeOpenInSplit', 'quickhelpText': '在横向窗口中打开文件或目录', 'scope': 'Node', 'override': 1 })")
    call add(lines, "call NERDTreeAddKeyMap({ 'key': 'p', 'callback': 'Jiang_NERDTreeLivePreview', 'quickhelpText': '展开目录或预览当前文件', 'scope': 'Node', 'override': 1 })")
    call add(lines, "call NERDTreeAddKeyMap({ 'key': '-', 'callback': 'Jiang_JumpToParent', 'quickhelpText': '跳转到父节点', 'scope': 'Node', 'override': 1 })")
    call add(lines, "function Jiang_NERDTreeOpenFile(dirnode)")
    call add(lines, "    execute 'pclose | e ' . a:dirnode.path.str()")
    call add(lines, "endf")
    call add(lines, "function Jiang_NERDTreeOpenInTab(dirnode)")
    call add(lines, "    execute 'pclose | e ' . a:dirnode.path.str() . ' | wincmd T'")
    call add(lines, "endf")
    call add(lines, "function Jiang_NERDTreeOpenInVSplit(dirnode)")
    call add(lines, "    execute 'pclose | vs ' . a:dirnode.path.str()")
    call add(lines, "endf")
    call add(lines, "function Jiang_NERDTreeOpenInSplit(dirnode)")
    call add(lines, "    execute 'pclose | sp ' . a:dirnode.path.str()")
    call add(lines, "endf")
    call add(lines, "function Jiang_NERDTreeGetPreviewWinID()")
    call add(lines, "    for nr in range(1, winnr('$'))")
    call add(lines, "        if getwinvar(nr, '&previewwindow') == 1")
    call add(lines, "            return nr")
    call add(lines, "        endif  ")
    call add(lines, "    endfor")
    call add(lines, "    return 0")
    call add(lines, "endf")
    call add(lines, "function Jiang_NERDTreeGetPreviewPath()")
    call add(lines, "    let nr = Jiang_NERDTreeGetPreviewWinID()")
    call add(lines, "    return nr != 0 ? getwinvar(nr, 'preview_path') : '' ")
    call add(lines, "endf")
    call add(lines, "function Jiang_NERDTreeSetPreviewPath(path)")
    call add(lines, "    let nr = Jiang_NERDTreeGetPreviewWinID()")
    call add(lines, "    if nr != 0")
    call add(lines, "        call setwinvar(nr, 'preview_path', a:path) ")
    call add(lines, "    endif")
    call add(lines, "endf")
    call add(lines, "function Jiang_NERDTreeLivePreview(dirnode)")
    call add(lines, "    if a:dirnode.path.isDirectory != 1")
    call add(lines, "        \" 在同一个文件上再次点击预览的话会关掉预览窗口")
    call add(lines, "        let filePath = a:dirnode.path.str()")
    call add(lines, "        let previewPath = Jiang_NERDTreeGetPreviewPath()")
    call add(lines, "        if filePath == previewPath")
    call add(lines, "            execute 'pclose'")
    call add(lines, "        else")
    call add(lines, "            execute 'pedit +wincmd\\ L ' . filePath")
    call add(lines, "            call Jiang_NERDTreeSetPreviewPath(filePath)")
    call add(lines, "        endif")
    call add(lines, "    endif")
    call add(lines, "endf")
    call add(lines, "function Jiang_JumpToParent(dirnode)")
    call add(lines, "    let l:dirnode = a:dirnode.path.isDirectory ? a:dirnode.getCascadeRoot() : a:dirnode")
    call add(lines, "    if l:dirnode.isRoot()")
    call add(lines, "        return")
    call add(lines, "    endif")
    call add(lines, "    if empty(l:dirnode.parent)")
    call add(lines, "        call nerdtree#echo('没有父节点可以跳转')")
    call add(lines, "        return")
    call add(lines, "    endif")
    call add(lines, "    call l:dirnode.parent.putCursorHere(1, 0)")
    call add(lines, "    call b:NERDTree.ui.centerView()")
    call add(lines, "endf")
    call writefile(lines, expand(g:jiang_plugin_dir . '/nerdtree/nerdtree_plugin/custom_nerdtree.vim'))
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

" 修改php.vim的颜色设置
function Jiang_ChangePhpHighlight(info)
    let os = Jiang_GetSystemType()
    " 修改因为折叠导致的public、protected等颜色被覆盖的bug
    execute "!sed -i" . (os == 'macOS' ? " ''" : "") . " -E 's/(syn region phpFoldFunction matchgroup=Storageclass start=[^)]+\\))([^$]+\\$)(.+z1)}(.+)$/\\1\\\\(\\2\\\\)\\3\\\\(}\\\\)\\\\@=\\4/g' " . g:jiang_plugin_dir . "/php.vim/syntax/php.vim"
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

" 安装代码格式化工具
function Jiang_InstallFormatters(info)
	let os = Jiang_GetSystemType()
    let file = trim(system('mktemp -t nvim_sed.XXXXXX'))
    let lines = []
    " " 安装js-beautify的python版本
    if (os == 'macOS')
        !brew install node
        !npm -g install js-beautify
    elseif (os == 'Ubuntu')
        !sudo apt install nodejs
        !npm -g install js-beautify
    endif
    " 安装php-cs-fixer
    if (os == 'macOS')
        !brew install php-cs-fixer
    elseif (os == 'Ubuntu')
        !curl -L https://cs.symfony.com/download/php-cs-fixer-v2.phar -o php-cs-fixer
        !sudo chmod a+x php-cs-fixer
        !sudo mv php-cs-fixer /usr/local/bin/php-cs-fixer
    endif
    " 修复Neoformat中php-cs-fixer的问题
    call add(lines, "sed -i" . (os == 'macOS' ? " ''" : "") . " -E '/exe.: .php-cs-fixer.,/a\\")
    call add(lines, "\\           \\\\ \"replace\": 1,\\")
    call add(lines, "' " . g:jiang_plugin_dir . "/neoformat/autoload/neoformat/formatters/php.vim")
    call writefile(lines, file)
    " " Run
    execute "!bash " . file
endf

