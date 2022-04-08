-- https://github.com/akinsho/dotfiles/blob/main/.config/nvim/lua/as/plugins/init.lua
local present, packer_init = pcall(require, "configs.packerInit")
if not present then
  return false
end
local packer = packer_init.packer

local function mod_spec(spec)
  for idx, v in ipairs(spec) do
    if type(v) == "string" then
      spec[idx] = {}
      table.insert(spec[idx], v)
      v = spec[idx]
    end
    if type(v) == "table" then
      if v.config == nil then
        local i = string.find(v[1], "/")
        local config_mod = string.sub(v[1], i + 1):lower():gsub("[%._]", "-")
        local config_file = string.format("%s/lua/_/plugins/%s.lua", vim.fn.stdpath("config"), config_mod)
        if vim.fn.filereadable(config_file) == 1 then
          v.config = string.format('require("_.plugins.%s")', config_mod)
        end
      end
      if v.setup == nil then
        local i = string.find(v[1], "/")
        local config_mod = "setup_" .. string.sub(v[1], i + 1):lower():gsub("[%._]", "-")
        local setup_file = string.format("%s/lua/_/plugins/%s.lua", vim.fn.stdpath("config"), config_mod)
        if vim.fn.filereadable(setup_file) == 1 then
          v.setup = string.format('require("_.plugins.%s")', config_mod)
        end
      end
    end
  end
  local tbl = {}
  table.insert(tbl, spec)
  return tbl
end

local function load_if_small_file()
  return not require("_.large_file").is_large_file()
end

