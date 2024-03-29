" ---------- keyboard.mac.vim ----------
" <C-w>H：移动当前窗口至左侧        <C-w>L：移动当前窗口至右侧
" <C-w>J：移动当前窗口至下方        <C-w>K：移动当前窗口至上方
" <C-w>_：水平方向最大化当前窗口    <C-w>|：垂直方向最大化当前窗口
" <C-w>T：在tab中打开当前文件

" 针对Mac电脑键盘的绑定
" Mac键盘下，Alt + <letter>会输出一个拉丁符号
" 利用这个特点来绑定tab的切换和移动快捷键
" Alt + ]：切换下一个tab 
nnoremap ‘ gt
inoremap ‘ <ESC>gt
vnoremap ‘ <ESC>gt
" Alt + [：切换上一个tab 
nnoremap “ gT
inoremap “ <ESC>gT
vnoremap “ <ESC>gT
" Alt + 1：切换至第1个tab
nnoremap ¡ 1gt
inoremap ¡ <ESC>1gt
vnoremap ¡ <ESC>1gt
" Alt + 2：切换至第2个tab
nnoremap ™ 2gt
inoremap ™ <ESC>2gt
vnoremap ™ <ESC>2gt
" Alt + 3：切换至第3个tab
nnoremap £ 3gt
inoremap £ <ESC>3gt
vnoremap £ <ESC>3gt
" Alt + 4：切换至第4个tab
nnoremap ¢ 4gt
inoremap ¢ <ESC>4gt
vnoremap ¢ <ESC>4gt
" Alt + 5：切换至第5个tab
nnoremap ∞ 5gt
inoremap ∞ <ESC>5gt
vnoremap ∞ <ESC>5gt
" Alt + 6：切换至第6个tab
nnoremap § 6gt
inoremap § <ESC>6gt
vnoremap § <ESC>6gt
" Alt + 7：切换至第7个tab
nnoremap ¶ 7gt
inoremap ¶ <ESC>7gt
vnoremap ¶ <ESC>7gt
" Alt + 8：切换至第8个tab
nnoremap • 8gt
inoremap • <ESC>8gt
vnoremap • <ESC>8gt
" Alt + 9：切换至最后一个tab
nnoremap <silent> ª :tablast<CR>
inoremap <silent> ª <ESC>:tablast<CR>
vnoremap <silent> ª <ESC>:tablast<CR>

" Alt + p：关闭预览窗口
nnoremap <silent> π :pclose<CR>
inoremap <silent> π <ESC>:pclose<CR>a
vnoremap <silent> π <ESC>:pclose<CR>gv
" Alt + w：关闭当前窗口
nnoremap <silent> ∑ :q<CR>
inoremap <silent> ∑ <ESC>:q<CR>
vnoremap <silent> ∑ <ESC>:q<CR>
" Alt + o（字母o）：关闭其他窗口
nnoremap <silent> ø :only<CR>
inoremap <silent> ø <ESC>:only<CR>a
vnoremap <silent> ø <ESC>:only<CR>gv
" Alt + x：关闭当前tab
nnoremap <silent> ≈ :tabclose<CR>
inoremap <silent> ≈ <ESC>:tabclose<CR>
vnoremap <silent> ≈ <ESC>:tabclose<CR>
" Alt + Shift + o（字母o）：关闭其他tab
nnoremap <silent> Ø :tabonly<CR>
inoremap <silent> Ø <ESC>:tabonly<CR>a
vnoremap <silent> Ø <ESC>:tabonly<CR>gv
" Alt + q：关闭所有窗口并退出
nnoremap <silent> œ :qa<CR>
inoremap <silent> œ <ESC>:qa<CR>
vnoremap <silent> œ <ESC>:qa<CR>
" Alt + Shift + q：mksession!，然后关闭所有窗口并退出
nnoremap <silent> Œ :mksession!<CR>:qa<CR>
inoremap <silent> Œ <ESC>:mksession!<CR>:qa<CR>
vnoremap <silent> Œ <ESC>:mksession!<CR>:qa<CR>
" :mksession[!] [file] 保存当前工作状态（包括所有tab、window和光标位置等）到指定文件
" 若不提供file默认保存在当前目录下的Session.vim文件，如果已存在需要加!覆盖。
" :source [file] 重新打开之前保存的编辑状态。
" nvim -S Session.vim 也可以在启动nvim的时候指定Session.vim文件。

" Alt + >：当前tab往前移动一位
nnoremap <silent> ≥ :+tabmove<CR>
inoremap <silent> ≥ <ESC>:+tabmove<CR>
vnoremap <silent> ≥ <ESC>:+tabmove<CR>
" Alt + <：当前tab往后移动一位
nnoremap <silent> ≤ :-tabmove<CR>
inoremap <silent> ≤ <ESC>:-tabmove<CR>
vnoremap <silent> ≤ <ESC>:-tabmove<CR>

" Alt + '：去到下一次编辑的地方
nnoremap æ g,
inoremap æ <ESC>g,
vnoremap æ <ESC>g,
" Alt + ;：回到上一次编辑的地方 
nnoremap … g;
inoremap … <ESC>g;
vnoremap … <ESC>g;

" Alt + =：横向增大窗口
nnoremap ≠ 5<C-w>>
inoremap ≠ <ESC>5<C-w>>a
vnoremap ≠ <ESC>5<C-w>>gv
" Alt + -：横向缩小窗口
nnoremap – 5<C-w><
inoremap – <ESC>5<C-w><a
vnoremap – <ESC>5<C-w><gv
" Alt + Shift + =：纵向增大窗口
nnoremap ± 2<C-w>+
inoremap ± <ESC>2<C-w>+a
vnoremap ± <ESC>2<C-w>+gv
" Alt + Shift + -：纵向缩小窗口
nnoremap — 2<C-w>-
inoremap — <ESC>2<C-w>-a
vnoremap — <ESC>2<C-w>-gv
" Alt + 0：平分所有窗口
nnoremap º <C-w>=
inoremap º <ESC><C-w>=a
vnoremap º <ESC><C-w>=gv

" Alt + j：光标移动到下边窗口
nnoremap ∆ <C-w>j
inoremap ∆ <ESC><C-w>j
vnoremap ∆ <ESC><C-w>j
" Alt + k：光标移动到上边窗口
nnoremap ˚ <C-w>k
inoremap ˚ <ESC><C-w>k
vnoremap ˚ <ESC><C-w>k
" Alt + l：光标移动到右边窗口
nnoremap ¬ <C-w>l
inoremap ¬ <ESC><C-w>l
vnoremap ¬ <ESC><C-w>l
" Alt + h：光标移动到左边窗口
nnoremap ˙ <C-w>h
inoremap ˙ <ESC><C-w>h
vnoremap ˙ <ESC><C-w>h

