return {
  "nvim-treesitter/nvim-treesitter-refactor",
  dependencies = { "nvim-treesitter" },
  config = function()
    require("nvim-treesitter.configs").setup({
      refactor = { highlight_definitions = { enable = true, disable = require("_.large_file").is_large_file } },
    })
  end,
}
