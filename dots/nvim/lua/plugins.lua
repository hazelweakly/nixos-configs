local present, packer_init = pcall(require, "configs.packerInit")
if not present then
  return false
end
local packer = packer_init.packer
local use = packer.use

return packer.startup(function()
  use({
    { "lewis6991/impatient.nvim" },
    { "wbthomason/packer.nvim", event = "VimEnter" },
    { "nathom/filetype.nvim", config = [[require("configs.filetype-nvim")]] },
    "nvim-lua/plenary.nvim",
    "antoinemadec/FixCursorHold.nvim",
  })
  use({ "folke/tokyonight.nvim", after = "plenary.nvim", config = [[require("configs.colors").setup()]] }) -- https://github.com/olimorris/onedarkpro.nvim ?
  use({ "rcarriga/nvim-notify", config = [[require("configs.notify")]], after = "tokyonight.nvim" })
  use({ "tweekmonster/startuptime.vim", cmd = "StartupTime" })

  -- statusline

  -- lspconfig
  -- -- requires: installer, schemastore, lsp-ts-utils, null-ls, signature.nvim

  -- nvim-cmp
  -- -- requires: LuaSnip (reuires friendly-snippets), cmp-nvim-lsp, cmp_luasnip, cmp-buffer, cmp-path, autopairs,
  -- -- event: InsertEnter

  -- git signs

  -- telescope
  -- -- requires: popup.nvim plenary.nvim fzf-native
  -- -- event: BufWinEnter

  -- auto-session?

  -- treesitter
  -- -- requires: nvim-ts-autotag, ontext commentstring, refactor

  use({ "kyazdani42/nvim-web-devicons", event = "BufRead", config = [[require("nvim-web-devicons").setup()]] })
  -- use({ "feline-nvim/feline.nvim", after = "nvim-web-devicons", config = [[require('configs.feline')]] })
  use({ "nvim-lualine/lualine.nvim", after = "nvim-web-devicons", config = [[require('configs.lualine')]] })

  use({
    "williamboman/nvim-lsp-installer",
    config = [[require("configs.lsp")]],
    requires = { "ray-x/lsp_signature.nvim", "hrsh7th/cmp-nvim-lsp", "mickael-menu/zk-nvim" },
  })
  use({
    "lukas-reineke/indent-blankline.nvim",
    requires = "nvim-treesitter/nvim-treesitter",
    after = { "nvim-treesitter", "tokyonight.nvim" },
    config = [[require("configs.indent-blankline")]],
  })
  use({
    "lewis6991/gitsigns.nvim",
    requires = "nvim-lua/plenary.nvim",
    event = "BufRead",
    config = function()
      require("gitsigns").setup({
        signs = {
          add = { text = "▎" },
          change = { text = "▎" },
          delete = { text = "▎" },
          topdelete = { text = "▔" },
          changedelete = { text = "▋" },
        },
        keymaps = {
          ["n gn"] = { expr = true, "&diff ? ']c' : '<cmd>Gitsigns next_hunk<CR>'" },
          ["n gp"] = { expr = true, "&diff ? '[c' : '<cmd>Gitsigns prev_hunk<CR>'" },
        },
      })
    end,
  })
  use({ "nvim-treesitter/nvim-treesitter-refactor", requires = "nvim-treesitter/nvim-treesitter" })
  use({ "p00f/nvim-ts-rainbow", requires = "nvim-treesitter/nvim-treesitter" })
  use({
    "nvim-treesitter/nvim-treesitter",
    run = { ":TSInstall all", ":TSUpdate" },
    config = [[require("configs.nvim-treesitter")]],
  })
  use({
    "nvim-telescope/telescope.nvim",
    requires = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "mickael-menu/zk-nvim",
      { "nvim-telescope/telescope-fzf-native.nvim", run = "make" },
    },
    after = "nvim-treesitter",
    event = "BufWinEnter",
    config = [[require("configs.telescope")]],
  })
  use({ "nvim-treesitter/nvim-treesitter-textobjects", after = "nvim-treesitter" })
  use({ "RRethy/nvim-treesitter-textsubjects", after = "nvim-treesitter" })
  use({ "neovim/nvim-lspconfig", module = "lspconfig" })
  use("b0o/schemastore.nvim")
  use("jose-elias-alvarez/nvim-lsp-ts-utils")
  use("folke/lua-dev.nvim")
  use({
    "hrsh7th/nvim-cmp",
    config = [[require("configs.nvim-cmp")]],
    requires = {
      "saadparwaiz1/cmp_luasnip",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-cmdline",
      "hrsh7th/cmp-emoji",
      { "PaterJason/cmp-conjure", requires = "Olical/conjure", ft = "clojure" },
      { "f3fora/cmp-nuspell", rocks = { "lua-nuspell" } },
      "kdheepak/cmp-latex-symbols",
      "onsails/lspkind-nvim",
    },
  })
  use({
    "abecodes/tabout.nvim",
    config = function()
      require("tabout").setup({
        act_as_shift_tab = true,
      })
    end,
    wants = { "nvim-treesitter" },
    after = { "completion-nvim" },
  })
  use({ "saadparwaiz1/cmp_luasnip", config = [[require("configs.luasnip")]] })
  use({ "L3MON4D3/LuaSnip" })
  use({ "rafamadriz/friendly-snippets" })
  use({ "windwp/nvim-ts-autotag", after = "nvim-treesitter" })
  use({
    "windwp/nvim-autopairs",
    after = "nvim-cmp",
    config = function()
      require("nvim-autopairs").setup({ check_ts = true })
      -- require("cmp").event:on("confirm_done", require("nvim-autopairs.completion.cmp").on_confirm_done())
    end,
  })
  use({
    "Olical/conjure",
    ft = "clojure",
    config = function()
      vim.g["conjure#mapping#doc_word"] = "K"
      vim.g["conjure#highlight#enabled"] = true
      vim.g["conjure#extract#tree_sitter#enabled"] = true
      vim.g["conjure#client#clojure#nrepl#eval#auto_require"] = false
      vim.g["conjure#client#clojure#nrepl#connection#auto_repl#enabled"] = false
    end,
  })
  use({
    "jose-elias-alvarez/null-ls.nvim",
    config = [[require("configs.null-ls")]],
    requires = { "nvim-lua/plenary.nvim" },
  })
  use({ "ahmedkhalf/project.nvim", config = [[require("project_nvim").setup{}]] })
  use("direnv/direnv.vim")
  use("editorconfig/editorconfig-vim")
  use("ethanholz/nvim-lastplace")
  use({ "junegunn/vim-easy-align", config = [[vim.cmd("xmap <CR> <Plug>(EasyAlign)")]] })
  use({
    "folke/which-key.nvim",
    keys = "<space>",
    config = function()
      require("which-key").setup({
        plugins = { spelling = { enabled = true } },
      })
    end,
  })
  use({ "lambdalisue/suda.vim", cmd = "W", setup = [=[vim.cmd([[command! W :w suda://%]])]=] })

  use({
    "dkarter/bullets.vim",
    ft = { "markdown", "text", "gitcommit" },
    config = function()
      vim.g.bullets_enabled_file_types = { "markdown", "text", "gitcommit" }
      vim.g.bullets_outline_levels = { "num", "std-" }
    end,
  })

  use("wsdjeg/vim-fetch")
  use({
    "907th/vim-auto-save",
    events = "FocusLost",
    setup = function()
      vim.g.auto_save = 1
      vim.g.auto_save_write_all_buffers = 1
      vim.g.auto_save_events = { "FocusLost" }
    end,
  })
  use("sunjon/Shade.nvim")

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
  use({
    "lervag/vimtex",
    ft = { "latex", "tex" },
    config = [[vim.g.tex_flavor = "latex"]],
  })
  use({ "lewis6991/spellsitter.nvim", config = [[require("spellsitter").setup()]] })
  use({
    "knubie/vim-kitty-navigator",
    run = "cp ./*.py ~/.config/kitty/",
    config = [[require("configs.kitty")]],
  })

  use({
    "numToStr/Comment.nvim",
    requires = "JoosepAlviste/nvim-ts-context-commentstring",
    event = "BufWinEnter",
    config = [[require("configs.comment")]],
  })

  use({
    "tyru/open-browser.vim",
    event = "CursorHold",
    config = [[vim.api.nvim_set_keymap("n", "gx", "<Plug>(openbrowser-smart-search)", {})]],
  })
  -- https://github.com/blackCauldron7/surround.nvim
  -- keep an eye on this thing
  use({ "machakann/vim-sandwich", config = [[require("configs.vim-sandwich")]] })
  use({ "romainl/vim-cool", config = "vim.g.CoolTotalMatches = 1" })
  use({ "monkoose/matchparen.nvim", config = [[require("matchparen").setup()]] })
  use({
    "stevearc/dressing.nvim",
    requires = "MunifTanjim/nui.nvim",
    config = function()
      require("dressing").setup({
        builtin = { border = require("configs.utils").border },
      })
    end,
  })

  use({
    "akinsho/bufferline.nvim",
    wants = { "nvim-web-devicons", "tokyonight.nvim" },
    event = "BufReadPre",
    config = [[require("configs.bufferline")]],
  })
  use({
    "kosayoda/nvim-lightbulb",
    config = function()
      vim.cmd([[autocmd CursorHold,CursorHoldI * lua require'nvim-lightbulb'.update_lightbulb()]])
    end,
  })
  use({
    "mickael-menu/zk-nvim",
    requires = { "neovim/nvim-lspconfig" },
    config = function()
      require("zk").setup()
    end,
  })
  use({
    "folke/twilight.nvim",
    config = function()
      require("twilight").setup({})
    end,
  })

  use("Pocco81/HighStr.nvim") -- https://github.com/Pocco81/HighStr.nvim
  use("monaqa/dial.nvim")
  use("ggandor/lightspeed.nvim")
  -- https://github.com/rcarriga/nvim-notify
  -- https://github.com/ggandor/lightspeed.nvim
  -- https://github.com/nacro90/numb.nvim
  -- https://github.com/abecodes/tabout.nvim

  -- https://github.com/kevinhwang91/nvim-hlslens

  -- Should be the last plugin, or the setup needs to go in init.lua after plugins happen
  use({ "norcalli/nvim-colorizer.lua", config = [[require("colorizer").setup()]] })
  -- use({
  --   "jenterkin/vim-autosource",
  --   config = function()
  --     vim.g.autosource_hashdir = "$XDG_CACHE_HOME/vim-autosource/hashes"
  --   end,
  -- })

  if packer_init.first_install then
    packer.sync()
  end
end)
