return {
  "windwp/nvim-ts-autotag",
  ft = { "html", "typescriptreact" },
  dependencies = { "nvim-treesitter" },
  config = function()
    require("nvim-treesitter.configs").setup({
      autotag = { enable = true },
    })
  end,
}
