function! VimrcLoadPlugins()
    " Install vim-plug if not available
    if empty(glob('~/.local/share/nvim/site/autoload/plug.vim'))
        silent !curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
                    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
        autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
    endif

    if !isdirectory($HOME . '/.local/share/nvim/backup')
        call mkdir($HOME . '/.local/share/nvim/swap', "p", 0700)
        call mkdir($HOME . '/.local/share/nvim/undo', "p", 0700)
        call mkdir($HOME . '/.local/share/nvim/backup', "p", 0700)
    endif

    call plug#begin('~/.local/share/nvim/plugged')

    " Linting + LSP
    Plug 'neoclide/coc.nvim', {'do': 'yarn install --frozen-lockfile'}
    Plug 'sbdchd/neoformat'
    Plug 'kizza/actionmenu.nvim'

    Plug 'liuchengxu/vim-which-key', { 'on': ['WhichKey','WhichKey!'] }
    Plug 'lambdalisue/suda.vim'
    Plug 'farmergreg/vim-lastplace'
    " Plug 'cohama/lexima.vim'
    Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all --xdg --no-update-rc' }
    Plug 'junegunn/fzf.vim'
    Plug 'junegunn/vim-easy-align'
    Plug '907th/vim-auto-save'

    " filetype ]] [[
    Plug 'arp242/jumpy.vim'

    Plug 'tomtom/tcomment_vim'
    Plug 'tommcdo/vim-exchange'
    " g>, g<, gs
    Plug 'machakann/vim-swap'
    Plug 'airblade/vim-rooter'

    Plug 'liuchengxu/vista.vim'
    Plug 'rhysd/git-messenger.vim'
    Plug 'dhruvasagar/vim-zoom'
    Plug 'voldikss/vim-floaterm'

    Plug 'machakann/vim-sandwich'
    Plug 'wellle/targets.vim'
    Plug 'romainl/vim-cool'
    Plug 'andymass/vim-matchup'

    Plug 'laggardkernel/vim-one'
    Plug 'https://gitlab.com/protesilaos/tempus-themes-vim.git'

    " Languages
    Plug 'lervag/vimtex'
    Plug 'sheerun/vim-polyglot'
    call plug#end()
endfunction

