let g:did_load_filetypes = 1 " skip loading default filetypes

" https://learnvimscriptthehardway.stevelosh.com/chapters/42.html
" https://github.com/22mahmoud/neovim
" https://github.com/nanotee/nvim-lua-guide/

" configs:
" - https://old.reddit.com/r/neovim/comments/r0a33t/good_neovim_configurations/
" ecovim for reactJS: https://github.com/ecosse3/nvim
" lunarvim and nvchad / gigachad

" https://github.com/phaazon/hop.nvim
" lightspeed.nvim
" renamer.nvim
" ldelossa/calltree.nvim
" neovim-cmp ?
" fine-cmdline.nvim
" telescope
" cokeline.nvim ?
" searchbox.nvim ?
" dressing.nvim
" lazy load packer stuff.
" evaluate packer vs paq vs...?
" mini.nvim ?
function! VimrcLoadPlugins()
    lua require('plugins')
endfunction

function! VimrcLoadPluginSettings()
    " https://github.com/xiyaowong/coc-sumneko-lua/blob/c2f7cd231626df0dab02d42bd3338fc62f6c153f/src/ctx.ts#L52

    " neoformat
    " see also: after/ftplugin/terraform

    " " vista.vim
    " let g:vista#renderer#enable_icon = 1
    " let g:vista_fzf_preview = ['right:40%']
    "
    " let g:vista_echo_cursor_strategy = 'floating_win'
    " nnoremap <silent> <C-t> :Vista finder<CR>

    " " vim-floaterm
    " let g:floaterm_position = 'center'
    " let g:floaterm_winblend = 30
    " let g:floaterm_keymap_toggle = '<F12>'

    " vim-kitty-navigator
    let g:kitty_navigator_no_mappings = 1
    nnoremap <silent> <M-h> :KittyNavigateLeft<cr>
    nnoremap <silent> <M-j> :KittyNavigateDown<cr>
    nnoremap <silent> <M-k> :KittyNavigateUp<cr>
    nnoremap <silent> <M-l> :KittyNavigateRight<cr>

    " targets.vim
    autocmd User targets#mappings#user call targets#mappings#extend({
                \ 'a': {'argument': [{'o': '[({[]', 'c': '[]})]', 's': ','}]}
                \ })

    " bullets.vim
    let g:bullets_enabled_file_types = ['markdown', 'text', 'gitcommit']
    let g:bullets_outline_levels = ['num', 'std-']

    " vim-polyglot
    let g:haskell_enable_quantification = 1
    let g:haskell_enable_pattern_synonyms = 1
    let g:haskell_enable_typeroles = 1
    let g:php_html_load = 1
    let g:vim_jsx_pretty_colorful_config = 1
    let g:vim_jsx_pretty_template_tags = []
    let g:vim_markdown_new_list_item_indent = 0
    let g:vim_markdown_auto_insert_bullets = 0
    let g:vim_markdown_math = 1
    let g:vim_markdown_frontmatter = 1
    let g:vim_markdown_toml_frontmatter = 1
    let g:vim_markdown_json_frontmatter = 1
    let g:vim_markdown_strikethrough = 1
    let g:vim_markdown_folding_disabled = 1

    " vimtex
    " let g:vimtex_syntax_enabled = 0

    " vim-easy-align
    xmap <CR> <Plug>(EasyAlign)

    " vim-exchange
    xmap gx <Plug>(Exchange)

    " vim-auto-save
    let g:auto_save = 1
    let g:auto_save_write_all_buffers = 1
    let g:auto_save_events = ["FocusLost"]

    " sandwich.vim
    let g:sandwich#recipes = deepcopy(g:sandwich#default_recipes)

    " " vim-which-key
    " nnoremap <silent> <leader> :<c-u>WhichKey '<Space>'<CR>
    lua << EOF
    require("which-key").setup {
        plugins = { spelling = { enabled = true, }, },
    }
EOF

    " suda.vim: Write file with sudo
    command! W :w suda://%
endfunction

