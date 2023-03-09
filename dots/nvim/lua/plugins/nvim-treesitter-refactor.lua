return {
  "nvim-treesitter/nvim-treesitter-refactor",
  dependencies = { "nvim-treesitter" },
  config = function()
    require("nvim-treesitter.configs").setup({
      refactor = { highlight_definitions = { enable = true } },
    })
  end,
}