function! VimrcLoadPluginSettings()
    " vim-cool
    let g:CoolTotalMatches = 1

    " vim-matchup
    let g:matchup_transmute_enabled = 1
    let g:matchup_matchparen_deferred = 1
    let g:matchup_matchparen_status_offscreen = 0
    let g:matchup_delim_stopline = 2500

    " fzf.vim
    " fzf in floating windows
    lua require('navigation')
    let g:fzf_layout = { 'window': 'lua NavigationFloatingWin()' }

    " Customize Rg and Files commands to add preview
    command! -bang -nargs=* Rg
                \ call fzf#vim#grep(
                \   'rg --column --line-number --no-heading --color=always --smart-case '.shellescape(<q-args>), 1,
                \   fzf#vim#with_preview('right:40%', '?'),
                \   <bang>0)

    command! -bang -nargs=? -complete=dir Files
                \ call fzf#vim#files(<q-args>, fzf#vim#with_preview(), <bang>0)

    nnoremap <silent> <leader>f :Files<CR>
    nnoremap <silent> <leader>h :History<CR>
    nnoremap <silent> <leader>b :Buffers<CR>
    nnoremap <silent> <leader><space> :Rg<CR>
    xnoremap <silent> <leader><space> y:Rg <C-R>"<CR>

    " coc.nvim
    nmap <silent> gd <Plug>(coc-definition)
    nmap <silent> gr <Plug>(coc-rename)
    nmap <silent> gR <Plug>(coc-references)
    nmap <silent> K :call CocActionAsync('doHover')<CR>
    nmap <silent> gz <Plug>(coc-refactor)

    nnoremap <silent> ga :call ActionMenuCodeActions()<CR>
    nmap <silent> gA <Plug>(coc-fix-current)
    nmap <silent> <C-n> <Plug>(coc-diagnostic-next)
    nmap <silent> <C-p> <Plug>(coc-diagnostic-prev)

    let g:coc_snippet_next = '<M-n>'
    let g:coc_snippet_prev = '<M-p>'

    let g:coc_global_extensions = [
                \ 'coc-css',
                \ 'coc-diagnostic',
                \ 'coc-docker',
                \ 'coc-eslint',
                \ 'coc-git',
                \ 'coc-highlight',
                \ 'coc-html',
                \ 'coc-json',
                \ 'coc-lit-html',
                \ 'coc-pairs',
                \ 'coc-phpls',
                \ 'coc-prettier',
                \ 'coc-rust-analyzer',
                \ 'coc-sh',
                \ 'coc-styled-components',
                \ 'coc-svg',
                \ 'coc-tslint-plugin',
                \ 'coc-tsserver',
                \ 'coc-vimlsp',
                \ 'coc-vimtex',
                \ 'coc-yaml',
                \ 'coc-emmet'
                \ ]

    if executable('docker-langserver')
        call coc#config('languageserver.docker.enable', v:true)
    endif

    if executable('hie-wrapper')
        call coc#config('languageserver.haskell.enable', v:true)
    endif

    if executable('ghcide')
        call coc#config('languageserver.ghcide.enable', v:true)
    endif

    augroup coc
        au!
        au CompleteDone * if pumvisible() == 0 | pclose | endif
        au User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
        au CursorHold * silent! call CocActionAsync('highlight')
        au User CocQuickfixChange :CocList --normal quickfix
    augroup END

    inoremap <expr> <Tab> pumvisible() ? coc#_select_confirm() : "\<Tab>"
    inoremap <expr> <CR> complete_info()["selected"] != "-1" ? coc#_select_confirm() : "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"
    inoremap <expr> <S-Tab> "\<C-h>"
    inoremap <silent><expr> <c-space> coc#refresh()

    xmap <silent> <TAB> <Plug>(coc-range-select)
    xmap <silent> <S-TAB> <Plug>(coc-range-select-backword)

    nmap <silent> <leader>c :CocCommand<CR>
    nmap <silent> <leader>lo :<C-u>CocList outline<CR>
    nmap <silent> <leader>ls :<C-u>CocList -I symbols<CR>
    nmap <silent> <leader>ld :<C-u>CocList diagnostics<CR>

    nmap gp <Plug>(coc-git-prevchunk)
    nmap gn <Plug>(coc-git-nextchunk)

    " neoformat
    augroup fmt
        autocmd!
        au BufWritePre * try | undojoin | Neoformat | catch /^Vim\%((\a\+)\)\=:E790/ | finally | silent Neoformat | endtry
    augroup END

    " vista.vim
    let g:vista#renderer#enable_icon = 1
    let g:vista_fzf_preview = ['right:40%']
    let g:vista_echo_cursor_strategy = 'floating_win'
    nmap <silent> <C-T> :Vista finder<CR>

    " vim-floaterm
    let g:floaterm_position = 'center'
    let g:floaterm_winblend = '30'
    let g:floaterm_keymap_toggle = '<F12>'

    " actionmenu.vim
    let s:code_actions = []

    func! ActionMenuCodeActions() abort
      let s:code_actions = CocAction('codeActions')
      let l:menu_items = map(copy(s:code_actions), { index, item -> item['title'] })
      call actionmenu#open(l:menu_items, 'ActionMenuCodeActionsCallback')
    endfunc

    func! ActionMenuCodeActionsCallback(index, item) abort
      if a:index >= 0
        let l:selected_code_action = s:code_actions[a:index]
        let l:response = CocAction('doCodeAction', l:selected_code_action)
      endif
    endfunc

    " targets.vim
    autocmd User targets#mappings#user call targets#mappings#extend({
                \ 'a': {'argument': [{'o': '[({[]', 'c': '[]})]', 's': ','}]}
                \ })

    " vim-polyglot
    let g:haskell_enable_quantification = 1
    let g:haskell_enable_pattern_synonyms = 1
    let g:haskell_enable_typeroles = 1
    let g:php_html_load = 1
    let g:vim_jsx_pretty_colorful_config = 1
    let g:vim_jsx_pretty_template_tags = []

    " vim-easy-align
    xmap <CR> <Plug>(EasyAlign)

    " vim-exchange
    xmap gx <Plug>(Exchange)

    " vim-auto-save
    let g:auto_save = 1
    let g:auto_save_events = ["FocusLost"]

    " sandwich.vim
    let g:sandwich#recipes = deepcopy(g:sandwich#default_recipes)

    " vim-which-key
    nnoremap <silent> <leader> :<c-u>WhichKey '<Space>'<CR>

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

    nnoremap Y y$

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
    set incsearch
    set nojoinspaces
    set inccommand=nosplit
    set pumblend=30
    set winblend=30
    set grepprg=rg\ --vimgrep\ --no-heading\ --smart-case
    set hidden " Required for coc.nvim
    set complete+=k
    set completeopt=menu,menuone,noinsert
    set nrformats=bin,hex,octal,alpha
    set breakindent
    set backspace=indent,eol,start
    set clipboard=unnamedplus
    set backup
    set undofile
    set lazyredraw
    set virtualedit=block
    set mouse=
    set dir=$XDG_DATA_HOME/nvim/swap//
    set undodir=$XDG_DATA_HOME/nvim/undo//
    set backupdir=$XDG_DATA_HOME/nvim/backup//
    set noerrorbells visualbell t_vb=
    set list
    set listchars=tab:▸\ ,extends:❯,precedes:❮,trail:⌴
    set showbreak=↪\ \ 
    set fillchars=diff:⣿,vert:│,fold:\
    set showcmd
    set cmdheight=1
    set scrolloff=2
    set sidescrolloff=2
    set number
    set shortmess+=caIA
    set formatoptions+=j

    set expandtab
    set softtabstop=4
    set shiftwidth=4
    set ignorecase
    set smartcase
    set hlsearch
    set noshowmatch
    set nowrap
    set nofoldenable

    set redrawtime=10000
    set synmaxcol=200
    set timeout
    set ttimeout
    set timeoutlen=350
    set ttimeoutlen=10
    set termguicolors
    set updatetime=100
    set splitright
    set splitbelow
    set nofixendofline
    set autoread
    set pyx=3

    let g:netrw_dirhistmax=0

    if has('nvim-0.3.2') || has("patch-8.1.0360")
        set diffopt=filler,internal,algorithm:histogram,indent-heuristic
    endif
    set diffopt+=hiddenoff

    augroup vimrc_settings
        au!
        au FocusGained * :checktime
        au BufWritePost $MYVIMRC nested source $MYVIMRC
        au BufWritePost $MYVIMRC
                    \  if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
                    \|   PlugInstall --sync | q
                    \| endif
        au VimEnter * call vista#RunForNearestMethodOrFunction()
    augroup END

    set statusline=%f\ %h%w%m%r%=%{NearestMethodOrFunction()}%-8.(%)\ %-14.(%l,%c%V%)\ %P
endfunction

function! VimrcLoadFiletypeSettings()
    let g:LargeFile = 1024 * 768 * 1
    augroup LargeFile
        au!
        au BufReadPre * let f=getfsize(expand("<afile>")) | if f > g:LargeFile || f == -2 | call LargeFile() | endif
    augroup END
endfunction

function! VimrcLoadColors()
    colorscheme tempus_dawn
    hi! Comment gui=italic
    hi MatchParen guibg=none gui=italic
    hi SignColumn guibg=none
    hi LineNr guibg=none
    hi DiffChange guibg=none
    hi DiffText guibg=none
endfunction

let g:mapleader = "\<Space>"
call VimrcLoadPlugins()
call VimrcLoadPluginSettings()
call VimrcLoadMappings()
call VimrcLoadSettings()
call VimrcLoadFiletypeSettings()
call VimrcLoadColors()
