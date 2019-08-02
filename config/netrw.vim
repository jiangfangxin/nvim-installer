" ---------- netrw.vim ----------
" 设置Vim自带的文件浏览器Netrw
" - ：切换到上级目录         gn：切换到光标所在目录
" u ：切换到最近查看的目录   i ：切换查看模式树状、横向等
" % ：光标所在目录创建文件   d ：创建文件夹
" D ：删除文件或目录         R ：重命名文件或目录
" p ：预览文件               t ：新tab中打开文件
" v ：竖向打开文件           o ：横向打开文件
" x ：用系统软件打开文件     X ：用system执行当前文件
" qf：显示文件或目录信息
" Ctrl + w + z：关闭预览窗口
" mt -> mf -> mc（必须在源目录执行）：标记目标 -> 标记源 -> 复制文件或目录
" mt -> mf -> mm（必须在源目录执行）：标记目标 -> 标记源 -> 移动文件或目录
" mf -> md（必须在源目录执行）      ：Diff文件更改
" mF：取消标记
let g:netrw_liststyle = 3 " Netrw默认展示文件目录结构
let g:netrw_keepdir = 0   " 让Netrw的current directory和我们正在浏览的目录一致，否则每次执行mc，mm，md等之前都要先c一下
let g:netrw_preview = 1   " 在纵向窗口中打开预览
let g:netrw_alto = 0      " 在最右侧打开预览窗口
let g:netrw_winsize=30    " 打开预览窗口后netrw窗口缩小到30%

" 自定义markfile的高亮
highlight clear netrwMarkFile
hi link netrwMarkFile MatchParen

" mf -> mo：在多个tab中打开使用mf标记的mark files
autocmd Filetype netrw nnoremap <buffer> mo :<C-r>=Jiang_OpenMarkFiles()<CR><CR>
function Jiang_OpenMarkFiles()
    let markList = netrw#Expose("netrwmarkfilelist")
    let str = ""
    let i = 0
    let len = len(markList)
    while i < len 
      let f = escape(fnameescape(markList[i]), '.')
      if str == ""
          let str = "e " . f
      else
          let str = str . " | tabe " . f
      endif
      let i = i + 1
    endwhile
    return str
endf

