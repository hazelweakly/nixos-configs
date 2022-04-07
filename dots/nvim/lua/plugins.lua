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
        -- print("config mod", config_mod)
        local config_file = string.format("%s/lua/_/plugins/%s.lua", vim.fn.stdpath("config"), config_mod)
        if vim.fn.filereadable(config_file) == 1 then
          v.config = string.format('require("_.plugins.%s")', config_mod)
        end
      end
      -- too complex to fix. I think this might eventually be better handled by
      -- somehow getting packer to do it when requiring plugins for the first time
      --
      -- if type(v.requires) == "table" then
      --   v.requires = mod_spec(v.requires)
      -- end
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
    event = "CursorHold",
    after = { "nvim-treesitter", "tokyonight.nvim" },
    cond = load_if_small_file,
  },
  {
    "lewis6991/gitsigns.nvim",
    requires = "nvim-lua/plenary.nvim",
    opt = true,
    setup = function()
      require("configs.utils").packer_lazy_load("gitsigns.nvim", 100)
    end,
    cond = load_if_small_file,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    run = ":TSUpdate",
    event = "BufWinEnter",
    module_pattern = { "nvim-treesitter.*", "nvim-treesitter" },
    requires = {
      { "p00f/nvim-ts-rainbow", event = "BufWinEnter", wants = "nvim-treesitter" },
      { "IndianBoy42/tree-sitter-just", module = "tree-sitter-just" },
      { "nvim-treesitter/nvim-treesitter-refactor", after = "nvim-treesitter" },
      { "nvim-treesitter/nvim-treesitter-textobjects", after = "nvim-treesitter" },
      { "RRethy/nvim-treesitter-textsubjects", after = "nvim-treesitter" },
      { "windwp/nvim-ts-autotag", after = "nvim-treesitter" },
    },
    cond = load_if_small_file,
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
    module_pattern = "telescope.*",
    setup = [[require("configs.telescope")]],
  },
  { "neovim/nvim-lspconfig", module = "lspconfig" },
  { "rafamadriz/friendly-snippets", module = "cmp_nvim_lsp", event = "InsertEnter" },
  { "hrsh7th/nvim-cmp", after = "friendly-snippets", branch = "dev" },
  {
    "L3MON4D3/LuaSnip",
    after = "nvim-cmp",
    wants = "friendly-snippets",
  },
  {
    "danymat/neogen",
    after = "nvim-cmp",
    requires = "nvim-treesitter/nvim-treesitter",
  },
  { "saadparwaiz1/cmp_luasnip", after = "LuaSnip" },
  { "hrsh7th/cmp-nvim-lsp", after = "cmp_luasnip" },
  { "hrsh7th/cmp-buffer", after = "cmp-nvim-lsp" },
  { "hrsh7th/cmp-path", after = "cmp-nvim-lsp" },
  { "hrsh7th/cmp-cmdline", after = "cmp-nvim-lsp" },
  { "hrsh7th/cmp-emoji", after = "cmp-nvim-lsp" },
  { "f3fora/cmp-nuspell", after = "cmp-nvim-lsp" },
  { "kdheepak/cmp-latex-symbols", after = "cmp-nvim-lsp" },
  { "onsails/lspkind-nvim", module = "lspkind" },
  { "abecodes/tabout.nvim", module = "tabout", wants = "nvim-treesitter", after = "nvim-cmp" },
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    after = { "nvim-cmp", "nvim-treesitter" },
    wants = "tabout.nvim",
  },
  {
    "Olical/conjure",
    ft = "clojure",
  },
  {
    "jose-elias-alvarez/null-ls.nvim",
    requires = { "nvim-lua/plenary.nvim" },
    event = "CursorHold",
    after = "nvim-rooter.lua",
  },
  { "editorconfig/editorconfig-vim", event = "CursorHold", after = "nvim-rooter.lua" },
  { "ethanholz/nvim-lastplace", event = "BufReadPost" },
  { "junegunn/vim-easy-align", setup = [[require("configs.utils").map("x", "<CR>", "<Plug>(EasyAlign)")]] },
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
  { "lambdalisue/suda.vim", cmd = "W", setup = [=[vim.cmd([[command! W :w suda://%]])]=] },

  {
    "dkarter/bullets.vim",
    ft = { "markdown", "text", "gitcommit" },
  },

  "wsdjeg/vim-fetch",
  {
    "907th/vim-auto-save",
    event = "FocusLost",
    setup = function()
      vim.g.auto_save = 1
      vim.g.auto_save_silent = 1
      vim.g.auto_save_write_all_buffers = 1
      vim.g.auto_save_events = { "FocusLost" }
    end,
  },

  { "tpope/vim-repeat", event = "CursorHold" },
  {
    "wellle/targets.vim",
    after = "vim-repeat",
    event = "CursorHold",
  },
  { "lervag/vimtex", ft = { "latex", "tex" } },
  {
    "knubie/vim-kitty-navigator",
    run = "cp ./*.py ~/.config/kitty/",
    setup = [[vim.g.kitty_navigator_no_mappings = 1]],
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

  -- https://github.com/blackCauldron7/surround.nvim
  -- keep an eye on this thing
  {
    "andymass/vim-matchup",
    keys = "%",
    setup = function()
      vim.g.matchup_override_vimtex = 1
      vim.g.matchup_matchparen_deferred = 1
      vim.g.matchup_surround_enabled = 0
      vim.g.matchup_motion_oerride_Npercent = 0
      vim.g.matchup_matchparen_offscreen = { method = "popup", scrolloff = 1 }
      vim.defer_fn(function()
        require("nvim-treesitter.configs").setup({ matchup = { enable = true } })
      end, 500)
    end,
    requires = "nvim-treesitter",
  },
  { "MunifTanjim/nui.nvim", module_pattern = "nui.*" },
  {
    "stevearc/dressing.nvim",
    requires = { "MunifTanjim/nui.nvim" },
    event = "CursorHold",
    wants = { "telescope.nvim" },
  },
  {
    "akinsho/bufferline.nvim",
    wants = { "nvim-web-devicons", "tokyonight.nvim" },
    event = "BufWinEnter",
  },
  { "kosayoda/nvim-lightbulb", event = "CursorHold" },
  { "Pocco81/HighStr.nvim", cmd = { "HSHighlight", "HSRmHighlight", "HSImport", "HSExport" } }, -- https://github.com/Pocco81/HighStr.nvim
  {
    "monaqa/dial.nvim",
    setup = [[require('configs.dial')]],
    keys = { { "n", "<C-a>" }, { "n", "<C-x>" }, { "v", "<C-a>" }, { "v", "<C-x>" }, { "v", "g" } },
  },
  { "ggandor/lightspeed.nvim", after = "vim-repeat", event = "CursorHold" },
  "machakann/vim-sandwich",

  -- use({ "tweekmonster/startuptime.vim", cmd = "StartupTime" })
  { "dstein64/vim-startuptime", cmd = "StartupTime" },

  { "j-hui/fidget.nvim", after = "nvim-lsp-installer" },
  { "rhysd/conflict-marker.vim", after = "gitsigns.nvim" },
  -- Should be the last plugin, or the setup needs to go in init.lua after plugins happen
  { "norcalli/nvim-colorizer.lua", after = "indent-blankline.nvim" },
  { "kevinhwang91/nvim-hlslens", event = "CursorMoved" },
})
-- print(vim.inspect(spec))
return packer.startup(spec)