function! VimrcLoadMappings()
    " General thoughts:
    "   Operator + non-motion is an 'invalid operation' in vim
    "   oprator + second operator is also 'invalid'
    "   With those in mind, there are lots of empty binds in
    "   vim available

    "Insert new lines in normal mode
    nnoremap <silent> go :pu _<CR>:'[-1<CR>
    nnoremap <silent> gO :pu! _<CR>:']+1<CR>

    " Replace cursor under word. Pressing . will move to next match and repeat
    nnoremap c* /\<<C-R>=expand('<cword>')<CR>\>\C<CR>``cgn
    nnoremap c# ?\<<C-R>=expand('<cword>')<CR>\>\C<CR>``cgN

    " Delete cursor under word. Pressing . will move to next match and repeat
    nnoremap d* /\<<C-R>=expand('<cword>')<CR>\>\C<CR>``dgn
    nnoremap d# ?\<<C-R>=expand('<cword>')<CR>\>\C<CR>``dgN

    " Search for current selection when pressing * or # in visual mode
    xnoremap <silent> * :call VisualSearchCurrentSelection('f')<CR>
    xnoremap <silent> # :call VisualSearchCurrentSelection('b')<CR>

    nnoremap <silent> <C-j> :m .+1<CR>==
    nnoremap <silent> <C-k> :m .-2<CR>==
    inoremap <silent> <C-j> <Esc>:m .+1<CR>==gi
    inoremap <silent> <C-k> <Esc>:m .-2<CR>==gi
    xnoremap <silent> <C-j> :m '>+1<CR>gv=gv
    xnoremap <silent> <C-k> :m '<-2<CR>gv=gv

    xnoremap < <gv
    xnoremap > >gv
endfunction

function! VimrcLoadSettings()
    set title
    set pumblend=30
    set winblend=30
    set grepprg=rg\ --vimgrep\ --no-heading\ --smart-case
    set mouse=a " coc.nvim scrolling
    set complete+=k
    set completeopt=menu,menuone,noinsert
    set nrformats=bin,hex,octal,alpha
    set breakindent
    set clipboard=unnamedplus
    set backup
    set undofile
    set lazyredraw
    set virtualedit=block
    set backupdir-=.
    set list
    set listchars=tab:▸\ ,extends:❯,precedes:❮,trail:⌴
    set showbreak=↪\ \ 
    set scrolloff=2
    set sidescrolloff=2
    set number
    set shortmess+=caIA

    set expandtab
    set softtabstop=2
    set shiftwidth=2

    set ignorecase " Required so that smartcase works
    set smartcase
    set noshowmatch
    set nowrap
    set nofoldenable

    " auto reload file on changes
    autocmd FocusGained,BufEnter,CursorHold,CursorHoldI * if mode() != 'c' | checktime | endif

    set synmaxcol=500
    set termguicolors
    " fixcursorhold.nvim
    set updatetime=4001 " don't get overridden by sensible
    let g:cursorhold_updatetime = 100
    set splitright
    set splitbelow
    set nofixendofline
    set pyx=3

    let g:netrw_dirhistmax=0
    let g:netrw_nogx = 1 " disable netrw's gx mapping.
    nmap gx <Plug>(openbrowser-smart-search)

    set diffopt=filler,internal,algorithm:histogram,indent-heuristic,hiddenoff

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
endfunction

function! VimrcLoadFiletypeSettings()
    let g:LargeFile = 1024 * 768 * 1
    augroup LargeFile
        au!
        au BufReadPre * let f=getfsize(expand("<afile>")) | if f > g:LargeFile || f == -2 | call LargeFile() | endif
    augroup END
endfunction

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

let g:mapleader = "\<Space>"
let g:maplocalleader = "\<Space>"
function! Requirements_matched_filename(arg)
    return v:true
endfunction
let g:polyglot_disabled = ['sensible', 'ftdetect']
let g:python_host_skip_check=1 " disable python2
let g:loaded_python_provider=1 " disable python2

call VimrcLoadPlugins()
call VimrcLoadPluginSettings()
call VimrcLoadMappings()
call VimrcLoadSettings()
call VimrcLoadFiletypeSettings()
call VimrcLoadColors()
