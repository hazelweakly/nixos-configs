require("nvim-treesitter.configs").setup({
  refactor = { highlight_definitions = { enable = true, disable = require("_.large_file").is_large_file } },
})
