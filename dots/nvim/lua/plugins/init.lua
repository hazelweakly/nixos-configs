return {
  "folke/lazy.nvim",
  { "direnv/direnv.vim", enabled = false },
  { "simrat39/rust-tools.nvim", lazy = true },
  {
    "mrcjkb/haskell-tools.nvim",
    dependencies = { "nvim-lua/plenary.nvim", "nvim-telescope/telescope.nvim" },
    lazy = true,
  },
  "wsdjeg/vim-fetch",
}
