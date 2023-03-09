return {
  "windwp/nvim-ts-autotag",
  dependencies = { "nvim-treesitter" },
  config = function()
    require("nvim-treesitter.configs").setup({
      autotag = { enable = true },
    })
  end,
}
