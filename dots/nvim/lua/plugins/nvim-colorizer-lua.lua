return {
  "NvChad/nvim-colorizer.lua",
  ft = { "css" },
  config = function()
    require("colorizer").setup({
      filetypes = { "css" },
      user_default_options = { css = true },
    })
    vim.cmd("ColorizerAttachToBuffer")
  end,
}
