-- Compare this all with super stripped plugins list again
-- I should be able to copy the spec table into different configs

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

-- https://zignar.net/2022/10/01/new-lsp-features-in-neovim-08/
-- https://github.com/jayp0521/mason-null-ls.nvim
-- https://github.com/echasnovski/mini.nvim
local spec = mod_spec({
  "wbthomason/packer.nvim",
  "rcarriga/nvim-notify",
  "nvim-lua/plenary.nvim",
  "lewis6991/impatient.nvim",
  "antoinemadec/FixCursorHold.nvim",
  "jedi2610/nvim-rooter.lua",
  "direnv/direnv.vim",
  "folke/tokyonight.nvim",
  "kyazdani42/nvim-web-devicons",
  "nvim-lualine/lualine.nvim",
  "williamboman/mason.nvim",
  "WhoIsSethDaniel/mason-tool-installer.nvim",
  "williamboman/mason-lspconfig.nvim",
  "ray-x/lsp_signature.nvim",
  "folke/lua-dev.nvim",
  { "mickael-menu/zk-nvim", ft = "markdown", module = "zk" },
  "simrat39/rust-tools.nvim",
  "b0o/schemastore.nvim",
  "jose-elias-alvarez/nvim-lsp-ts-utils",
  "lukas-reineke/indent-blankline.nvim",
  "lewis6991/gitsigns.nvim",
  "nvim-treesitter/nvim-treesitter",
  { "p00f/nvim-ts-rainbow", after = "nvim-treesitter" },
  "IndianBoy42/tree-sitter-just",
  after = "nvim-treesitter",
  { "nvim-treesitter/nvim-treesitter-refactor", after = "nvim-treesitter" },
  { "nvim-treesitter/nvim-treesitter-textobjects", after = "nvim-treesitter" },
  { "RRethy/nvim-treesitter-textsubjects", after = "nvim-treesitter" },
  { "windwp/nvim-ts-autotag", after = "nvim-treesitter" },
  "mfussenegger/nvim-treehopper",
  "andymass/vim-matchup",
  "nvim-telescope/telescope.nvim",
  { "nvim-telescope/telescope-fzf-native.nvim", run = "make" },
  "neovim/nvim-lspconfig",
  "rafamadriz/friendly-snippets",
  "hrsh7th/nvim-cmp",
  "L3MON4D3/LuaSnip",
  "danymat/neogen",
  "saadparwaiz1/cmp_luasnip",
  "hrsh7th/cmp-nvim-lsp",
  "hrsh7th/cmp-buffer",
  "hrsh7th/cmp-path",
  "hrsh7th/cmp-cmdline",
  "hrsh7th/cmp-emoji",
  "kdheepak/cmp-latex-symbols",
  "onsails/lspkind-nvim",
  "abecodes/tabout.nvim",
  "windwp/nvim-autopairs",
  { "jose-elias-alvarez/null-ls.nvim", event = "User DirenvLoaded" },
  { "editorconfig/editorconfig-vim", event = "User DirenvLoaded" },
  "ethanholz/nvim-lastplace",
  "junegunn/vim-easy-align",
  { "lambdalisue/suda.vim", cmd = "W" },
  { "gaoDean/autolist.nvim" },
  "wsdjeg/vim-fetch",
  { "907th/vim-auto-save", event = "FocusLost" },
  "tpope/vim-repeat",
  "wellle/targets.vim",
  { "lervag/vimtex", ft = { "latex", "tex" } },
  { "knubie/vim-kitty-navigator", run = "cp ./*.py ~/.config/kitty/" },
  "numToStr/Comment.nvim",
  { "JoosepAlviste/nvim-ts-context-commentstring", after = "nvim-treesitter" },
  "tyru/open-browser.vim",
  "MunifTanjim/nui.nvim",
  "stevearc/dressing.nvim",
  "akinsho/bufferline.nvim",
  { "kosayoda/nvim-lightbulb", event = "User DirenvLoaded" },
  { "Pocco81/HighStr.nvim", cmd = { "HSHighlight", "HSRmHighlight", "HSImport", "HSExport" } }, -- https://github.com/Pocco81/HighStr.nvim
  {
    "monaqa/dial.nvim",
    keys = {
      { "n", "<C-a>" },
      { "n", "<C-x>" },
      { "v", "<C-a>" },
      { "v", "<C-x>" },
      { "v", "g<C-a>" },
      { "v", "g<C-x>" },
    },
  },
  -- re-evaluate https://github.com/kylechui/nvim-surround
  "machakann/vim-sandwich",
  { "tweekmonster/startuptime.vim", cmd = "StartupTime" },
  -- { "dstein64/vim-startuptime", cmd = "StartupTime" },

  { "j-hui/fidget.nvim", event = "User DirenvLoaded" },
  { "akinsho/git-conflict.nvim" },
  { "norcalli/nvim-colorizer.lua" },
  { "kevinhwang91/nvim-hlslens", event = "CursorMoved" },
  "mfussenegger/nvim-dap",
  "rcarriga/nvim-dap-ui",
})
return packer.startup(spec)
