function LargeFile()
    setlocal eventignore+=FileType
    setlocal bufhidden=unload
    setlocal undolevels=-1
    autocmd VimEnter *  echo "The file is larger than " . (g:LargeFile / 1024 / 1024) . " MB, so some options are changed (see .vimrc for details)."
endfunction

function VisualSearchCurrentSelection(direction)
    let       l:saved_reg = @"
    execute   'normal! vgvy'
    let       l:pattern = escape(@", '\\/.*$^~[]')
    let       l:pattern = substitute(l:pattern, "\n$", '', '')
    if        a:direction ==# 'b'
        execute 'normal! ?' . l:pattern . "\<cr>"
    elseif    a:direction ==# 'f'
        execute 'normal! /' . l:pattern . '^M'
    endif
    let       @/ = l:pattern
    let       @" = l:saved_reg
endfunction

" vista.vim
function! NearestMethodOrFunction() abort
    return get(b:, 'vista_nearest_method_or_function', '')
endfunction
