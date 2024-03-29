-- TODO: https://github.com/stevearc/oil.nvim
return {
  "folke/lazy.nvim",
  { "MunifTanjim/nui.nvim", lazy = true },
  { "direnv/direnv.vim", enabled = false },
  { "mickael-menu/zk-nvim", lazy = true },
  { "simrat39/rust-tools.nvim", lazy = true },
  { "nvim-lua/plenary.nvim", lazy = true },
  { "ethanholz/nvim-lastplace", opts = {}, event = "BufReadPre" },
  { "notjedi/nvim-rooter.lua", config = true, event = "BufReadPost" },
  { "nvim-tree/nvim-web-devicons", lazy = true },
  { "tyru/open-browser.vim", keys = { { "gx", "<Plug>(openbrowser-smart-search)" } } },
  -- { "IndianBoy42/tree-sitter-just", config = true, lazy = true },
  { "windwp/nvim-autopairs", event = "InsertEnter", opts = { check_ts = true } },
  {
    "mrcjkb/haskell-tools.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    lazy = true,
  },
  { "folke/neodev.nvim", opts = { lspconfig = false }, lazy = true },
  { "b0o/schemastore.nvim", lazy = true },
  "wsdjeg/vim-fetch",
}
