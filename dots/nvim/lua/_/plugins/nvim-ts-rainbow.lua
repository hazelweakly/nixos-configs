require("nvim-treesitter.configs").setup({
  rainbow = { enable = true, disable = require("_.large_file").is_large_file, extended_mode = true },
})
