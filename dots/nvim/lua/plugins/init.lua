return {
  "folke/lazy.nvim",
  { "direnv/direnv.vim", enabled = false },
  { "simrat39/rust-tools.nvim", lazy = true },
  {
    "mrcjkb/haskell-tools.nvim",
    -- technically requires telescope if it's available,
    -- but this massively slows down startup
    -- so instead we simply don't load telescope first
    dependencies = { "nvim-lua/plenary.nvim" },
    lazy = true,
  },
  "wsdjeg/vim-fetch",
}