local spec = mod_spec({
  { "wbthomason/packer.nvim", opt = true },
  "rcarriga/nvim-notify",
  { "nvim-lua/plenary.nvim", module = "plenary" },
  "lewis6991/impatient.nvim",
  "antoinemadec/FixCursorHold.nvim",
  "jedi2610/nvim-rooter.lua",
  { "hazelweakly/direnv.vim", after = "nvim-rooter.lua" },
  { "folke/tokyonight.nvim", requires = "plenary.nvim", module = "tokyonight" },
  {
    "kyazdani42/nvim-web-devicons",
    module = "nvim-web-devicons",
    cond = load_if_small_file,
    opt = true,
  },
  {
    "nvim-lualine/lualine.nvim",
    after = { "nvim-web-devicons", "tokyonight.nvim" },
  },

  -- also benchmark actual time to startup vim in an empty directory.
  {
    "williamboman/nvim-lsp-installer",
    event = "User DirenvLoaded",
    requires = {
      { "ray-x/lsp_signature.nvim", module = "lsp_signature" },
      { "folke/lua-dev.nvim", module = "lua-dev" },
      { "hrsh7th/cmp-nvim-lsp" },
      { "mickael-menu/zk-nvim", ft = "markdown", module = "zk" },
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
  },
  {
    "lukas-reineke/indent-blankline.nvim",
    after = { "nvim-treesitter", "tokyonight.nvim" },
    cond = load_if_small_file,
    opt = true,
  },
  {
    "lewis6991/gitsigns.nvim",
    requires = "nvim-lua/plenary.nvim",
    cond = load_if_small_file,
    opt = true,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    run = ":TSUpdate",
    requires = {
      { "p00f/nvim-ts-rainbow", after = "nvim-treesitter", opt = true },
      { "IndianBoy42/tree-sitter-just", module = "tree-sitter-just", opt = true },
      { "nvim-treesitter/nvim-treesitter-refactor", after = "nvim-treesitter", opt = true },
      { "nvim-treesitter/nvim-treesitter-textobjects", after = "nvim-treesitter", opt = true },
      { "RRethy/nvim-treesitter-textsubjects", after = "nvim-treesitter", opt = true },
      { "windwp/nvim-ts-autotag", after = "nvim-treesitter", opt = true },
      {
        "andymass/vim-matchup",
        keys = "%",
        after = "nvim-treesitter",
        setup = [[require('_.plugins.setup_vim-matchup')]],
      },
    },
    opt = false,
  },
  {
    "nvim-telescope/telescope.nvim",
    requires = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      { "nvim-telescope/telescope-fzf-native.nvim", run = "make", module = "telescope._extensions.fzf" },
    },
    after = "nvim-treesitter",
    cmd = "Telescope",
    module_pattern = { "telescope.*" },
  },
  { "neovim/nvim-lspconfig", module = "lspconfig" },
  { "rafamadriz/friendly-snippets", module = "cmp_nvim_lsp", event = "InsertEnter" },
  { "hrsh7th/nvim-cmp", after = "friendly-snippets", branch = "dev" },
  { "L3MON4D3/LuaSnip", after = "nvim-cmp", wants = "friendly-snippets" },
  { "danymat/neogen", after = "nvim-cmp", requires = "nvim-treesitter/nvim-treesitter", opt = true },
  { "saadparwaiz1/cmp_luasnip", after = "LuaSnip" },
  { "hrsh7th/cmp-nvim-lsp", after = "cmp_luasnip" },
  { "hrsh7th/cmp-buffer", after = "cmp-nvim-lsp" },
  { "hrsh7th/cmp-path", after = "cmp-nvim-lsp" },
  { "hrsh7th/cmp-cmdline", after = "cmp-nvim-lsp" },
  { "hrsh7th/cmp-emoji", after = "cmp-nvim-lsp" },
  { "f3fora/cmp-nuspell", after = "cmp-nvim-lsp", opt = true },
  { "kdheepak/cmp-latex-symbols", after = "cmp-nvim-lsp" },
  { "onsails/lspkind-nvim", module = "lspkind" },
  { "abecodes/tabout.nvim", module = "tabout", wants = "nvim-treesitter", after = "nvim-cmp" },
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    after = { "nvim-cmp", "nvim-treesitter" },
    wants = "tabout.nvim",
  },
  { "Olical/conjure", ft = "clojure", opt = true },
  {
    "jose-elias-alvarez/null-ls.nvim",
    requires = { "nvim-lua/plenary.nvim" },
    event = "User DirenvLoaded",
    after = "nvim-rooter.lua",
  },
  { "editorconfig/editorconfig-vim", event = "User DirenvLoaded", after = "nvim-rooter.lua" },
  "ethanholz/nvim-lastplace",
  "junegunn/vim-easy-align",
  { "lambdalisue/suda.vim", cmd = "W" },
  { "dkarter/bullets.vim", ft = { "markdown", "text", "gitcommit" }, opt = true },
  "wsdjeg/vim-fetch",
  { "907th/vim-auto-save", event = "FocusLost" },
  { "tpope/vim-repeat", opt = true },
  { "wellle/targets.vim", after = "vim-repeat", opt = true },
  { "lervag/vimtex", ft = { "latex", "tex" }, opt = true },
  {
    "knubie/vim-kitty-navigator",
    run = "cp ./*.py ~/.config/kitty/",
    keys = { "<M-h>", "<M-l>", "<M-j>", "<M-k>" },
  },

  {
    "numToStr/Comment.nvim",
    keys = { { "n", "gc" }, { "v", "gc" } },
    requires = {
      { "JoosepAlviste/nvim-ts-context-commentstring", module = "ts_context_commentstring" },
    },
  },

  { "tyru/open-browser.vim", event = "CursorHold" },
  { "MunifTanjim/nui.nvim", module_pattern = "nui.*" },
  { "stevearc/dressing.nvim", requires = { "MunifTanjim/nui.nvim" }, opt = true, wants = { "telescope.nvim" } },
  { "akinsho/bufferline.nvim", wants = { "nvim-web-devicons", "tokyonight.nvim" }, opt = true },
  { "kosayoda/nvim-lightbulb", event = "User DirenvLoaded" },
  { "Pocco81/HighStr.nvim", cmd = { "HSHighlight", "HSRmHighlight", "HSImport", "HSExport" } }, -- https://github.com/Pocco81/HighStr.nvim
  {
    "monaqa/dial.nvim",
    keys = { { "n", "<C-a>" }, { "n", "<C-x>" }, { "v", "<C-a>" }, { "v", "<C-x>" }, { "v", "g" } },
  },
  { "machakann/vim-sandwich", opt = true },

  { "tweekmonster/startuptime.vim", cmd = "StartupTime" },
  -- { "dstein64/vim-startuptime", cmd = "StartupTime" },

  { "j-hui/fidget.nvim", after = "nvim-lsp-installer", event = "User DirenvLoaded" },
  { "rhysd/conflict-marker.vim", after = "gitsigns.nvim", opt = true },
  { "norcalli/nvim-colorizer.lua", after = "indent-blankline.nvim", opt = true },
  { "kevinhwang91/nvim-hlslens", event = "CursorMoved", opt = true },
})
return packer.startup(spec)
