require("nvim-treesitter.configs").setup({
  matchup = { enable = true, disable_virtual_text = true, disable = require("_.large_file").is_large_file },
})
