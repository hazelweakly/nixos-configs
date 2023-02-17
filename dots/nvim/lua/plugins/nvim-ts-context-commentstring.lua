return {
  "JoosepAlviste/nvim-ts-context-commentstring",
  lazy = true,
  dependencies = { "nvim-treesitter" },
  config = function()
    require("nvim-treesitter.configs").setup({
      context_commentstring = {
        enable = true,
        disable = require("_.large_file").is_large_file,
        enable_autocmd = false,
      },
    })
  end,
}
