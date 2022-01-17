vim.cmd([[
    augroup win_resize
        au!
        au VimResized * wincmd =
    augroup END

    augroup LuaHighlight
        au!
        au TextYankPost * silent! lua require'vim.highlight'.on_yank()
    augroup END
]])
