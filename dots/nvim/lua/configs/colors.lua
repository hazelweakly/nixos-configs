vim.cmd([[
function! DoColors()
    if filereadable(expand("~/.local/share/theme"))
        let l:theme = readfile(expand("~/.local/share/theme"))[0]
        call SetTheme(l:theme)
    else
        call SetTheme("light")
    end
endfunction

function! SetTheme(theme)
    let l:cur = get(g:,'tokyonight_style', 'day')
    let l:cur_theme = get(g:, 'colors_name', 'default')
    let g:tokyonight_style = a:theme == "dark" ? "night" : "day"
    if g:tokyonight_style != l:cur || l:cur_theme != "tokyonight"
        execute 'set background=' . a:theme
        colorscheme tokyonight
    endif
endfunction

function! VimrcLoadColors()
    let g:tokyonight_italic_functions = 1
    call DoColors()
    hi! Comment gui=italic
    hi MatchParen guibg=none gui=italic
    hi SignColumn guibg=none
    hi LineNr guibg=none
    hi DiffChange guibg=none
    hi DiffText guibg=none
endfunction

call VimrcLoadColors()
]])
