require("nvim-treesitter.configs").setup({
  autotag = { enable = true, disable = require("_.large_file").is_large_file },
})
