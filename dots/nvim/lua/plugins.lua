local fn = vim.fn
local command = vim.api.nvim_command
local packer_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
local packer_compiled_path = fn.stdpath("config") .. "/lua/packer_compiled.lua"
local bootstrap = false

if (fn.empty(fn.glob(packer_path)) > 0) or (fn.empty(fn.glob(packer_compiled_path)) > 0) then
  bootstrap = true
  fn.system({ "rm", "-f", packer_compiled_path })
  fn.system({ "git", "clone", "https://github.com/wbthomason/packer.nvim", packer_path })
  command("packadd packer.nvim")
end

local packer = require("packer")

do -- Hacky way of auto clean/install/compile
  command([[
    augroup plugins
    " Reload plugins.lua
    autocmd!
    autocmd BufWritePost plugins.lua lua package.loaded["plugins"] = nil; require("plugins")
    autocmd BufWritePost plugins.lua PackerClean
    augroup END
  ]])

  local state = "cleaned"
  local orig_complete = packer.on_complete
  packer.on_complete = vim.schedule_wrap(function()
    if state == "cleaned" then
      packer.install()
      state = "installed"
    elseif state == "installed" then
      packer.compile()
      state = "compiled"
    elseif state == "compiled" then
      packer.on_complete = orig_complete
      state = "done"
    end
  end)
end

