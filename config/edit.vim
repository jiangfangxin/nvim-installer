" ---------- edit.vim ----------
" normal模式下
" H ：把光标移动到视图顶部   L：把光标移动到视图底部    M ：把光标移动到视图中部
" zt：把当前行移动到顶部    zb：把当前行移动到底部      zz：把当前行移动到中部
" Ctrl + O：回到前一次光标所位置    Ctrl + i：去到下一次光标所在位置
"
" insert模式下
" Ctrl + t：增加整行tab缩进     Ctrl + f：将整行回归到最佳缩进
"
" vim的宏：normal模式下轻松实现多行重复操作
" q{0-9a-zA-Z"}        ：开始录制宏并记录到指定寄存器
" q                    ：结束宏录制
" {number}@{0-9a-zA-Z"}：运行行指定次数录制的宏
" 例如：^vf"y;;v;pj：复制前一个""中的内容到后一个""中，记得最后要加一个j到下一行

" vim自带的代码折叠设置
let g:vimsyn_folding = 'af'
let g:markdown_folding = 1
let g:tex_fold_enabled = 1
let g:xml_syntax_folding = 1
let g:javaScript_fold = 1
let g:sh_fold_enabled= 7
let g:ruby_fold = 1
let g:perl_fold = 1
let g:perl_fold_blocks = 1
let g:r_syntax_folding = 1
let g:rust_fold = 1
let g:php_folding = 1 " 启用php文件的syntax折叠
set foldlevelstart=99 " 99表示打开文件时默认不折叠
" zR：展开所有折叠          zM：关闭所有折叠
" zr：折叠等级减一          zm：折叠等级加一
" zo：展开当前折叠          zc：关闭当前折叠
" za：展开或关闭当前折叠    zf：手动创建折叠

" 全选快捷键，在normal和visual模式下按Ctrl + a即可
nnoremap <C-a> ggvG$
vnoremap <C-a> <ESC>ggvG$

" 快速移动光标
" 这两个是Vim自带的：
" Shift + Left：左移一个word        Shift + Right：右移一个word
" Vim自带Shift + Up/Down为翻页，为了避免按错我改为了上下移动一行：
" Shift + Up  ：上移一行            Shift + Down ：下移一行
nnoremap <S-Up> <Up>
inoremap <S-Up> <Up>
vnoremap <S-Up> <Up>
nnoremap <S-Down> <Down>
inoremap <S-Down> <Down>
vnoremap <S-Down> <Down>
" Shift + Right 用e来前进一个单词
" Vim默认Shift + Right是w，但是e会好用些
nnoremap <S-Right> e
inoremap <S-Right> <C-o>e
vnoremap <S-Right> e

" insert模式下：光标行首行尾定位
inoremap <C-a> <Home>
inoremap <C-e> <End>

" Ctrl + d: 向右删除一个word
inoremap <C-d> <C-o>dw

" Ctrl + k：删除到行尾
inoremap <C-k> <C-r>=Jiang_DeleteToEnd()<CR>
function Jiang_DeleteToEnd()
    let line = getline('.')
    let len = strlen(line)
    if len == 0     " 本行没有字符
        return "\<ESC>Ji"
    elseif (col('.') - 1) < len     " 光标没有再最末尾
        return "\<C-o>d$"
    elseif match(line, '\s$') == -1     " 本行最后一个不是空白字符
        return "\<ESC>Ja\<BS>"
    elseif match(getline(line('.') + 1), '^\s*$') != -1     " 下一行如果全是空白字符
        return "\<ESC>Ja"
    else
        return "\<ESC>Ji"
    endif
endf

" 按键映射：英文符号()[]{}<>等自动补全
inoremap ( ()<ESC>i
inoremap [ []<ESC>i
inoremap { {}<ESC>i
inoremap ) <C-r>=Jiang_ClosePair(')')<CR>
inoremap ] <C-r>=Jiang_ClosePair(']')<CR>
inoremap } <C-r>=Jiang_ClosePair('}')<CR>
" 只有在html和vim文件中才开启<>匹配，其他文件中为比较符号
autocmd Syntax html,vim inoremap < <lt>><ESC>i| inoremap > <C-r>=Jiang_ClosePair('>')<CR>
function Jiang_ClosePair(char)
    if getline('.')[col('.') - 1] == a:char     " 当已有)的时候再输入)就只是右移
        return "\<Right>"
    else
        return a:char       " a: 指的是argument，指明变量char是在arguments的域里面
    endif
endf

" 按键映射：编写function时，当光标在{}中间（如{|}）时回车就会把光标定位回参数那里
inoremap <CR> <C-r>=Jiang_SmartEnter()<CR>
function Jiang_SmartEnter()
    if getline('.')[col('.') - 2] == '{' && getline('.')[col('.') - 1] == '}'
        return "\<CR>\<ESC>bhh"
    else
        return "\<CR>"
    endif
endf

" 按键映射：英文符号``''""等自动补全
inoremap ` <C-r>=Jiang_QuoteDelim("`")<CR>
inoremap ' <C-r>=Jiang_QuoteDelim("'")<CR>
inoremap " <C-r>=Jiang_QuoteDelim('"')<CR>
function Jiang_QuoteDelim(char)
    let line = getline('.')
    let col  = col('.')
    if line[col - 2] == a:char && line[col - 1] == a:char       " 当前位置和前一位都有符号，再次输入右移一位
        return "\<Right>"
    elseif line[col - 2] != a:char && line[col - 1] != a:char   " 前面和当前位置都没有符号，连续输入两个符
        return a:char . a:char . "\<ESC>i"
    else                                                        " 之后单个符号的时候，就补一个符号
        return a:char
    endif
endf

" 在行末添加log标识，用于调试
nnoremap <silent> <leader>cj A " ' --jfx'<ESC>F'b
" 新增函数log
nnoremap <silent> <leader>cf oechom '-> ' . ' --jfx'<ESC>F'F'i
" 新增变量log
nnoremap <silent> <leader>cv oechom ': ' . ' --jfx'<ESC>F:i
" 注释掉所有log
nnoremap <silent> <leader>cd :<C-u>%s/^\( *\)\([^ "].*--jfx.*\)$/\1" \2/<CR>
" 启用所有注释的log
nnoremap <silent> <leader>cD :<C-u>%s/^\( *\)" \(.*--jfx.*\)$/\1\2/<CR>
" 清除所有的log
nnoremap <silent> <leader>cJ :<C-u>%s/^.*--jfx.*$\n//<CR>

