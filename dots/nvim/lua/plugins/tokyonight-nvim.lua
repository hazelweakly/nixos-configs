return {
  "folke/tokyonight.nvim",
  priority = 1000,
  config = function()
    vim.cmd([[colorscheme tokyonight]])
    vim.api.nvim_create_autocmd({ "User LazyDone" }, {
      callback = function()
        require("configs.colors").setup()
      end,
      once = true,
    })
  end,
}
