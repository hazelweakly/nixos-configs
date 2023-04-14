return {
  "JoosepAlviste/nvim-ts-context-commentstring",
  event = "VeryLazy",
  dependencies = { "nvim-treesitter" },
  config = function()
    require("nvim-treesitter.configs").setup({
      context_commentstring = { enable = true, enable_autocmd = false },
    })
  end,
}
