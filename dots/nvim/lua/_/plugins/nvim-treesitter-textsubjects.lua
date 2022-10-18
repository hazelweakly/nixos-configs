require("nvim-treesitter.configs").setup({
  textsubjects = {
    enable = true,
    disable = require("_.large_file").is_large_file,
    keymaps = {
      ["."] = "textsubjects-smart",
      [";"] = "textsubjects-container-outer",
    },
  },
})
