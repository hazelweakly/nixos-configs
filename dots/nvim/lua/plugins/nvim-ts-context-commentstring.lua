return {
  "JoosepAlviste/nvim-ts-context-commentstring",
  -- event = "VeryLazy",
  lazy = true,
  dependencies = { "nvim-treesitter" },
  config = function()
    return {
      context_commentstring = {
        enable = true,
        enable_autocmd = false,
      },
    }
  end,
}
