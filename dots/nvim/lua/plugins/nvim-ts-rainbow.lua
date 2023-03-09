return {
  "mrjones2014/nvim-ts-rainbow",
  dependencies = { "nvim-treesitter" },
  config = function()
    require("nvim-treesitter.configs").setup({
      rainbow = { enable = true, extended_mode = true },
    })
  end,
}
