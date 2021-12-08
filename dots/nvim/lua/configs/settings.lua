vim.cmd([[
    " auto reload file on changes
    autocmd FocusGained,BufEnter,CursorHold,CursorHoldI * if mode() != 'c' | checktime | endif

    nmap gx <Plug>(openbrowser-smart-search)

    augroup vimrc_settings
        au!
        au BufWritePost $MYVIMRC nested source $MYVIMRC
        au VimEnter * set title
    augroup END

    augroup win_resize
        au!
        au VimResized * wincmd =
    augroup END


    func! NvimGps() abort
        return luaeval("require'nvim-gps'.is_available()") ?
                    \ luaeval("require'nvim-gps'.get_location()") :
                    \ !empty(get(b:,'coc_current_function','')) ? b:coc_current_function :
                    \ !empty(nvim_treesitter#statusline()) ? nvim_treesitter#statusline() : ""
    endf
    " set statusline=%f\ %h%w%m%r%=%{NvimGps()}%-8.(%)\ %-14.{ObsessionStatus('Session\ Active','Session\ Paused','Session\ N/A')}\ %-10.(%l,%c%V%)\ %P
    set statusline=%f\ %h%w%m%r%=%{NvimGps()}%-8.(%)\ %-10.(%l,%c%V%)\ %P

    augroup LuaHighlight
        au!
        au TextYankPost * silent! lua require'vim.highlight'.on_yank()
    augroup END
]])
