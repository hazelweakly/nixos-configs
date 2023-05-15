return {
  "norcalli/nvim-colorizer.lua",
  ft = { "css" },
  config = function()
    require("colorizer").setup()
  end,
}
