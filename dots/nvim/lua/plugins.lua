-- https://github.com/akinsho/dotfiles/blob/main/.config/nvim/lua/as/plugins/init.lua
local present, packer_init = pcall(require, "configs.packerInit")
if not present then
  return false
end
local packer = packer_init.packer

return packer.startup(function(use)
  local load_if_small_file = function()
    return not require("_.large_file").is_large_file()
  end

  use({
    { "wbthomason/packer.nvim", opt = true },
    { "rcarriga/nvim-notify", config = [[require("configs.notify")]] },
    { "nathom/filetype.nvim", config = [[require("configs.filetype-nvim")]] },
    { "nvim-lua/plenary.nvim", module = "plenary" },
    "lewis6991/impatient.nvim",
    "antoinemadec/FixCursorHold.nvim",
  })
  use({ "jedi2610/nvim-rooter.lua", config = [[require("nvim-rooter").setup()]] })
  use({ "hazelweakly/direnv.vim", after = "nvim-rooter.lua" })
  use({ "folke/tokyonight.nvim", requires = "plenary.nvim", module = "tokyonight" })

  use({
    "kyazdani42/nvim-web-devicons",
    module = "nvim-web-devicons",
    config = [[require("nvim-web-devicons").setup()]],
    cond = load_if_small_file,
  })
  use({
    "nvim-lualine/lualine.nvim",
    after = { "nvim-web-devicons", "tokyonight.nvim" },
    config = [[require('configs.lualine')]],
  })

  -- also benchmark actual time to startup vim in an empty directory.
  use({
    "williamboman/nvim-lsp-installer",
    config = [[require("configs.lsp")]],
    event = "User DirenvLoaded",
    requires = {
      { "ray-x/lsp_signature.nvim", module = "lsp_signature" },
      { "folke/lua-dev.nvim", module = "lua-dev" },
      { "hrsh7th/cmp-nvim-lsp" },
      { "mickael-menu/zk-nvim", ft = "markdown" },
      {
        "simrat39/rust-tools.nvim",
        module = "rust-tools",
        config = [[require("rust-tools").start_standalone_if_required = function() end]],
        run = [[rm -rf plugin]],
      },
      { "b0o/schemastore.nvim", module = "schemastore" },
      { "jose-elias-alvarez/nvim-lsp-ts-utils", module = "nvim-lsp-ts-utils" },
    },
    cond = load_if_small_file,
  })
  use({
    "lukas-reineke/indent-blankline.nvim",
    event = "CursorHold",
    after = { "nvim-treesitter", "tokyonight.nvim" },
    config = [[require("configs.indent-blankline")]],
    cond = load_if_small_file,
  })
  use({
    "lewis6991/gitsigns.nvim",
    requires = "nvim-lua/plenary.nvim",
    opt = true,
    setup = function()
      require("configs.utils").packer_lazy_load("gitsigns.nvim", 100)
    end,
    config = [[require("configs.gitsigns")]],
    cond = load_if_small_file,
  })
  use({
    "nvim-treesitter/nvim-treesitter",
    run = ":TSUpdate",
    event = "BufWinEnter",
    requires = {
      { "p00f/nvim-ts-rainbow", event = "BufWinEnter", after = "nvim-treesitter" },
      { "IndianBoy42/tree-sitter-just", requires = "filetype.nvim", module = "tree-sitter-just" },
      { "nvim-treesitter/nvim-treesitter-refactor", after = "nvim-treesitter" },
      { "nvim-treesitter/nvim-treesitter-textobjects", after = "nvim-treesitter" },
      { "RRethy/nvim-treesitter-textsubjects", after = "nvim-treesitter" },
      { "windwp/nvim-ts-autotag", after = "nvim-treesitter" },
    },
    config = [[require("configs.nvim-treesitter")]],
    cond = load_if_small_file,
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
    module_pattern = "telescope.*",
    config = [[require("configs.telescope").config()]],
    setup = [[require("configs.telescope").mappings()]],
  })
  use({ "neovim/nvim-lspconfig", module = "lspconfig" })
  use({ "rafamadriz/friendly-snippets", module = "cmp_nvim_lsp", event = "InsertEnter" })
  use({ "hrsh7th/nvim-cmp", after = "friendly-snippets", config = [[require("configs.nvim-cmp")]] })
  use({
    "L3MON4D3/LuaSnip",
    config = [[require("configs.luasnip")]],
    after = "nvim-cmp",
    wants = "friendly-snippets",
  })
  use({
    "danymat/neogen",
    config = [[require("configs.neogen")]],
    after = "nvim-cmp",
    requires = "nvim-treesitter/nvim-treesitter",
  })
  use({
    { "saadparwaiz1/cmp_luasnip", after = "LuaSnip" },
    { "hrsh7th/cmp-nvim-lsp", after = "cmp_luasnip" },
    { "hrsh7th/cmp-buffer", after = "cmp-nvim-lsp" },
    { "hrsh7th/cmp-path", after = "cmp-nvim-lsp" },
    { "hrsh7th/cmp-cmdline", after = "cmp-nvim-lsp" },
    { "hrsh7th/cmp-emoji", after = "cmp-nvim-lsp" },
    { "f3fora/cmp-nuspell", after = "cmp-nvim-lsp" },
    { "kdheepak/cmp-latex-symbols", after = "cmp-nvim-lsp" },
    { "onsails/lspkind-nvim", module = "lspkind" },
  })
  use({
    "ZhiyuanLck/smart-pairs",
    event = "InsertEnter",
    after = "nvim-cmp",
    config = [[require("configs.smart-pairs")]],
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
    event = "CursorHold",
    after = "nvim-rooter.lua",
  })
  use({ "editorconfig/editorconfig-vim", event = "CursorHold", after = "nvim-rooter.lua" })
  use({ "ethanholz/nvim-lastplace", event = "BufReadPost", config = [[require("nvim-lastplace").setup()]] })
  use({ "junegunn/vim-easy-align", setup = [[require("configs.utils").map("x", "<CR>", "<Plug>(EasyAlign)")]] })
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

  use({ "tpope/vim-repeat", event = "CursorHold" })
  use({
    "wellle/targets.vim",
    after = "vim-repeat",
    event = "CursorHold",
    config = function()
      vim.api.nvim_create_autocmd("User", {
        pattern = "targets#mappings#user",
        command = [[call targets#mappings#extend({ 'a': {'argument': [{'o': '[({[]', 'c': '[]})]', 's': ','}]} })]],
      })
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
    keys = { "<M-h>", "<M-l>", "<M-j>", "<M-k>" },
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
    config = [[require("configs.utils").map("n", "gx", "<Plug>(openbrowser-smart-search)")]],
  })

  -- https://github.com/blackCauldron7/surround.nvim
  -- keep an eye on this thing
  use({
    "monkoose/matchparen.nvim",
    keys = "%",
    config = function()
      require("matchparen").setup()
      require("matchparen.matchpairs").disable()
      require("matchparen.matchpairs").enable()
    end,
  })
  use({ "MunifTanjim/nui.nvim", module_pattern = "nui.*" })
  use({
    "stevearc/dressing.nvim",
    requires = { "MunifTanjim/nui.nvim" },
    event = "CursorHold",
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
      vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
        callback = function()
          require("nvim-lightbulb").update_lightbulb()
        end,
      })
    end,
  })
  use({ "Pocco81/HighStr.nvim", cmd = { "HSHighlight", "HSRmHighlight", "HSImport", "HSExport" } }) -- https://github.com/Pocco81/HighStr.nvim
  use({
    "monaqa/dial.nvim",
    setup = [[require('configs.dial')]],
    keys = { { "n", "<C-a>" }, { "n", "<C-x>" }, { "v", "<C-a>" }, { "v", "<C-x>" }, { "v", "g" } },
  })
  use({ "ggandor/lightspeed.nvim", after = "vim-repeat", event = "CursorHold" })
  use({ "machakann/vim-sandwich", config = [[require("configs.vim-sandwich")]] })

  -- use({ "tweekmonster/startuptime.vim", cmd = "StartupTime" })
  use({ "dstein64/vim-startuptime", cmd = "StartupTime" })

  use({
    "j-hui/fidget.nvim",
    after = "nvim-lsp-installer",
    config = [[require("fidget").setup({sources = {["null-ls"] = {ignore = true}}})]],
  })
  -- Should be the last plugin, or the setup needs to go in init.lua after plugins happen
  use({ "norcalli/nvim-colorizer.lua", after = "indent-blankline.nvim", config = [[require("colorizer").setup()]] })
  use({ "kevinhwang91/nvim-hlslens", event = "CursorMoved", config = [[require("configs.nvim-hlslens")]] })

  if packer_init.first_install then
    packer.sync()
  end
end)
