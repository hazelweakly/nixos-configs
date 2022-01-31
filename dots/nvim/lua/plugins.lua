local present, packer_init = pcall(require, "configs.packerInit")
if not present then
  return false
end
local packer = packer_init.packer
local use = packer.use
return packer.startup(function()
  use({
    { "lewis6991/impatient.nvim" },
    { "wbthomason/packer.nvim", opt = true },
    { "rcarriga/nvim-notify", config = [[require("configs.notify")]] },
    { "nathom/filetype.nvim", config = [[require("configs.filetype-nvim")]] },
    { "nvim-lua/plenary.nvim", event = "BufRead" },
    "antoinemadec/FixCursorHold.nvim",
  })
  use({ "folke/tokyonight.nvim", after = "plenary.nvim", config = [[require("configs.colors").setup()]] }) -- https://github.com/olimorris/onedarkpro.nvim ?

  use({ "kyazdani42/nvim-web-devicons", event = "BufWinEnter", config = [[require("nvim-web-devicons").setup()]] })
  use({ "nvim-lualine/lualine.nvim", after = "nvim-web-devicons", config = [[require('configs.lualine')]] })

  use({
    "williamboman/nvim-lsp-installer",
    config = [[require("configs.lsp")]],
    event = "BufWinEnter",
    requires = {
      { "ray-x/lsp_signature.nvim", module = "lsp_signature" },
      { "folke/lua-dev.nvim", module = "lua-dev" },
      { "hrsh7th/cmp-nvim-lsp" },
      { "mickael-menu/zk-nvim", ft = "markdown" },
      { "b0o/schemastore.nvim", module = "schemastore" },
      { "jose-elias-alvarez/nvim-lsp-ts-utils", module = "nvim-lsp-ts-utils" },
    },
  })
  use({
    "lukas-reineke/indent-blankline.nvim",
    event = "BufWinEnter",
    after = { "nvim-treesitter", "tokyonight.nvim" },
    config = [[require("configs.indent-blankline")]],
  })
  use({
    "lewis6991/gitsigns.nvim",
    requires = "nvim-lua/plenary.nvim",
    opt = true,
    setup = function()
      require("configs.utils").packer_lazy_load("gitsigns.nvim")
    end,
    config = [[require("configs.gitsigns")]],
  })
  use({
    "nvim-treesitter/nvim-treesitter",
    run = ":TSUpdate",
    requires = {
      { "p00f/nvim-ts-rainbow", event = "BufWinEnter" },
      { "IndianBoy42/tree-sitter-just", requires = "filetype.nvim" },
      { "nvim-treesitter/nvim-treesitter-refactor", event = "BufWinEnter" },
    },
    config = [[require("configs.nvim-treesitter")]],
  })
  use({
    "nvim-telescope/telescope.nvim",
    requires = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      { "nvim-telescope/telescope-fzf-native.nvim", run = "make", module = "telescope._extensions.fzf" },
    },
    after = "nvim-treesitter",
    cmd = "Telescope",
    module = "telescope",
    config = [[require("configs.telescope").config()]],
    setup = [[require("configs.telescope").mappings()]],
  })
  use({ "nvim-treesitter/nvim-treesitter-textobjects", after = "nvim-treesitter" })
  use({ "RRethy/nvim-treesitter-textsubjects", after = "nvim-treesitter" })
  use({
    "neovim/nvim-lspconfig",
    module = "lspconfig",
    setup = function()
      require("configs.utils").packer_lazy_load("nvim-lspconfig")
      vim.defer_fn(function()
        vim.cmd('if &ft == "packer" | echo "" | else | silent! e %')
      end, 0)
    end,
  })
  use("rafamadriz/friendly-snippets")
  use({
    "hrsh7th/nvim-cmp",
    config = [[require("configs.nvim-cmp")]],
    requires = {
      { "hrsh7th/cmp-nvim-lsp", event = "BufWinEnter", after = "nvim-cmp" },
      { "hrsh7th/cmp-buffer", event = "BufWinEnter", after = "nvim-cmp" },
      { "hrsh7th/cmp-path", event = "BufWinEnter", after = "nvim-cmp" },
      { "hrsh7th/cmp-cmdline", event = "BufWinEnter", after = "nvim-cmp" },
      { "hrsh7th/cmp-emoji", event = "BufWinEnter", after = "nvim-cmp" },
      { "f3fora/cmp-nuspell", event = "BufWinEnter", after = "nvim-cmp" },
      { "kdheepak/cmp-latex-symbols", event = "BufWinEnter", after = "nvim-cmp" },
      { "onsails/lspkind-nvim", module = "lspkind" },
      { "L3MON4D3/LuaSnip", event = "BufWinEnter", module = "luasnip" },
      {
        "saadparwaiz1/cmp_luasnip",
        event = "BufWinEnter",
        config = [[require("configs.luasnip")]],
        after = "LuaSnip",
      },
    },
  })
  use({ "windwp/nvim-ts-autotag", after = "nvim-treesitter" })
  use({
    "windwp/nvim-autopairs",
    after = "nvim-cmp",
    config = function()
      require("nvim-autopairs").setup({ check_ts = true, fast_wrap = {} })
      require("cmp").event:on("confirm_done", require("nvim-autopairs.completion.cmp").on_confirm_done())
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
  use({ "ahmedkhalf/project.nvim", config = [[require("project_nvim").setup({})]] })
  use({ "direnv/direnv.vim", event = "BufWinEnter", after = "project.nvim" })
  use({ "editorconfig/editorconfig-vim", event = "BufNewFile,BufReadPost,BufFilePost", after = "project.nvim" })
  use({ "ethanholz/nvim-lastplace", event = "BufReadPost", config = [[require("nvim-lastplace").setup()]] })
  use({ "junegunn/vim-easy-align", setup = [[vim.cmd("xmap <CR> <Plug>(EasyAlign)")]], keys = { { "x", "<CR>" } } })
  -- Revisit eventually once keymappings work better.
  -- use({
  --   "folke/which-key.nvim",
  --   -- keys = "<space>",
  --   config = function()
  --     require("which-key").setup({
  --       plugins = { spelling = { enabled = true } },
  --       window = { border = require("configs.utils").border },
  --     })
  --   end,
  -- })
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
    event = "FocusLost",
    setup = function()
      vim.g.auto_save = 1
      vim.g.auto_save_silent = 1
      vim.g.auto_save_write_all_buffers = 1
      vim.g.auto_save_events = { "FocusLost" }
    end,
  })

  use({
    "wellle/targets.vim",
    requires = { "tpope/vim-repeat" },
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
  use({
    "knubie/vim-kitty-navigator",
    run = "cp ./*.py ~/.config/kitty/",
    config = [[require("configs.kitty")]],
    setup = [[vim.g.kitty_navigator_no_mappings = 1]],
    keys = { "<M-h>", "<M-i>", "<M-j>", "<M-k>" },
  })

  use({
    "numToStr/Comment.nvim",
    keys = { { "n", "gc" }, { "v", "gc" } },
    config = [[require("configs.comment")]],
    requires = {
      { "JoosepAlviste/nvim-ts-context-commentstring", module = "ts_context_commentstring" },
    },
  })

  use({
    "tyru/open-browser.vim",
    event = "CursorHold",
    config = [[vim.api.nvim_set_keymap("n", "gx", "<Plug>(openbrowser-smart-search)", {})]],
  })

  -- https://github.com/blackCauldron7/surround.nvim
  -- keep an eye on this thing
  use({ "romainl/vim-cool", event = "CursorMoved", config = "vim.g.CoolTotalMatches = 1" })
  use({
    "monkoose/matchparen.nvim",
    keys = "%",
    config = function()
      require("matchparen").setup()
      require("matchparen.matchpairs").disable()
      require("matchparen.matchpairs").enable()
    end,
  })
  use({
    "stevearc/dressing.nvim",
    requires = { "MunifTanjim/nui.nvim", module = "dressing.select.nui" },
    event = "BufWinEnter",
    config = function()
      require("dressing").setup({
        builtin = { border = require("configs.utils").border },
        input = { border = require("configs.utils").border },
        select = { telescope = { theme = "cursor" } },
      })
    end,
  })

  use({
    "akinsho/bufferline.nvim",
    wants = { "nvim-web-devicons", "tokyonight.nvim" },
    event = "BufWinEnter",
    config = [[require("configs.bufferline")]],
  })
  use({
    "kosayoda/nvim-lightbulb",
    event = "CursorHold",
    config = function()
      vim.cmd([[autocmd CursorHold,CursorHoldI * lua require'nvim-lightbulb'.update_lightbulb()]])
    end,
  })
  use({ "Pocco81/HighStr.nvim", cmd = { "HSHighlight", "HSRmHighlight", "HSImport", "HSExport" } }) -- https://github.com/Pocco81/HighStr.nvim
  use({
    "monaqa/dial.nvim",
    setup = [[require('configs.dial')]],
    keys = { { "n", "<C-a>" }, { "n", "<C-x>" }, { "v", "<C-a>" }, { "v", "<C-x>" }, { "v", "g" } },
  })
  use({ "ggandor/lightspeed.nvim", requires = "tpope/vim-repeat" })
  use({ "machakann/vim-sandwich", after = "lightspeed.nvim", config = [[require("configs.vim-sandwich")]] })

  use({ "tweekmonster/startuptime.vim", cmd = "StartupTime" })

  use({ "j-hui/fidget.nvim", after = "nvim-lsp-installer", config = [[require("fidget").setup()]] })
  -- Should be the last plugin, or the setup needs to go in init.lua after plugins happen
  use({ "norcalli/nvim-colorizer.lua", after = "indent-blankline.nvim", config = [[require("colorizer").setup()]] })

  if packer_init.first_install then
    packer.sync()
  end
end)
