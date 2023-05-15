return {
  "JoosepAlviste/nvim-ts-context-commentstring",
  event = "CursorMoved",
  dependencies = { "nvim-treesitter" },
  config = function()
    require("nvim-treesitter.configs").setup({
      context_commentstring = { enable = true, enable_autocmd = false },
    })
  end,
}
