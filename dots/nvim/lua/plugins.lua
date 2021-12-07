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

if fn.filereadable(packer_compiled_path) and not bootstrap then
  require("impatient")
  require("packer_compiled")
end

local packer = require("packer")
local util = require("packer.util")

packer.init({
  compile_path = packer_compiled_path,
  display = {
    open_fn = function()
      return util.float({
        border = "single",
        height = math.ceil(vim.o.lines * 0.5),
      })
    end,
  },
})

packer.startup(function(use)
  use("wbthomason/packer.nvim")

  use("direnv/direnv.vim")
  use("editorconfig/editorconfig-vim")
  use("nvim-lua/lsp-status.nvim")
  use({
    "SmiteshP/nvim-gps",
    config = function()
      require("nvim-gps").setup()
    end,
  })
  use("jackguo380/vim-lsp-cxx-highlight")
  use({
    "p00f/nvim-ts-rainbow",
    requires = "nvim-treesitter/nvim-treesitter",
    config = function()
      require("nvim-treesitter.configs").setup({
        rainbow = { enable = true, extended_mode = true, max_file_lines = 1000 },
      })
    end,
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
    config = function()
      require("indent")
    end,
  })
  use("folke/lsp-colors.nvim")
  use("honza/vim-snippets")
  use("folke/which-key.nvim")
  use("lambdalisue/suda.vim")
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
  use("junegunn/vim-easy-align")
  use("907th/vim-auto-save")
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
      require("comment_setup")
    end,
  })
  use("tommcdo/vim-exchange")
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
  use("machakann/vim-sandwich")
  use("wellle/targets.vim")
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

  use("dkarter/bullets.vim")
  use("sheerun/vim-polyglot")

  use({ "antoinemadec/coc-fzf", requires = { "neoclide/coc.nvim", "junegunn/fzf.vim" } })

  use({
    "neoclide/coc.nvim",
    branch = "master",
    run = "yarn install --frozen-lockfile",
    config = function()
      vim.cmd([=[
          " fzf-preview.vim
          nnoremap <silent> <leader>f :<C-u>CocCommand fzf-preview.DirectoryFiles<CR>
          nnoremap <silent> <leader>h :<C-u>CocCommand fzf-preview.History<CR>
          nnoremap <silent> <leader>b :<C-u>CocCommand fzf-preview.Buffers<CR>
          nnoremap <silent> <leader><space> :<C-u>CocCommand fzf-preview.ProjectGrep .<CR>
          xnoremap <silent> <leader><space> y:Rg <C-R>"<CR>
          nnoremap <silent> <leader>/ :<C-u>CocCommand fzf-preview.Lines<CR>
          nnoremap <silent> <Leader>gs :<C-u>CocCommand fzf-preview.GitStatus<CR>
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
    run = ":TSUpdate",
    config = function()
      require("setup-treesitter")
    end,
  })
  use({
    "IndianBoy42/tree-sitter-just",
    requires = { "nvim-treesitter/nvim-treesitter", "nathom/filetype.nvim" },
    run = function()
      require("tree-sitter-just").setup({})
    end,
  })

  use({ "knubie/vim-kitty-navigator", run = "cp ./*.py ~/.config/kitty/" })

  use({ "folke/tokyonight.nvim", branch = "main" })

  use({
    "lervag/vimtex",
    ft = { "latex", "tex" },
    config = function()
      vim.g.tex_flavor = "latex"
    end,
  })

  use("nvim-lua/plenary.nvim")
  use("neovim/nvim-lspconfig")
  use({
    "jose-elias-alvarez/null-ls.nvim",
    requires = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
    config = function()
      require("null-ls").config({
        sources = { require("null-ls").builtins.formatting.stylua },
      })
      require("lspconfig")["null-ls"].setup({})
    end,
  })

  -- Speed up stuff
  use("lewis6991/impatient.nvim")
  use({
    "nathom/filetype.nvim",
    config = function()
      require("filetype_nvim_setup")
    end,
  })
  use("antoinemadec/FixCursorHold.nvim")

  if bootstrap then
    require("packer").sync()
  end
end)

vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerCompile
  augroup end
]])
