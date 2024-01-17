return {
  "folke/tokyonight.nvim",
  priority = 1000,
  config = function()
    vim.api.nvim_create_autocmd({ "User" }, {
      pattern = "VeryLazy",
      callback = function()
        require("configs.colors").setup()
        vim.defer_fn(function()
          require("configs.colors").setup()
        end, 100)
      end,
      once = true,
    })
  end,
}
