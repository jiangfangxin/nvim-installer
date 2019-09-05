" ---------- debug-log.vim ----------
" " php调试log
" augroup jiang_php_debug_log
"     autocmd!
"     " 在行末添加log标识，用于调试
"     autocmd FileType php nnoremap <silent> <leader>lj A /* --jfx */<ESC>F'b
"     " 新增函数log
"     autocmd FileType php nnoremap <silent> <leader>lf oerror_log('-> '); /* --jfx */<ESC>F'P
"     autocmd FileType php nnoremap <silent> <leader>lF oerror_log('-> '); /* --jfx */<ESC>F'
"     " 新增变量log
"     autocmd FileType php nnoremap <silent> <leader>lv oerror_log(': ' . print_r()); /* --jfx */<ESC>F:Pf)P
"     autocmd FileType php nnoremap <silent> <leader>lV oerror_log(': ' . print_r()); /* --jfx */<ESC>F:
"     " 注释掉所有log
"     autocmd FileType php nnoremap <silent> <leader>lc :<C-u>%s/^\( *\)\(\/\/ \)\?\(.*--jfx.*\)$/\1\/\/ \3/<CR>
"     " 启用所有注释的log
"     autocmd FileType php nnoremap <silent> <leader>ll :<C-u>%s/^\( *\)\/\/ \(.*--jfx.*\)$/\1\2/<CR>
" augroup END

" Laravel调试log
augroup jiang_laravel_debug_log
    autocmd!
    " 在行末添加log标识，用于调试
    autocmd FileType php nnoremap <silent> <leader>lj A /* --jfx */<ESC>F'b
    " 新增函数log
    autocmd FileType php nnoremap <silent> <leader>lf ologger('-> '.''); /* --jfx */<ESC>F'P
    autocmd FileType php nnoremap <silent> <leader>lF ologger('-> '.''); /* --jfx */<ESC>F'
    " 新增变量log
    autocmd FileType php nnoremap <silent> <leader>lv ologger('~$', ['' => ]); /* --jfx */<ESC>F'Pf]P
    autocmd FileType php nnoremap <silent> <leader>lV ologger('~$', ['' => ]); /* --jfx */<ESC>F'
    " 注释掉所有log
    autocmd FileType php nnoremap <silent> <leader>lc :<C-u>%s/^\( *\)\(\/\/ \)\?\(.*--jfx.*\)$/\1\/\/ \3/<CR>
    " 启用所有注释的log
    autocmd FileType php nnoremap <silent> <leader>ll :<C-u>%s/^\( *\)\/\/ \(.*--jfx.*\)$/\1\2/<CR>
    " 新增sql log
    " 需要在vendor/laravel/framework/src/Illuminate/Database/Connection.php:330中添加代码
    " if (isset($_GET['logSql']) && $_GET['logSql'] == 1) { /* --jfx */
    "     logger('~$', ['sql-dump' => $query]); /* --jfx */
    "     logger('~$', ['bindings' => $bindings]); /* --jfx */
    " } /* --jfx */
    autocmd FileType php nnoremap <silent> <leader>ls o$_GET['logSql'] = 1; /* --jfx */<ESC>F1
augroup END

" vim调试log
augroup jiang_vim_debug_log 
    autocmd!
    " 在行末添加log标识，用于调试
    autocmd FileType vim nnoremap <silent> <leader>lj A " ' --jfx '<ESC>F'b
    " 新增函数log
    autocmd FileType vim nnoremap <silent> <leader>lf oechom '-> ' . ' --jfx '<ESC>F'F'P
    autocmd FileType vim nnoremap <silent> <leader>lF oechom '-> ' . ' --jfx '<ESC>F'F'
    " 新增变量log
    autocmd FileType vim nnoremap <silent> <leader>lv oechom ': ' . string() . ' --jfx '<ESC>F:Pf)P
    autocmd FileType vim nnoremap <silent> <leader>lV oechom ': ' . string() . ' --jfx '<ESC>F:
    " 注释掉所有log
    autocmd FileType vim nnoremap <silent> <leader>lc :<C-u>%s/^\( *\)\(\" \)\?\(.*--jfx.*\)$/\1" \3/<CR>
    " 启用所有注释的log
    autocmd FileType vim nnoremap <silent> <leader>ll :<C-u>%s/^\( *\)" \(.*--jfx.*\)$/\1\2/<CR>
augroup END

" 清除所有的log
nnoremap <silent> <leader>ld :<C-u>%s/^.*--jfx.*$\n//<CR>

