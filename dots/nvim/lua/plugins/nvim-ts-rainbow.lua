return {
  "p00f/nvim-ts-rainbow",
  dependencies = { "nvim-treesitter" },
  config = function()
    require("nvim-treesitter.configs").setup({
      rainbow = { enable = true, disable = require("_.large_file").is_large_file, extended_mode = true },
    })
  end,
}
