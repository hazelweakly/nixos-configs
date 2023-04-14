return {
  "windwp/nvim-ts-autotag",
  event = "VeryLazy",
  dependencies = { "nvim-treesitter" },
  config = function()
    require("nvim-treesitter.configs").setup({
      autotag = { enable = true },
    })
  end,
}