packer.startup({
  function(use)
    use("wbthomason/packer.nvim")

    use("direnv/direnv.vim")
    use("editorconfig/editorconfig-vim")
    use("nvim-lua/lsp-status.nvim")
    use({
      "SmiteshP/nvim-gps",
      requires = "nvim-treesitter/nvim-treesitter",
      config = function()
        require("nvim-gps").setup()
      end,
    })
    use("jackguo380/vim-lsp-cxx-highlight")
    use({
      "p00f/nvim-ts-rainbow",
      requires = "nvim-treesitter/nvim-treesitter",
    })
    use({
      "Olical/conjure",
      config = function()
        vim.g["conjure#mapping#doc_word"] = "K"
        vim.g["conjure#highlight#enabled"] = true
        vim.g["conjure#extract#tree_sitter#enabled"] = true
      end,
    })
    use({
      "lukas-reineke/indent-blankline.nvim",
      requires = { "nvim-treesitter/nvim-treesitter" },
      config = function()
        require("configs.indent-blankline")
      end,
    })
    use("folke/lsp-colors.nvim")
    use("honza/vim-snippets")
    use({
      "folke/which-key.nvim",
      config = function()
        vim.defer_fn(function()
          require("which-key").setup({
            plugins = { spelling = { enabled = true } },
          })
        end, 2000)
      end,
    })
    use({
      "lambdalisue/suda.vim",
      config = function()
        vim.cmd([[command! W :w suda://%]])
      end,
    })
    use("farmergreg/vim-lastplace")

    use("junegunn/fzf")
    use({
      "junegunn/fzf.vim",
      requires = "junegunn/fzf",
      config = function()
        local env_dict = {
          FZF_PREVIEW_COMMAND = "bat --style=numbers,changes --color always {}",
          FZF_DEFAULT_OPTS = "--color=light --reverse ",
          FZF_DEFAULT_COMMAND = "fd -t f -L -H -E .git",
          BAT_THEME = "ansi",
        }
        for k, v in pairs(env_dict) do
          local ev = vim.env[k]
          vim.env[k] = (ev == nil or ev == "" and v) or ev
        end
        vim.o.shell = "bash"
        vim.g.fzf_layout = { window = { width = 0.9, height = 0.9 } }
      end,
    })
    use({
      "junegunn/vim-easy-align",
      config = function()
        vim.cmd("xmap <CR> <Plug>(EasyAlign)")
      end,
    })
    use({
      "907th/vim-auto-save",
      config = function()
        vim.g.auto_save = 1
        vim.g.auto_save_write_all_buffers = 1
        vim.g.auto_save_events = { "FocusLost" }
      end,
    })
    use("blueyed/vim-diminactive")
    use({
      "camspiers/lens.vim",
      config = function()
        vim.g["lens#disabled_filetypes"] = { "nerdtree", "fzf" }
      end,
    })
    use("wsdjeg/vim-fetch")

    use("arp242/jumpy.vim")
    use("JoosepAlviste/nvim-ts-context-commentstring")
    use({
      "numToStr/Comment.nvim",
      requires = "JoosepAlviste/nvim-ts-context-commentstring",
      config = function()
        require("configs.comment")
      end,
    })
    use({
      "tommcdo/vim-exchange",
      config = function()
        vim.cmd("xmap gx <Plug>(Exchange)")
      end,
    })
    use("machakann/vim-swap")
    use("airblade/vim-rooter")
    use({
      "rmagatti/auto-session",
      config = function()
        require("auto-session").setup({ auto_save_enabled = true })
        vim.opt.sessionoptions:append({ "winpos", "terminal" })
      end,
    })
    use("rhysd/git-messenger.vim")
    use("rhysd/conflict-marker.vim")

    use("tyru/open-browser.vim")
    use({
      "machakann/vim-sandwich",
      config = function()
        vim.g["sandwich#recipes"] = vim.deepcopy(vim.g["sandwich#default_recipes"])
      end,
    })
    use({
      "wellle/targets.vim",
      config = function()
        vim.cmd([[
          autocmd User targets#mappings#user call targets#mappings#extend({
          \ 'a': {'argument': [{'o': '[({[]', 'c': '[]})]', 's': ','}]}
          \ })
        ]])
      end,
    })
    use({ "romainl/vim-cool", config = "vim.g.CoolTotalMatches = 1" })
    use({
      "andymass/vim-matchup",
      config = function()
        vim.g.matchup_transmute_enabled = 1
        vim.g.matchup_matchparen_deferred = 1
        vim.g.matchup_matchparen_status_offscreen = 0
        vim.g.matchup_delim_stopline = 2500
      end,
    })
    use("kyazdani42/nvim-web-devicons")
    use("jceb/vim-orgmode")
    use("https://gitlab.com/protesilaos/tempus-themes-vim.git")

    use({
      "dkarter/bullets.vim",
      config = function()
        vim.g.bullets_enabled_file_types = { "markdown", "text", "gitcommit" }
        vim.g.bullets_outline_levels = { "num", "std-" }
      end,
    })

    use({
      "sheerun/vim-polyglot",
      config = function()
        vim.g.haskell_enable_quantification = 1
        vim.g.haskell_enable_pattern_synonyms = 1
        vim.g.haskell_enable_typeroles = 1
        vim.g.php_html_load = 1
        vim.g.vim_jsx_pretty_colorful_config = 1
        vim.g.vim_jsx_pretty_template_tags = {}
        vim.g.vim_markdown_new_list_item_indent = 0
        vim.g.vim_markdown_auto_insert_bullets = 0
        vim.g.vim_markdown_math = 1
        vim.g.vim_markdown_frontmatter = 1
        vim.g.vim_markdown_toml_frontmatter = 1
        vim.g.vim_markdown_json_frontmatter = 1
        vim.g.vim_markdown_strikethrough = 1
        vim.g.vim_markdown_folding_disabled = 1
      end,
    })

    use({ "antoinemadec/coc-fzf", requires = { "neoclide/coc.nvim", "junegunn/fzf.vim" } })

    use({
      "neoclide/coc.nvim",
      branch = "master",
      run = "yarn install --frozen-lockfile",
      config = function()
        vim.cmd([=[
          " fzf-preview.vim
          nmap <silent> <leader>f :<C-u>CocCommand fzf-preview.DirectoryFiles<CR>
          nmap <silent> <leader>h :<C-u>CocCommand fzf-preview.History<CR>
          nmap <silent> <leader>b :<C-u>CocCommand fzf-preview.Buffers<CR>
          nmap <silent> <leader><space> :<C-u>CocCommand fzf-preview.ProjectGrep .<CR>
          nmap <silent> <leader><space> y:Rg <C-R>"<CR>
          nmap <silent> <leader>/ :<C-u>CocCommand fzf-preview.Lines<CR>
          nmap <silent> <Leader>gs :<C-u>CocCommand fzf-preview.GitStatus<CR>
          let g:fzf_preview_use_dev_icons = 1
          let g:fzf_preview_git_status_preview_command =  "[[ $(git diff --cached -- {-1}) != \"\" ]] && git diff --cached --color=always -- {-1} || " .
          \ "[[ $(git diff -- {-1}) != \"\" ]] && git diff --color=always -- {-1} || " .
          \ 'bat --color=always --plain {-1}'

          " coc.nvim
          nmap <silent> gd <Plug>(coc-definition)
          nmap <silent> gr <Plug>(coc-rename)
          nmap <silent> gR <Plug>(coc-references)
          nmap <silent> K :call CocActionAsync('doHover')<CR>
          nmap <silent> gz <Plug>(coc-refactor)
          nmap <silent> gl <Plug>(coc-codelens-action)

          if has('nvim-0.4.0') || has('patch-8.2.0750')
          nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
          nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
          inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
          inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
          vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
          vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
          endif

          function! s:cocActionsOpenFromSelected(type) abort
          execute 'CocCommand actions.open ' . a:type
          endfunction
          xmap <silent> ga :<C-u>execute 'CocCommand actions.open ' . visualmode()<CR>
          nmap <silent> ga :<C-u>set operatorfunc=<SID>cocActionsOpenFromSelected<CR>g@

          nmap <silent> gA <Plug>(coc-fix-current)
          nmap <silent> <C-n> <Plug>(coc-diagnostic-next)
          nmap <silent> <C-p> <Plug>(coc-diagnostic-prev)

          let g:coc_filetype_map = {
          \ 'yaml.ansible': 'yaml',
          \ 'direnv':'sh',
          \ 'bash':'sh'
          \ }

          let g:coc_global_extensions = [
          \ 'coc-actions',
          \ 'coc-cfn-lint',
          \ 'coc-clangd',
          \ 'coc-cmake',
          \ 'coc-conjure',
          \ 'coc-css',
          \ 'coc-cssmodules',
          \ 'coc-diagnostic',
          \ 'coc-dictionary',
          \ 'coc-docker',
          \ 'coc-emmet',
          \ 'coc-emoji',
          \ 'coc-eslint',
          \ 'coc-fzf-preview',
          \ 'coc-git',
          \ 'coc-go',
          \ 'coc-highlight',
          \ 'coc-html',
          \ 'coc-json',
          \ 'coc-lightbulb',
          \ 'coc-pairs',
          \ 'coc-prettier',
          \ 'coc-pyright',
          \ 'coc-rust-analyzer',
          \ 'coc-sh',
          \ 'coc-snippets',
          \ 'coc-stylua',
          \ 'coc-sumneko-lua',
          \ 'coc-toml',
          \ 'coc-tslint-plugin',
          \ 'coc-tsserver',
          \ 'coc-vetur',
          \ 'coc-vimlsp',
          \ 'coc-vimtex',
          \ 'coc-word',
          \ 'coc-yaml'
          \ ]

          let g:coc_fzf_preview = ''
          let g:coc_fzf_opts = []

          augroup coc
          au!
          au CompleteDone * if pumvisible() == 0 | pclose | endif
          au User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
          au CursorHold * silent! call CocActionAsync('highlight')
          au User CocQuickfixChange :CocFzfList --normal quickfix
          augroup END

          " inoremap <expr> <Tab> pumvisible() ? coc#_select_confirm() : "\<Tab>"
          inoremap <expr> <CR> complete_info()["selected"] != "-1" ? coc#_select_confirm() : "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"
          " inoremap <expr> <S-Tab> "\<C-h>"
          inoremap <silent><expr> <c-space> coc#refresh()

          inoremap <silent><expr> <TAB>
          \ pumvisible() ? coc#_select_confirm() :
          \ coc#expandableOrJumpable() ? "\<C-r>=coc#rpc#request('doKeymap', ['snippets-expand-jump',''])\<CR>" :
          \ <SID>check_back_space() ? "\<TAB>" :
          \ coc#refresh()

          function! s:check_back_space() abort
          let col = col('.') - 1
          return !col || getline('.')[col - 1]  =~# '\s'
          endfunction

          let g:coc_snippet_next = '<Tab>'
          let g:coc_snippet_prev = '<S-Tab>'

          xmap <silent> <TAB> <Plug>(coc-range-select)
          xmap <silent> <S-TAB> <Plug>(coc-range-select-backword)

          nmap <silent> <leader>c :CocCommand<CR>
          nmap <silent> <leader>lo :<C-u>CocFzfList outline<CR>
          nmap <silent> <leader>ls :<C-u>CocFzfList -I symbols<CR>
          nmap <silent> <leader>ld :<C-u>CocFzfList diagnostics<CR>

          nmap gp <Plug>(coc-git-prevchunk)
          nmap gn <Plug>(coc-git-nextchunk)
        ]=])
      end,
    })
    use({ "rafcamlet/coc-nvim-lua", requires = "neoclide/coc.nvim" })
    use({
      "expipiplus1/vscode-hie-server",
      branch = "coc.nvim",
      run = "yarn install --frozen-lockfile ;  yarn vscode:prepublish",
    })
    use({
      "sbdchd/neoformat",
      ft = { "terraform" },
      config = function()
        vim.g.neoformat_only_msg_on_error = 1
        vim.cmd([[command! NeoformatDisable au! neoformat]])
        vim.cmd([[
      augroup neoformat
      au! * <buffer>
      au BufWritePre <buffer> try | undojoin | Neoformat | catch /^Vim\%((\a\+)\)\=:E790/ | finally | silent Neoformat | endtry
      augroup END

      if !exists("b:undo_ftplugin")
      let b:undo_ftplugin = '#!'
      endif

      let b:undo_ftplugin .= " | exe 'au! neoformat * <buffer>' "
      ]])
      end,
    })
    use({
      "nvim-treesitter/nvim-treesitter",
      run = { ":TSInstall all", ":TSUpdate" },
      config = function()
        require("configs.nvim-treesitter")
      end,
    })
    use({
      "IndianBoy42/tree-sitter-just",
      requires = { "nvim-treesitter/nvim-treesitter", "nathom/filetype.nvim" },
      run = function()
        require("tree-sitter-just").setup({})
      end,
    })

    use({
      "knubie/vim-kitty-navigator",
      run = "cp ./*.py ~/.config/kitty/",
      config = function()
        vim.g.kitty_navigator_no_mappings = 1
        vim.cmd([[
          nnoremap <silent> <M-h> :KittyNavigateLeft<cr>
          nnoremap <silent> <M-j> :KittyNavigateDown<cr>
          nnoremap <silent> <M-k> :KittyNavigateUp<cr>
          nnoremap <silent> <M-l> :KittyNavigateRight<cr>
        ]])
      end,
    })

    use({ "folke/tokyonight.nvim", branch = "main" })

    use({
      "lervag/vimtex",
      ft = { "latex", "tex" },
      config = function()
        vim.g.tex_flavor = "latex"
      end,
    })
    use({
      "lewis6991/spellsitter.nvim",
      config = function()
        require("spellsitter").setup()
      end,
    })

    use("nvim-lua/plenary.nvim")
    use("neovim/nvim-lspconfig")
    -- use({
    --   "jose-elias-alvarez/null-ls.nvim",
    --   requires = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
    --   config = function()
    --     require("null-ls").config({
    --       sources = { require("null-ls").builtins.formatting.stylua },
    --     })
    --     require("lspconfig")["null-ls"].setup({})
    --   end,
    -- })

    -- Speed up stuff
    use({ "lewis6991/impatient.nvim", rocks = "mpack" })
    use({
      "nathom/filetype.nvim",
      config = function()
        require("configs.filetype-nvim")
      end,
    })
    use("antoinemadec/FixCursorHold.nvim")

    if bootstrap then
      require("packer").sync()
    end
  end,
  config = {
    compile_path = packer_compiled_path,
    display = {
      open_fn = function()
        return require("packer.util").float({
          border = "single",
          height = math.ceil(vim.o.lines * 0.5),
        })
      end,
    },
  },
})
return packer
